import QtQuick
import QtTest
import Shadcn

// IconButton unit tests: defaults, enum values (regression guard), the square
// size scale, per-variant background/foreground colors and the outline border,
// plus the StrongFocus policy (#012). Appearance is asserted by reading the
// rendered background rectangle and the control's resolved foreground color;
// all states are at-rest (no hover), so results are deterministic under the
// offscreen platform.
Item {
    id: root
    width: 320
    height: 320

    // Size scale (square, icon-only).
    IconButton { id: bSmall;  size: IconButton.Small;  iconName: "check" }
    IconButton { id: bMedium; iconName: "check" }
    IconButton { id: bLarge;  size: IconButton.Large;  iconName: "check" }

    // Variants (default variant is Ghost).
    IconButton { id: vDefault;     variant: IconButton.Default;     iconName: "check" }
    IconButton { id: vSecondary;   variant: IconButton.Secondary;   iconName: "check" }
    IconButton { id: vOutline;     variant: IconButton.Outline;     iconName: "check" }
    IconButton { id: vGhost;       variant: IconButton.Ghost;       iconName: "check" }
    IconButton { id: vDestructive; variant: IconButton.Destructive; iconName: "check" }

    TestCase {
        name: "IconButton"
        when: windowShown

        function test_defaults() {
            compare(bMedium.variant, IconButton.Ghost)   // icon buttons default to ghost
            compare(bMedium.size, IconButton.Medium)
            compare(bMedium.iconName, "check")
            compare(bMedium.implicitHeight, 28)
            compare(bMedium.implicitWidth, 28)
            compare(bMedium.padding, 0)
            compare(bMedium.enabled, true)
            compare(bMedium.focusPolicy, Qt.StrongFocus) // #012 regression guard
        }

        // Regression guard for enum values. Variant.Default and Size have no
        // shared member name (no #028 collision), and IconButton inherits none
        // of Item.TransformOrigin's names either -- keep the ordering stable
        // because components/demos depend on these numbers.
        function test_enum_values() {
            // Variant
            compare(IconButton.Default, 0)
            compare(IconButton.Secondary, 1)
            compare(IconButton.Outline, 2)
            compare(IconButton.Ghost, 3)
            compare(IconButton.Destructive, 4)
            // Size (Small holds 0; distinct name from Variant.Default so no clash)
            compare(IconButton.Small, 0)
            compare(IconButton.Medium, 1)
            compare(IconButton.Large, 2)
        }

        // Every size is a square whose side matches the icon-* scale.
        function test_sizes_square() {
            compare(bSmall.implicitHeight, 24);  compare(bSmall.implicitWidth, 24)
            compare(bMedium.implicitHeight, 28); compare(bMedium.implicitWidth, 28)
            compare(bLarge.implicitHeight, 32);  compare(bLarge.implicitWidth, 32)
        }

        // Icon glyph size per size step: sm 12 / default 14 / lg 16.
        function test_icon_size() {
            compare(bSmall._iconSize, 12)
            compare(bMedium._iconSize, 14)
            compare(bLarge._iconSize, 16)
        }

        // At-rest background color per variant.
        function test_variant_background() {
            compare(vDefault.background.color, Theme.primary)
            compare(vSecondary.background.color, Theme.secondary)
            // Outline / Ghost have no fill at rest (alpha 0).
            compare(vOutline.background.color.a, 0)
            compare(vGhost.background.color.a, 0)
            // Destructive: destructive/10 fill at rest.
            fuzzyCompare(vDestructive.background.color.a, 0.1, 0.02)
        }

        // Only the Outline variant draws a 1px border.
        function test_variant_border() {
            compare(vOutline.background.border.width, 1)
            compare(vDefault.background.border.width, 0)
            compare(vGhost.background.border.width, 0)
            compare(vSecondary.background.border.width, 0)
            compare(vDestructive.background.border.width, 0)
        }

        // Foreground (icon) color per variant.
        function test_variant_foreground() {
            compare(vDefault._fg, Theme.primaryForeground)
            compare(vSecondary._fg, Theme.secondaryForeground)
            compare(vOutline._fg, Theme.foreground)
            compare(vGhost._fg, Theme.foreground)
            compare(vDestructive._fg, Theme.destructive)
        }

        // All sizes use rounded-md corners.
        function test_radius() {
            compare(bSmall.background.radius, Theme.radiusMd)
            compare(bMedium.background.radius, Theme.radiusMd)
            compare(bLarge.background.radius, Theme.radiusMd)
        }

        // Disabled dims the whole control to 0.5 opacity (matches Button).
        function test_disabled_opacity() {
            compare(bMedium.opacity, 1.0)
            bMedium.enabled = false
            compare(bMedium.opacity, 0.5)
            bMedium.enabled = true
            compare(bMedium.opacity, 1.0)
        }
    }
}
