import QtQuick
import QtTest
import Shadcn

// ContextMenu unit tests. ContextMenu is a thin wrapper over Menu that adds a
// `target` property and installs a right-click TapHandler on it. We assert the
// wrapper's added behavior (handler lifecycle bound to target) plus the pieces
// that are deterministic without a real right-click: defaults, the declared
// item model, width sizing inherited from Menu (regression guard for #021),
// and that the popup() API opens the menu at a given position.
Item {
    id: root
    width: 480
    height: 480

    // Right-click target area.
    Item {
        id: area
        x: 0; y: 0
        width: 320
        height: 180
    }

    // Alternate target, used to verify handler re-parenting on target change.
    Item {
        id: area2
        x: 0; y: 200
        width: 320
        height: 180
    }

    ContextMenu {
        id: cm
        target: area
        MenuItem { text: "Back" }
        MenuItem { text: "A much longer label here"; enabled: false }
        MenuItem { text: "Reload" }
    }

    // A ContextMenu left without a target, to check defaults.
    ContextMenu {
        id: cmNoTarget
        MenuItem { text: "Solo" }
    }

    TestCase {
        name: "ContextMenu"
        when: windowShown

        // ---- Defaults ----
        function test_defaults() {
            compare(cmNoTarget.target, null)
            compare(cmNoTarget._handler, null)
            // Menu base defaults are inherited unchanged.
            compare(cm.modal, false)
        }

        // ---- Declared items form the menu model ----
        function test_item_model() {
            compare(cm.count, 3)
            compare(cm.itemAt(0).text, "Back")
            compare(cm.itemAt(1).text, "A much longer label here")
            compare(cm.itemAt(2).text, "Reload")
            // The middle item is disabled as declared.
            compare(cm.itemAt(1).enabled, false)
        }

        // ---- Handler is created on the target when target is set ----
        function test_handler_created_on_target() {
            verify(cm._handler !== null)
            // Right-button TapHandler, attached to the target item.
            compare(cm._handler.acceptedButtons, Qt.RightButton)
            compare(cm._handler.parent, area)
        }

        // ---- Changing target rebuilds the handler on the new target ----
        function test_handler_follows_target() {
            cm.target = area2
            verify(cm._handler !== null)
            compare(cm._handler.parent, area2)

            // Clearing target removes the handler entirely.
            cm.target = null
            compare(cm._handler, null)

            // Restore for independence from test ordering.
            cm.target = area
            verify(cm._handler !== null)
            compare(cm._handler.parent, area)
        }

        // ---- Width sizing: content tracks the widest item (regression #021) ----
        function test_content_width_is_widest_item() {
            wait(0)                 // let item layout / text metrics settle
            var maxW = 0
            for (var i = 0; i < cm.count; i++) {
                var it = cm.itemAt(i)
                if (it && it.implicitWidth > maxW)
                    maxW = it.implicitWidth
            }
            verify(maxW > 0)
            compare(cm.contentWidth, maxW)
            // The longest label must not be clamped to the min-width background.
            verify(cm.contentWidth >= cm.itemAt(1).implicitWidth)
        }

        // ---- popup() at a position opens the menu (mirrors the handler path) ----
        function test_popup_opens_at_position() {
            verify(!cm.visible)
            cm.popup(24, 32)
            // Opening is not synchronous under offscreen (the enter transition
            // runs first), so poll rather than asserting immediately.
            tryCompare(cm, "visible", true)
            tryCompare(cm, "opened", true)
            cm.close()
            tryCompare(cm, "opened", false)
            tryCompare(cm, "visible", false)
        }
    }
}
