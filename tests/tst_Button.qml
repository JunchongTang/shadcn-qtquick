import QtQuick
import QtTest
import Shadcn

// Button unit tests: defaults, the compact size scale (heights + icon-only
// squareness), per-variant background and foreground colors, and a regression
// guard that Variant/Size still start at 0 (the enum-ordering / collision bug).
// Appearance is asserted by reading the rendered background rectangle and the
// control's resolved foreground color; all states are at-rest (no hover), so
// results are deterministic under the offscreen platform.
Item {
    id: root
    width: 320
    height: 320

    // Size scale (text buttons).
    Button { id: bXs; size: Button.Xs; text: "A" }
    Button { id: bSm; size: Button.Sm; text: "A" }
    Button { id: bDefault; text: "A" }
    Button { id: bLg; size: Button.Lg; text: "A" }

    // Icon-only sizes (square).
    Button { id: bIconXs; size: Button.IconXs; iconName: "check" }
    Button { id: bIconSm; size: Button.IconSm; iconName: "check" }
    Button { id: bIcon; size: Button.Icon; iconName: "check" }
    Button { id: bIconLg; size: Button.IconLg; iconName: "check" }

    // Variants.
    Button { id: vDefault; text: "A" }
    Button { id: vSecondary; variant: Button.Secondary; text: "A" }
    Button { id: vOutline; variant: Button.Outline; text: "A" }
    Button { id: vGhost; variant: Button.Ghost; text: "A" }
    Button { id: vDestructive; variant: Button.Destructive; text: "A" }
    Button { id: vLink; variant: Button.Link; text: "A" }

    TestCase {
        name: "Button"
        when: windowShown

        function test_defaults() {
            compare(bDefault.variant, Button.Default)
            compare(bDefault.size, Button.Default)
            compare(bDefault.implicitHeight, 28)
            compare(bDefault.loading, false)
            compare(bDefault.enabled, true)
            compare(bDefault.rounded, false)
            compare(bDefault.focusPolicy, Qt.StrongFocus) // #012 regression guard
        }

        // Regression guard for the enum-collision bug (#028). QML flattens both
        // enums into the type scope, so the name shared by Variant and Size
        // (Default) must resolve to 0 in both -- keep Default first everywhere.
        function test_enum_ordering() {
            compare(Button.Default, 0) // Variant.Default and Size.Default both 0
            // Variant values (stable; components/demos depend on them).
            compare(Button.Secondary, 1)
            compare(Button.Outline, 2)
            compare(Button.Ghost, 3)
            compare(Button.Destructive, 4)
            compare(Button.Link, 5)
            // Size values (no name collides with Variant except Default).
            compare(Button.Sm, 1)
            compare(Button.Lg, 2)
            compare(Button.Xs, 3)
            compare(Button.Icon, 4)
            compare(Button.IconSm, 5)
            compare(Button.IconXs, 6)
            compare(Button.IconLg, 7)
        }

        // Compact height scale: xs 20 / sm 24 / default 28 / lg 32.
        function test_sizes() {
            compare(bXs.implicitHeight, 20)
            compare(bSm.implicitHeight, 24)
            compare(bDefault.implicitHeight, 28)
            compare(bLg.implicitHeight, 32)
        }

        // Icon-only sizes are square and match the height scale.
        function test_icon_only_square() {
            compare(bIconXs.implicitHeight, 20); compare(bIconXs.implicitWidth, 20)
            compare(bIconSm.implicitHeight, 24); compare(bIconSm.implicitWidth, 24)
            compare(bIcon.implicitHeight, 28);   compare(bIcon.implicitWidth, 28)
            compare(bIconLg.implicitHeight, 32); compare(bIconLg.implicitWidth, 32)
        }

        // At-rest background color per variant.
        function test_variant_background() {
            compare(vDefault.background.color, Theme.primary)
            compare(vSecondary.background.color, Theme.secondary)
            // Outline / Ghost / Link have no fill at rest (alpha 0).
            compare(vOutline.background.color.a, 0)
            compare(vGhost.background.color.a, 0)
            compare(vLink.background.color.a, 0)
            // Destructive: destructive/10 fill at rest.
            fuzzyCompare(vDestructive.background.color.a, 0.1, 0.02)
        }

        // Only the Outline variant draws a 1px border.
        function test_variant_border() {
            compare(vOutline.background.border.width, 1)
            compare(vDefault.background.border.width, 0)
            compare(vGhost.background.border.width, 0)
        }

        // Foreground (text/icon) color per variant.
        function test_variant_foreground() {
            compare(vDefault._fg, Theme.primaryForeground)
            compare(vSecondary._fg, Theme.secondaryForeground)
            compare(vOutline._fg, Theme.foreground)
            compare(vGhost._fg, Theme.foreground)
            compare(vDestructive._fg, Theme.destructive)
            compare(vLink._fg, Theme.primary)
        }

        // loading disables interaction unless a consumer overrides enabled.
        function test_loading_disables() {
            bDefault.loading = true
            compare(bDefault.enabled, false)
            bDefault.loading = false
            compare(bDefault.enabled, true)
        }

        // rounded switches to the full (pill) radius.
        function test_rounded_radius() {
            compare(bDefault.background.radius, Theme.radiusMd)
            bDefault.rounded = true
            compare(bDefault.background.radius, Theme.radiusFull)
            bDefault.rounded = false
        }
    }
}
