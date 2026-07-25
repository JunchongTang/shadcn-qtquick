import QtQuick
import QtQuick.Controls.Basic
import QtTest
import Shadcn

// ScrollView unit tests: content wiring into the backing Flickable,
// vertical/horizontal scroll behaviour (tall/wide content becomes scrollable),
// and thin overlay-scrollbar styling/policy. Scroll geometry is asserted by
// reading ScrollView.contentItem (the Flickable) after layout, and styling by
// reading the scrollbar thumb rectangles, so the tests stay deterministic under
// the offscreen platform (no real input/focus needed). The idle thumb colour is
// muted-foreground at 40% opacity (ScrollView, unlike ScrollArea's border token).
Item {
    id: root
    width: 480
    height: 480

    // Vertical case: content taller than the viewport (implicitHeight drives
    // ScrollView.contentHeight) so only the vertical axis overflows.
    ScrollView {
        id: svV
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
    ScrollView {
        id: svH
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
        name: "ScrollView"
        when: windowShown

        // Both scrollbars default to AsNeeded; no bordered container (plain).
        function test_defaults() {
            compare(svV.ScrollBar.vertical.policy, ScrollBar.AsNeeded)
            compare(svV.ScrollBar.horizontal.policy, ScrollBar.AsNeeded)
        }

        // The single child lands inside the backing Flickable and drives the
        // scrollable content size.
        function test_content_wiring() {
            verify(svV.contentItem !== null && svV.contentItem !== undefined)
            tryVerify(function() { return svV.contentItem.contentHeight > 0 })
        }

        // Tall content overflows the viewport -> vertically scrollable, and the
        // vertical thumb is shorter than the track (size < 1).
        function test_vertical_scrollable() {
            tryVerify(function() { return svV.contentItem.contentHeight > svV.contentItem.height })
            tryVerify(function() { return svV.ScrollBar.vertical.size < 1.0 })
        }

        // Setting contentY moves the viewport within the scrollable range.
        function test_vertical_scroll_moves() {
            tryVerify(function() { return svV.contentItem.contentHeight > svV.contentItem.height })
            verify(svV.contentItem.atYBeginning)
            var maxY = svV.contentItem.contentHeight - svV.contentItem.height
            svV.contentItem.contentY = maxY
            tryVerify(function() { return svV.contentItem.atYEnd })
            fuzzyCompare(svV.contentItem.contentY, maxY, 1.0)
        }

        // Wide content overflows the viewport -> horizontally scrollable.
        function test_horizontal_scrollable() {
            tryVerify(function() { return svH.contentItem.contentWidth > svH.contentItem.width })
            tryVerify(function() { return svH.ScrollBar.horizontal.size < 1.0 })
        }

        // Vertical thumb: 10px wide (w-2.5), fully rounded, muted-foreground/40 idle.
        function test_vertical_scrollbar_styling() {
            var thumb = svV.ScrollBar.vertical.contentItem
            compare(thumb.implicitWidth, 10)
            compare(thumb.radius, Theme.radiusFull)
            compare(thumb.color, Theme.alpha(Theme.mutedForeground, 0.4))
        }

        // Horizontal thumb: 10px tall (h-2.5), fully rounded, muted-foreground/40 idle.
        function test_horizontal_scrollbar_styling() {
            var thumb = svH.ScrollBar.horizontal.contentItem
            compare(thumb.implicitHeight, 10)
            compare(thumb.radius, Theme.radiusFull)
            compare(thumb.color, Theme.alpha(Theme.mutedForeground, 0.4))
        }

        // Transparent tracks (background) on both axes.
        function test_transparent_tracks() {
            compare(svV.ScrollBar.vertical.background.color.a, 0)
            compare(svH.ScrollBar.horizontal.background.color.a, 0)
        }
    }
}
