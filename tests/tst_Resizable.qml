import QtQuick
import QtQuick.Controls
import QtTest
import Shadcn

// Resizable unit tests: property defaults (withHandle, framed, orientation),
// panel split sizing driven by SplitView attached properties, handle presence
// and position inferred from the gap between adjacent panels, orientation
// (horizontal vs vertical geometry), and minimum/maximum clamping driven via
// the panels' attached-size properties. Panel geometry is asserted by reading
// the laid-out children after layout. Deterministic under QT_QPA_PLATFORM=offscreen.
Item {
    id: root
    width: 640
    height: 640

    // Horizontal group: fixed-size sidebar + filling content, with min/max.
    Resizable {
        id: hz
        width: 300
        height: 200
        orientation: Qt.Horizontal

        Item {
            id: hzP0
            SplitView.preferredWidth: 100
            SplitView.minimumWidth: 60
            SplitView.maximumWidth: 150
        }
        Item {
            id: hzP1
            SplitView.fillWidth: true
            SplitView.minimumWidth: 60
        }
    }

    // Vertical group: fixed-height header + filling body.
    Resizable {
        id: vt
        width: 300
        height: 240
        orientation: Qt.Vertical

        Item {
            id: vtP0
            SplitView.preferredHeight: 80
            SplitView.minimumHeight: 40
        }
        Item {
            id: vtP1
            SplitView.fillHeight: true
            SplitView.minimumHeight: 40
        }
    }

    // A group that opts into the centre grip and turns off the outer frame.
    Resizable {
        id: styled
        width: 300
        height: 200
        withHandle: true
        framed: false

        Item { SplitView.fillWidth: true }
        Item { SplitView.fillWidth: true }
    }

    // Dedicated group for the drag test so mutating its split ratio never leaks
    // into the sizing assertions on hz.
    Resizable {
        id: dragGroup
        width: 300
        height: 200
        orientation: Qt.Horizontal
        Item { id: dgP0; SplitView.preferredWidth: 100; SplitView.minimumWidth: 60; SplitView.maximumWidth: 250 }
        Item { id: dgP1; SplitView.fillWidth: true; SplitView.minimumWidth: 60 }
    }

    TestCase {
        name: "Resizable"
        when: windowShown

        function test_defaults() {
            // withHandle/framed defaults and the default orientation.
            compare(hz.withHandle, false)
            compare(hz.framed, true)
            compare(hz.orientation, Qt.Horizontal)
            // Handle grab thickness is space-2 (8px).
            compare(hz._thickness, 8)
        }

        function test_orientation_enum() {
            // orientation uses the Qt namespace enum, not a colliding local one.
            compare(Qt.Horizontal, 1)
            compare(Qt.Vertical, 2)
            compare(vt.orientation, Qt.Vertical)
        }

        // Horizontal split: preferred sidebar keeps its size, the content panel
        // takes the remainder minus the 1px visible handle (grab area is wider
        // via containmentMask but does not consume layout space).
        function test_horizontal_split_sizing() {
            tryCompare(hzP0, "width", 100)
            tryCompare(hzP0, "height", 200)
            // 300 total - 100 sidebar - 1 handle = 199.
            tryCompare(hzP1, "width", 199)
            tryCompare(hzP1, "height", 200)
        }

        // The single handle sits between the two panels; the visible gap is 1px
        // (the grab area is widened via containmentMask, not layout).
        function test_handle_presence_and_position() {
            tryCompare(hzP0, "x", 0)
            var gap = hzP1.x - (hzP0.x + hzP0.width)
            compare(gap, 1)
        }

        // Vertical split: header keeps its height, body fills the rest minus the
        // 1px handle.
        function test_vertical_split_sizing() {
            tryCompare(vtP0, "height", 80)
            tryCompare(vtP0, "width", 300)
            // 240 total - 80 header - 1 handle = 159.
            tryCompare(vtP1, "height", 159)
            var gap = vtP1.y - (vtP0.y + vtP0.height)
            compare(gap, 1)
        }

        // Requesting a size below the minimum clamps up to minimumWidth.
        function test_minimum_clamped() {
            hzP0.SplitView.preferredWidth = 20
            tryCompare(hzP0, "width", 60)
            // Restore for independence from test ordering.
            hzP0.SplitView.preferredWidth = 100
            tryCompare(hzP0, "width", 100)
        }

        // Requesting a size above the maximum clamps down to maximumWidth.
        function test_maximum_clamped() {
            hzP0.SplitView.preferredWidth = 500
            tryCompare(hzP0, "width", 150)
            hzP0.SplitView.preferredWidth = 100
            tryCompare(hzP0, "width", 100)
        }

        // Dragging the handle resizes the panels. Regression test: a custom
        // SplitView `background` (or any item overlapping the handle) silently
        // suppresses the built-in drag; the frame must stay off the SplitView.
        function test_handle_drag_resizes() {
            tryCompare(dgP0, "width", 100)
            // The 1px handle sits at the 100px boundary; press within its
            // widened (containmentMask) grab area and drag right.
            mouseMove(dragGroup, 100, 100)
            mousePress(dragGroup, 100, 100, Qt.LeftButton)
            for (var i = 1; i <= 8; ++i)
                mouseMove(dragGroup, 100 + i * 5, 100)
            mouseRelease(dragGroup, 140, 100, Qt.LeftButton)
            verify(dgP0.width > 120)
        }

        // The styled group exposes the grip and drops the frame.
        function test_with_handle_and_framed_properties() {
            compare(styled.withHandle, true)
            compare(styled.framed, false)
        }
    }
}
