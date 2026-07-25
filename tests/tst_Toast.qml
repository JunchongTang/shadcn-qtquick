import QtQuick
import QtTest
import Shadcn

// Toast / ToastArea unit tests. Because the ListModel, Column, and per-toast
// delegates use internal ids, live toasts are observed by walking the visual
// tree: area.children[0] is the stacking Column, and each delegate Item is
// identified by its `close()` method (the Repeater itself has none). The Toast
// card inside a delegate is found by its Toast-only `_iconName` property.
// Everything is driven through the public API so the tests stay deterministic
// under the offscreen platform; timed dismissal uses tryVerify.
Item {
    id: root
    width: 480
    height: 640

    // Primary area for structural tests. A very long default duration keeps
    // toasts alive so counting/stacking is not raced by auto-dismiss.
    ToastArea {
        id: ta
        anchors.fill: parent
        duration: 100000
    }

    // A fresh area used only to assert enum-derived position defaults/flags.
    ToastArea { id: taDefault; width: 10; height: 10 }
    ToastArea { id: taTopStart; width: 10; height: 10; position: ToastArea.TopStart }
    ToastArea { id: taTopCenter; width: 10; height: 10; position: ToastArea.TopCenter }

    // Standalone Toast cards for icon-mapping and color-fidelity checks.
    Toast { id: tDefault; type: Toast.Default }
    Toast { id: tSuccess; type: Toast.Success }
    Toast { id: tInfo;    type: Toast.Info }
    Toast { id: tWarning; type: Toast.Warning }
    Toast { id: tError;   type: Toast.Error }
    Toast { id: tLoading; type: Toast.Loading }

    TestCase {
        name: "Toast"
        when: windowShown

        // Clear the primary area after each test so counts start from zero.
        function cleanup() {
            ta.dismissAll()
            tryCompare(root, "_taCount", 0)
        }

        // --- helpers -------------------------------------------------------

        // Live toast delegates in an area (filter the Column's children by close()).
        function _toasts(area) {
            var col = area.children[0]
            var out = []
            for (var i = 0; i < col.children.length; i++) {
                var c = col.children[i]
                if (c && typeof c.close === "function")
                    out.push(c)
            }
            return out
        }
        // The Toast card inside a delegate (identified by the _iconName property).
        function _cardOf(slot) {
            for (var i = 0; i < slot.children.length; i++)
                if (slot.children[i]._iconName !== undefined)
                    return slot.children[i]
            return null
        }

        // --- position enum (rename / TransformOrigin-collision guard) ------

        // The renamed members must be a clean sequential 0..5 and must NOT pick
        // up Item.TransformOrigin values (the old TopLeft/BottomRight scheme
        // collided: BottomLeft resolved to 6 and BottomRight to 8).
        function test_position_enum_values() {
            compare(ToastArea.TopStart, 0)
            compare(ToastArea.TopCenter, 1)
            compare(ToastArea.TopEnd, 2)
            compare(ToastArea.BottomStart, 3)
            compare(ToastArea.BottomCenter, 4)
            compare(ToastArea.BottomEnd, 5)
            // Regression guard: not the colliding TransformOrigin numbers.
            verify(ToastArea.BottomStart !== Item.BottomLeft) // 3 vs 6
            verify(ToastArea.BottomEnd !== Item.BottomRight)   // 5 vs 8
        }

        function test_position_default_and_flags() {
            // Default corner is bottom-right (BottomEnd).
            compare(taDefault.position, ToastArea.BottomEnd)
            verify(taDefault._isRight)
            verify(!taDefault._isLeft)
            verify(!taDefault._isTop)

            verify(taTopStart._isTop)
            verify(taTopStart._isLeft)
            verify(!taTopStart._isRight)

            verify(taTopCenter._isTop)
            verify(!taTopCenter._isLeft)
            verify(!taTopCenter._isRight)
        }

        // --- defaults ------------------------------------------------------

        function test_area_defaults() {
            compare(taDefault.duration, 4000)
            compare(taDefault.gap, Theme.space2)
            compare(taDefault.edgeMargin, Theme.space4)
        }

        // --- API creates model entries -------------------------------------

        function test_show_creates_entry() {
            // show() returns this toast's uid. Do not assume it is 0: QuickTest
            // runs test functions alphabetically and cleanup() does not reset the
            // area's private _seq counter, so earlier tests may have advanced it.
            // (uid uniqueness/increment is covered by test_uids_increment.)
            var uid = ta.show("Event has been created")
            verify(uid >= 0)
            // The delegate is instantiated by the Repeater; poll until it exists.
            tryCompare(root, "_taCount", 1)
            var list = _toasts(ta)
            compare(list.length, 1)
            var card = _cardOf(list[0])
            verify(card !== null)
            compare(card.title, "Event has been created")
            compare(card.type, Toast.Default)
        }

        function test_show_opts_propagate() {
            ta.show("Title", { description: "Monday 6pm", actionText: "Undo", type: Toast.Warning })
            tryCompare(root, "_taCount", 1)
            var card = _cardOf(_toasts(ta)[0])
            compare(card.title, "Title")
            compare(card.description, "Monday 6pm")
            compare(card.actionText, "Undo")
            compare(card.type, Toast.Warning)
        }

        // Convenience methods set the matching Toast.Type.
        function test_convenience_types() {
            ta.success("s"); tryCompare(root, "_taCount", 1)
            compare(_cardOf(_toasts(ta)[0]).type, Toast.Success)
            ta.dismissAll(); tryCompare(root, "_taCount", 0)

            ta.error("e"); tryCompare(root, "_taCount", 1)
            compare(_cardOf(_toasts(ta)[0]).type, Toast.Error)
            ta.dismissAll(); tryCompare(root, "_taCount", 0)

            ta.info("i"); tryCompare(root, "_taCount", 1)
            compare(_cardOf(_toasts(ta)[0]).type, Toast.Info)
            ta.dismissAll(); tryCompare(root, "_taCount", 0)

            ta.warning("w"); tryCompare(root, "_taCount", 1)
            compare(_cardOf(_toasts(ta)[0]).type, Toast.Warning)
            ta.dismissAll(); tryCompare(root, "_taCount", 0)

            ta.loading("l"); tryCompare(root, "_taCount", 1)
            compare(_cardOf(_toasts(ta)[0]).type, Toast.Loading)
        }

        // Each show() returns a fresh, increasing uid.
        function test_uids_increment() {
            var a = ta.success("a")
            var b = ta.success("b")
            verify(b > a)
            tryCompare(root, "_taCount", 2)
        }

        // --- stacking ------------------------------------------------------

        // Multiple toasts stack in the Column; later ones sit lower (higher y).
        function test_stacking_order() {
            ta.success("one")
            ta.success("two")
            ta.success("three")
            tryCompare(root, "_taCount", 3)
            var list = _toasts(ta)
            compare(list.length, 3)
            // Wait for the Column to lay the delegates out, then check ordering.
            tryVerify(function() { return list[1].y > list[0].y && list[2].y > list[1].y })
            // Gap between stacked cards matches ta.gap.
            fuzzyCompare(list[1].y - (list[0].y + list[0].height), ta.gap, 1.0)
        }

        // --- auto-dismiss timer --------------------------------------------

        // A short per-toast duration auto-dismisses (dwell Timer -> exit anim -> remove).
        function test_auto_dismiss() {
            ta.show("bye", { duration: 60 })
            tryCompare(root, "_taCount", 1)
            tryVerify(function() { return root._taCount === 0 }, 5000)
        }

        // A long-duration toast is still present after a short wait (timer honored).
        function test_long_duration_persists() {
            ta.show("stay", { duration: 100000 })
            tryCompare(root, "_taCount", 1)
            wait(150)
            compare(root._taCount, 1)
        }

        function test_dismiss_all() {
            ta.success("a"); ta.success("b"); ta.success("c")
            tryCompare(root, "_taCount", 3)
            ta.dismissAll()
            tryCompare(root, "_taCount", 0)
        }

        // --- Toast card fidelity: icons + shared (non-rich) colors ---------

        // base-mira does not enable richColors: every type shares the popover
        // background and the overlay ring border; only the icon differs.
        function test_card_colors_shared() {
            var cards = [tDefault, tSuccess, tInfo, tWarning, tError, tLoading]
            for (var i = 0; i < cards.length; i++) {
                compare(cards[i].color, Theme.popover)
                compare(cards[i].border.color, Theme.overlayRing)
                compare(cards[i].radius, Theme.radiusMd)
            }
        }

        function test_card_icon_mapping() {
            compare(tDefault._iconName, "")
            verify(!tDefault._hasIcon)
            compare(tSuccess._iconName, "circle-check")
            compare(tInfo._iconName, "info")
            compare(tWarning._iconName, "triangle-alert")
            compare(tError._iconName, "octagon-x")
            compare(tLoading._iconName, "loader-circle")
            verify(tSuccess._hasIcon)
        }
    }

    // Live toast count in the primary area, exposed as a bindable property so
    // tryCompare can poll it. Recomputed whenever the Column's child set changes.
    property int _taCount: {
        var col = ta.children[0]
        if (!col)
            return 0
        var n = 0
        var kids = col.children
        for (var i = 0; i < kids.length; i++)
            if (kids[i] && typeof kids[i].close === "function")
                n++
        return n
    }
}
