import QtQuick
import QtTest
import Shadcn

// NativeSelect unit tests: defaults, model/current selection, size scale (height),
// border/radius, disabled (opacity) and invalid (destructive border) states, and the
// trailing chevron-down indicator. Appearance is asserted by reading the rendered
// background/indicator geometry and colors; animated colors use tryCompare.
// Deterministic and offscreen-friendly (Theme.dark stays false).
Item {
    id: root
    width: 320
    height: 320

    NativeSelect {
        id: nsDefault
        width: 200
        placeholder: "Select a fruit"
        model: ["Apple", "Banana", "Blueberry"]
    }

    NativeSelect {
        id: nsSm
        width: 200
        size: NativeSelect.Sm
        model: ["Apple", "Banana"]
    }

    NativeSelect {
        id: nsDisabled
        width: 200
        enabled: false
        model: ["Apple"]
    }

    NativeSelect {
        id: nsInvalid
        width: 200
        invalid: true
        model: ["Error state", "Apple"]
    }

    TestCase {
        name: "NativeSelect"
        when: windowShown

        // ---- Defaults ----
        function test_defaults() {
            compare(nsDefault.size, NativeSelect.Default)
            compare(nsDefault.invalid, false)
            compare(nsDefault.placeholder, "Select a fruit")
            compare(nsDefault.implicitHeight, 28)          // h-7
            compare(nsDefault.font.pixelSize, Theme.textXs) // text-xs (12)
            compare(nsDefault.leftPadding, Theme.space2)    // pl-2
            compare(nsDefault.rightPadding, Theme.space6)   // pr-6
        }

        // ---- Enum: Default is 0, Sm is 1 (no TransformOrigin collision) ----
        function test_enum_values() {
            compare(NativeSelect.Default, 0)
            compare(NativeSelect.Sm, 1)
        }

        // ---- Model and current selection ----
        function test_model_selection() {
            nsDefault.currentIndex = 1
            compare(nsDefault.currentText, "Banana")
            nsDefault.currentIndex = 2
            compare(nsDefault.currentText, "Blueberry")
            nsDefault.currentIndex = 0
        }

        // ---- Size scale: default 28 / sm 24, with smaller text ----
        function test_sizes() {
            compare(nsDefault.implicitHeight, 28)
            compare(nsSm.implicitHeight, 24)
            compare(nsSm.font.pixelSize, 10)               // text-[0.625rem]
        }

        // ---- Border 1px, rounded-md ----
        function test_border_radius() {
            compare(nsDefault.background.border.width, 1)
            compare(nsDefault.background.radius, Theme.radiusMd)
        }

        // ---- Default (unfocused, valid) border is input-colored ----
        function test_border_color_default() {
            tryCompare(nsDefault.background.border, "color", Theme.input)
        }

        // ---- Disabled dims to opacity 0.5 ----
        function test_disabled_opacity() {
            compare(nsDisabled.enabled, false)
            compare(nsDisabled.opacity, 0.5)
            compare(nsDefault.opacity, 1.0)
        }

        // ---- Invalid paints the destructive border (light mode: full destructive) ----
        function test_invalid_border() {
            compare(Theme.dark, false)
            tryCompare(nsInvalid.background.border, "color", Theme.destructive)
        }

        // ---- Trailing chevron-down; 14px default, 12px sm; muted color ----
        function test_chevron() {
            compare(nsDefault.indicator.name, "chevron-down")
            compare(nsDefault.indicator.size, 14)          // size-3.5
            compare(nsSm.indicator.size, 12)               // size-3
            compare(nsDefault.indicator.color, Theme.mutedForeground)
        }
    }
}
