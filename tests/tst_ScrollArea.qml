import QtQuick
import QtQuick.Controls.Basic
import QtTest
import Shadcn

// ScrollArea unit tests: rounded bordered container, content wiring into the
// backing Flickable, vertical/horizontal scroll behaviour (tall/wide content
// becomes scrollable), and thin overlay-scrollbar styling. Scroll geometry is
// asserted by reading ScrollView.contentItem (the Flickable) after layout, and
// styling by reading the scrollbar thumb rectangles, so the tests stay
// deterministic under the offscreen platform (no real input/focus needed).
Item {
    id: root
    width: 480
    height: 480

    // Vertical case: content taller than the viewport (implicitHeight drives
    // ScrollView.contentHeight) so only the vertical axis overflows.
    ScrollArea {
        id: saV
        width: 200
        height: 200
        Item {
            implicitWidth: 180
            implicitHeight: 800
            Rectangle { anchors.fill: parent; color: "gray" }
        }
    }

    // Horizontal case: content wider than the viewport so only the horizontal
    // axis overflows.
    ScrollArea {
        id: saH
        x: 220
        width: 200
        height: 200
        Item {
            implicitWidth: 800
            implicitHeight: 180
            Rectangle { anchors.fill: parent; color: "gray" }
        }
    }

    TestCase {
        name: "ScrollArea"
        when: windowShown

        // Rounded-md bordered container; both scrollbars default to AsNeeded.
        function test_defaults() {
            compare(saV.background.radius, Theme.radiusMd)
            compare(saV.background.border.width, 1)
            compare(saV.background.border.color, Theme.border)
            compare(saV.background.color.a, 0) // transparent fill
            compare(saV.ScrollBar.vertical.policy, ScrollBar.AsNeeded)
            compare(saV.ScrollBar.horizontal.policy, ScrollBar.AsNeeded)
        }

        // The single child lands inside the backing Flickable and drives the
        // scrollable content size.
        function test_content_wiring() {
            verify(saV.contentItem !== null && saV.contentItem !== undefined)
            tryVerify(function() { return saV.contentItem.contentHeight > 0 })
        }

        // Tall content overflows the viewport -> vertically scrollable, and the
        // vertical thumb is shorter than the track (size < 1).
        function test_vertical_scrollable() {
            tryVerify(function() { return saV.contentItem.contentHeight > saV.contentItem.height })
            tryVerify(function() { return saV.ScrollBar.vertical.size < 1.0 })
        }

        // Setting contentY moves the viewport within the scrollable range.
        function test_vertical_scroll_moves() {
            tryVerify(function() { return saV.contentItem.contentHeight > saV.contentItem.height })
            verify(saV.contentItem.atYBeginning)
            var maxY = saV.contentItem.contentHeight - saV.contentItem.height
            saV.contentItem.contentY = maxY
            tryVerify(function() { return saV.contentItem.atYEnd })
            fuzzyCompare(saV.contentItem.contentY, maxY, 1.0)
        }

        // Wide content overflows the viewport -> horizontally scrollable.
        function test_horizontal_scrollable() {
            tryVerify(function() { return saH.contentItem.contentWidth > saH.contentItem.width })
            tryVerify(function() { return saH.ScrollBar.horizontal.size < 1.0 })
        }

        // Vertical thumb: 10px wide (w-2.5), fully rounded, painted with border.
        function test_vertical_scrollbar_styling() {
            var thumb = saV.ScrollBar.vertical.contentItem
            compare(thumb.implicitWidth, 10)
            compare(thumb.radius, Theme.radiusFull)
            compare(thumb.color, Theme.border)
        }

        // Horizontal thumb: 10px tall (h-2.5), fully rounded, painted with border.
        function test_horizontal_scrollbar_styling() {
            var thumb = saH.ScrollBar.horizontal.contentItem
            compare(thumb.implicitHeight, 10)
            compare(thumb.radius, Theme.radiusFull)
            compare(thumb.color, Theme.border)
        }

        // Scrollbars are inset 1px (p-px) to sit inside the rounded border.
        function test_scrollbar_inset() {
            compare(saV.ScrollBar.vertical.anchors.margins, 1)
            compare(saH.ScrollBar.horizontal.anchors.margins, 1)
        }
    }
}
