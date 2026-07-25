import QtQuick
import QtTest
import Shadcn

// Select unit tests: defaults, model/current selection, placeholder, size scale (height),
// trigger border/radius, the trailing chevron, disabled (opacity) and invalid (destructive
// border) states, popup open (tryVerify) and item highlight. Appearance is asserted by
// reading the rendered background/indicator geometry and colors; animated colors use
// tryCompare. Deterministic and offscreen-friendly (Theme.dark stays false).
Item {
    id: root
    width: 360
    height: 360

    Select {
        id: sDefault
        width: 200
        placeholder: "Select a fruit"
        model: ["Apple", "Banana", "Blueberry"]
    }

    Select {
        id: sSm
        width: 200
        size: Select.Sm
        model: ["Apple", "Banana"]
    }

    Select {
        id: sDisabled
        width: 200
        enabled: false
        model: ["Apple"]
    }

    Select {
        id: sInvalid
        width: 200
        invalid: true
        model: ["Error state", "Apple"]
    }

    Select {
        id: sGroups
        width: 200
        textRole: "label"
        model: [
            { header: "Fruits" },
            { label: "Apple" },
            { label: "Banana", disabled: true },
            { separator: true },
            { header: "Vegetables" },
            { label: "Carrot" }
        ]
    }

    TestCase {
        name: "Select"
        when: windowShown

        function init() {
            // Ensure a clean, closed starting state for each test.
            sDefault.currentIndex = 0
            sDefault.popup.close()
        }

        // ---- Defaults ----
        function test_defaults() {
            compare(sDefault.size, Select.Default)
            compare(sDefault.invalid, false)
            compare(sDefault.alignItemWithTrigger, false)
            compare(sDefault.placeholder, "Select a fruit")
            compare(sDefault.implicitHeight, 28)           // data-[size=default]:h-7
            compare(sDefault.font.pixelSize, Theme.textXs)  // text-xs (12)
            compare(sDefault.leftPadding, Theme.space2)     // px-2
            // pr = px-2 + chevron(14) + gap-1.5, clearing the trailing chevron
            compare(sDefault.rightPadding, Theme.space2 + 14 + Theme.space1_5)
        }

        // ---- Enum: Default is 0, Sm is 1 (no TransformOrigin collision breaks it) ----
        function test_enum_values() {
            compare(Select.Default, 0)
            compare(Select.Sm, 1)
        }

        // ---- Model / current selection / displayText ----
        function test_model_selection() {
            compare(sDefault.count, 3)
            sDefault.currentIndex = 1
            compare(sDefault.currentText, "Banana")
            sDefault.currentIndex = 2
            compare(sDefault.currentText, "Blueberry")
            sDefault.currentIndex = 0
            compare(sDefault.currentText, "Apple")
        }

        // ---- Placeholder shows (muted) when nothing is selected ----
        function test_placeholder() {
            sDefault.currentIndex = -1
            compare(sDefault.contentItem.text, "Select a fruit")
            tryCompare(sDefault.contentItem, "color", Theme.mutedForeground)
            sDefault.currentIndex = 0
            compare(sDefault.contentItem.text, "Apple")
            tryCompare(sDefault.contentItem, "color", Theme.foreground)
        }

        // ---- Size scale: default 28 / sm 24, text stays text-xs ----
        function test_sizes() {
            compare(sDefault.implicitHeight, 28)
            compare(sSm.implicitHeight, 24)
            compare(sSm.font.pixelSize, Theme.textXs)       // sm only changes height
        }

        // ---- Trigger border 1px, rounded-md ----
        function test_border_radius() {
            compare(sDefault.background.border.width, 1)
            compare(sDefault.background.radius, Theme.radiusMd)
        }

        // ---- Default (unfocused, valid) border is input-colored (cn-select-trigger: border-input) ----
        function test_border_color_default() {
            tryCompare(sDefault.background.border, "color", Theme.input)
        }

        // ---- Trailing chevron-down; 14px (size-3.5); muted color ----
        function test_chevron() {
            compare(sDefault.indicator.name, "chevron-down")
            compare(sDefault.indicator.size, 14)            // size-3.5
            compare(sDefault.indicator.color, Theme.mutedForeground)
        }

        // ---- Disabled dims to opacity 0.5 ----
        function test_disabled_opacity() {
            compare(sDisabled.enabled, false)
            compare(sDisabled.opacity, 0.5)
            compare(sDefault.opacity, 1.0)
        }

        // ---- Invalid paints the destructive border (light mode: full destructive) ----
        function test_invalid_border() {
            compare(Theme.dark, false)
            tryCompare(sInvalid.background.border, "color", Theme.destructive)
        }

        // ---- Popup opens and closes ----
        function test_popup_open() {
            verify(!sDefault.popup.visible)
            sDefault.popup.open()
            tryVerify(function() { return sDefault.popup.visible })
            // Popup is anchored to the trigger width.
            compare(sDefault.popup.width, sDefault.width)
            sDefault.popup.close()
            tryVerify(function() { return !sDefault.popup.visible })
        }

        // ---- Grouped model: header / separator rows are present and non-selectable ----
        function test_grouped_model() {
            compare(sGroups.count, 6)
            sGroups.popup.open()
            tryVerify(function() { return sGroups.popup.visible })
            var view = sGroups.popup.contentItem
            // The whole 6-row model fits in the popup; force a layout and wait until
            // every delegate this test reads is instantiated. Offscreen, the ListView
            // may create its delegates a frame or two after the popup becomes visible,
            // so poll all needed indices (not just index 0) before reading them.
            view.forceLayout()
            tryVerify(function() {
                return view.itemAtIndex(0) && view.itemAtIndex(1) && view.itemAtIndex(2)
                    && view.itemAtIndex(3) && view.itemAtIndex(5)
            })
            // Header row (index 0) and separator row (index 3) are disabled; items are enabled.
            var header = view.itemAtIndex(0)
            var itemApple = view.itemAtIndex(1)
            var itemDisabled = view.itemAtIndex(2)
            var sep = view.itemAtIndex(3)
            verify(header !== null)
            verify(itemApple !== null)
            verify(itemDisabled !== null)
            verify(sep !== null)
            verify(!header.enabled)             // group label not selectable
            verify(itemApple.enabled)           // normal item selectable
            verify(!itemDisabled.enabled)       // per-item disabled
            compare(itemDisabled.opacity, 0.5)  // data-disabled:opacity-50
            verify(!sep.enabled)                // separator not selectable
            compare(sep.height, 9)              // h-px + my-1
            compare(itemApple.height, sGroups._itemHeight) // min-h-7 (28)
            sGroups.popup.close()
            tryVerify(function() { return !sGroups.popup.visible })
        }

        // ---- Item highlight: an active (hovered / highlighted) row paints the accent
        // background; an inactive row paints nothing. highlightedIndex is read-only on
        // ComboBox, so drive the delegate's highlighted flag directly to exercise the
        // appearance binding. ----
        function test_item_highlight() {
            sDefault.popup.open()
            tryVerify(function() { return sDefault.popup.visible })
            var view = sDefault.popup.contentItem
            view.forceLayout()
            tryVerify(function() { return view.itemAtIndex(1) !== null })
            var row = view.itemAtIndex(1)
            // Inactive by default: background hidden.
            compare(row.hovered, false)
            compare(row.highlighted, false)
            compare(row.background.visible, false)
            // Highlighted -> accent background shown (focus:bg-accent).
            row.highlighted = true
            tryCompare(row.background, "visible", true)
            tryCompare(row.background, "color", Theme.accent)
            row.highlighted = false
            sDefault.popup.close()
            tryVerify(function() { return !sDefault.popup.visible })
        }
    }
}
