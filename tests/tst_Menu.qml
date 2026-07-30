import QtQuick
import QtTest
import Shadcn

// Menu (DropdownMenu) unit tests. Menu is a Popup-derived container; its items
// exist after component completion, so item text / enabled / checked / colour
// are read without opening. Geometry that depends on layout (item widths) is
// checked after opening the popup, polled with tryCompare because the enter
// transition runs first under the offscreen platform.
//
// Coverage: item text + enabled, checkbox/radio checked state + trailing
// indicator, label + separator, destructive foreground colour, and the width
// regression guard (#021): content width tracks the widest item.
Item {
    id: root
    width: 480
    height: 480

    Menu {
        id: menu

        MenuLabel { id: lbl; text: "My Account" }
        MenuItem { id: itProfile; text: "Profile" }
        MenuItem { id: itApi; text: "API"; enabled: false }
        MenuItem { id: itLong; text: "A considerably longer menu label" }
        MenuItem { id: itShortcut; text: "Save"; shortcut: "S" }
        MenuItem { id: itDestr; text: "Delete"; destructive: true }
        MenuSeparator { id: sep }
        MenuCheckboxItem { id: chkOn; text: "Status Bar"; checked: true }
        MenuCheckboxItem { id: chkOff; text: "Panel"; checked: false }
        MenuRadioItem { id: rTop; text: "Top" }
        MenuRadioItem { id: rBottom; text: "Bottom"; checked: true }
    }

    TestCase {
        name: "Menu"
        when: windowShown

        function init() {
            // Independent of ordering: start closed.
            if (menu.visible)
                menu.close()
            tryCompare(menu, "visible", false)
        }

        // ---- Base defaults inherited from the styled Menu ----
        function test_defaults() {
            compare(menu.modal, false)
            compare(menu.overlap, 0)
            compare(menu.padding, Theme.space1)
        }

        // ---- Plain items: text + enabled ----
        function test_item_text_and_enabled() {
            compare(itProfile.text, "Profile")
            compare(itProfile.enabled, true)
            compare(itApi.text, "API")
            compare(itApi.enabled, false)
            // data-disabled:opacity-50
            compare(itApi.opacity, 0.5)
            compare(itProfile.opacity, 1.0)
            // Shortcut hint is carried on the item.
            compare(itShortcut.shortcut, "S")
        }

        // ---- Destructive item uses the destructive foreground ----
        function test_destructive_color() {
            compare(itDestr.destructive, true)
            compare(itDestr._fg, Theme.destructive)
            // A normal, inactive item stays on the popover foreground.
            compare(itProfile.destructive, false)
            compare(itProfile._fg, Theme.popoverForeground)
        }

        // ---- Checkbox item: checked state drives the trailing indicator ----
        function test_checkbox_checked_and_indicator() {
            // Menu items only realize their indicator once the menu is open.
            menu.open()
            tryVerify(function() { return menu.opened })
            compare(chkOn.checkable, true)
            compare(chkOn.checked, true)
            verify(chkOn.indicator !== null)
            compare(chkOn.indicator.visible, true)   // checked -> CheckIcon shown

            compare(chkOff.checked, false)
            compare(chkOff.indicator.visible, false) // unchecked -> hidden

            // Toggling reflects on the indicator.
            chkOff.checked = true
            compare(chkOff.indicator.visible, true)
            chkOff.checked = false
            compare(chkOff.indicator.visible, false)
        }

        // ---- Radio item: checked state drives the trailing indicator ----
        function test_radio_checked_and_indicator() {
            // Menu items only realize their indicator once the menu is open.
            menu.open()
            tryVerify(function() { return menu.opened })
            compare(rTop.checkable, true)
            compare(rTop.autoExclusive, true)
            compare(rBottom.checked, true)
            compare(rBottom.indicator.visible, true)
            compare(rTop.checked, false)
            compare(rTop.indicator.visible, false)

            // Selecting an item shows its indicator (exclusivity across items is
            // verified on a real target; see the type note).
            rTop.checked = true
            compare(rTop.indicator.visible, true)
            // Restore for ordering independence.
            rTop.checked = false
            rBottom.checked = true
        }

        // ---- Label + separator ----
        function test_label_and_separator() {
            compare(lbl.text, "My Account")
            compare(lbl.inset, false)
            // Separator is a 1px rule filled with the border colour (bg-border).
            compare(sep.contentItem.implicitHeight, 1)
            compare(sep.contentItem.color, Theme.border)
        }

        // ---- Inset shifts the left padding to the inset gutter ----
        function test_inset_padding() {
            compare(itProfile.inset, false)
            compare(itProfile.leftPadding, Theme.space2)
            itProfile.inset = true
            compare(itProfile.leftPadding, 30)   // pl-7.5
            itProfile.inset = false
        }

        // ---- Width sizing: content tracks the widest item (regression #021) ----
        function test_content_width_is_widest_item() {
            wait(0)                 // let text metrics settle
            let maxW = 0
            for (let i = 0; i < menu.count; i++) {
                let it = menu.itemAt(i)
                if (it && it.implicitWidth > maxW)
                    maxW = it.implicitWidth
            }
            verify(maxW > 0)
            compare(menu.contentWidth, maxW)
            // The long label is the widest and must not be clamped to min-width.
            verify(itLong.implicitWidth > itProfile.implicitWidth)
            compare(menu.contentWidth, itLong.implicitWidth)
        }

        // ---- Opening stretches every item to the widest item's width (#021) ----
        function test_open_stretches_items_to_widest() {
            verify(!menu.visible)
            menu.open()
            tryCompare(menu, "visible", true)
            tryCompare(menu, "opened", true)
            // All items share one width, wide enough for the longest label so
            // nothing is elided (the shorter item is not clamped narrower).
            tryVerify(function() { return itProfile.width > 0 })
            compare(itProfile.width, itLong.width)
            verify(itProfile.width >= itLong.implicitWidth)
            menu.close()
            tryCompare(menu, "opened", false)
            tryCompare(menu, "visible", false)
        }
    }
}
