import QtQuick
import QtTest
import Shadcn

// Label unit tests: text passthrough, base-mira typography (text-xs, medium,
// foreground) and the disabled dim (opacity 0.5). Deterministic under the
// offscreen platform: no hover/focus/keyboard needed. Theme.dark defaults to
// false, so light-mode foreground applies.
Item {
    id: root
    width: 320
    height: 240

    Label { id: lbl; text: "Username" }
    Label { id: lblDisabled; text: "Disabled"; enabled: false }

    TestCase {
        name: "Label"
        when: windowShown

        function test_text() {
            compare(lbl.text, "Username")
        }

        function test_typography() {
            compare(lbl.font.pixelSize, Theme.textXs)   // text-xs (12)
            compare(lbl.font.weight, Font.Medium)       // font-medium
            compare(lbl.color, Theme.foreground)
        }

        function test_vertical_alignment() {
            compare(lbl.verticalAlignment, Text.AlignVCenter) // items-center
        }

        // group-data-[disabled]/peer-disabled opacity-50, approximated via enabled.
        function test_disabled_opacity() {
            compare(lbl.opacity, 1.0)
            compare(lblDisabled.opacity, 0.5)
        }

        function test_enabled_toggle_opacity() {
            lbl.enabled = false
            compare(lbl.opacity, 0.5)
            lbl.enabled = true
            compare(lbl.opacity, 1.0)
        }
    }
}
