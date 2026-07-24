import QtQuick
import QtQuick.Layouts
import QtTest
import Shadcn

// MessageScroller unit tests: defaults, default-child (message) wiring into the
// scrollable column, and the auto-scroll-to-bottom contract. Scroll geometry is
// asserted by reading the backing Flickable (contentY/contentHeight/atYEnd)
// after layout, so the tests stay deterministic under the offscreen platform.
Item {
    id: root
    width: 480
    height: 480

    // Height-constrained scroller whose content overflows the viewport. The last
    // row's height is data-bound so a test can grow the content deterministically.
    property real growH: 120
    property real growH2: 120

    MessageScroller {
        id: ms
        width: 300
        height: 200
        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 120; color: "red" }
        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 120; color: "green" }
        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: root.growH; color: "blue" }
    }

    // autoScroll disabled: must not follow the bottom edge as content grows.
    MessageScroller {
        id: msNoAuto
        autoScroll: false
        width: 300
        height: 200
        x: 320
        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 120 }
        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 120 }
        Rectangle { Layout.fillWidth: true; Layout.preferredHeight: root.growH2 }
    }

    TestCase {
        name: "MessageScroller"
        when: windowShown

        function test_defaults() {
            compare(ms.autoScroll, true)
            compare(msNoAuto.autoScroll, false)
            compare(ms.messageSpacing, Theme.space6)
            compare(ms.contentPadding, Theme.space4)
            verify(ms._flick !== null && ms._flick !== undefined)
        }

        // Default children land in the scrollable column via the `messages` alias.
        function test_content_wiring() {
            verify(ms.messages.length >= 3)
            // The overflowing content must exceed the viewport height.
            tryVerify(function() { return ms._flick.contentHeight > ms._flick.height })
        }

        // On load the viewport pins to the bottom (defaultScrollPosition "end").
        function test_auto_scroll_to_bottom() {
            tryVerify(function() { return ms._flick.atYEnd })
            verify(ms._atBottom)
            fuzzyCompare(ms._flick.contentY,
                         ms._flick.contentHeight - ms._flick.height, 1.0)
        }

        // While pinned at the bottom, growing content keeps the view at the end.
        function test_grow_follows_bottom() {
            tryVerify(function() { return ms._flick.atYEnd })
            var before = ms._flick.contentHeight
            root.growH += 200
            tryVerify(function() { return ms._flick.contentHeight > before })
            tryVerify(function() { return ms._flick.atYEnd })
            verify(ms._atBottom)
        }

        // Scrolling up releases auto-follow: later growth must not yank to bottom.
        function test_scroll_up_releases_follow() {
            ms._flick.contentY = 0
            tryCompare(ms, "_atBottom", false)
            root.growH += 200
            wait(100)
            // Still parked near the top, not re-pinned to the bottom.
            verify(!ms._atBottom)
            verify(ms._flick.contentY < 8)
        }

        // autoScroll: false never follows the bottom edge as content grows.
        function test_no_autoscroll_does_not_follow() {
            // Starts pinned at the bottom (initial scrollToEnd runs regardless).
            tryVerify(function() { return msNoAuto._flick.atYEnd })
            var before = msNoAuto._flick.contentHeight
            root.growH2 += 200
            tryVerify(function() { return msNoAuto._flick.contentHeight > before })
            wait(100)
            // New content added below: no longer at bottom, and it did not jump.
            verify(!msNoAuto._flick.atYEnd)
            tryCompare(msNoAuto, "_atBottom", false)
        }
    }
}
