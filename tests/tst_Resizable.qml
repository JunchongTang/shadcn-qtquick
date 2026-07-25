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
        // takes the remainder minus one handle thickness.
        function test_horizontal_split_sizing() {
            tryCompare(hzP0, "width", 100)
            tryCompare(hzP0, "height", 200)
            // 300 total - 100 sidebar - 8 handle = 192.
            tryCompare(hzP1, "width", 192)
            tryCompare(hzP1, "height", 200)
        }

        // The single handle sits between the two panels; the gap between them
        // equals exactly one handle thickness, confirming presence + position.
        function test_handle_presence_and_position() {
            tryCompare(hzP0, "x", 0)
            var gap = hzP1.x - (hzP0.x + hzP0.width)
            compare(gap, hz._thickness)
        }

        // Vertical split: header keeps its height, body fills the rest minus a handle.
        function test_vertical_split_sizing() {
            tryCompare(vtP0, "height", 80)
            tryCompare(vtP0, "width", 300)
            // 240 total - 80 header - 8 handle = 152.
            tryCompare(vtP1, "height", 152)
            var gap = vtP1.y - (vtP0.y + vtP0.height)
            compare(gap, vt._thickness)
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

        // The styled group exposes the grip and drops the frame.
        function test_with_handle_and_framed_properties() {
            compare(styled.withHandle, true)
            compare(styled.framed, false)
        }
    }
}
