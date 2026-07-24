import QtQuick
import QtTest
import Shadcn

// Toggle unit tests: size scale (height), outline border, and the on/off
// background (bg-muted when checked, transparent otherwise). Appearance is
// asserted by reading the rendered background rectangle's geometry/colors.
Item {
    id: root
    width: 240
    height: 240

    Toggle { id: tDefault; text: "A" }
    Toggle { id: tSm; size: Toggle.Sm; text: "A" }
    Toggle { id: tLg; size: Toggle.Lg; text: "A" }
    Toggle { id: tOutline; variant: Toggle.Outline; text: "A" }

    TestCase {
        name: "Toggle"
        when: windowShown

        function test_defaults() {
            compare(tDefault.checkable, true)
            compare(tDefault.variant, Toggle.Default)
            compare(tDefault.size, Toggle.Default)
            compare(tDefault.implicitHeight, 28)
        }

        // Compact size scale: sm 24 / default 28 / lg 32.
        function test_sizes() {
            compare(tSm.implicitHeight, 24)
            compare(tDefault.implicitHeight, 28)
            compare(tLg.implicitHeight, 32)
        }

        // Outline adds a 1px border; default has none.
        function test_variant_border() {
            compare(tOutline.background.border.width, 1)
            compare(tDefault.background.border.width, 0)
        }

        // Off (not checked / not hovered) -> transparent; on -> bg-muted.
        function test_checked_background() {
            tDefault.checked = false
            compare(tDefault.background.color.a, 0)      // transparent when off
            tDefault.checked = true
            tryCompare(tDefault.background, "color", Theme.muted)  // settles to muted (animated)
            tDefault.checked = false
            tryCompare(tDefault.background, "color", Theme.alpha(Theme.muted, 0))
        }
    }
}
