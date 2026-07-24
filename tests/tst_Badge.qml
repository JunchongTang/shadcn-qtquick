import QtQuick
import QtTest
import Shadcn

// Badge unit tests: defaults, per-variant background/text colors and border,
// and rendered geometry. Appearance is asserted by reading the rendered
// background rectangle (control.background) and the public fgColor. Deterministic
// under the offscreen platform (no hover/focus needed). Theme.dark defaults to
// false, so the light-mode variant colors apply.
Item {
    id: root
    width: 320
    height: 240

    // Explicit implicit-driven sizing so the anchors.fill background has real
    // geometry to assert (a bare Item does not adopt its implicit size).
    component B: Badge {
        text: "Badge"
        width: implicitWidth
        height: implicitHeight
    }

    B { id: bDefault }
    B { id: bSecondary; variant: Badge.Secondary }
    B { id: bOutline; variant: Badge.Outline }
    B { id: bDestructive; variant: Badge.Destructive }
    B { id: bGhost; variant: Badge.Ghost }
    B { id: bLink; variant: Badge.Link }
    B { id: bIcon; iconName: "badge-check" }

    TestCase {
        name: "Badge"
        when: windowShown

        function test_defaults() {
            compare(bDefault.variant, Badge.Default)
            compare(bDefault.text, "Badge")
            compare(bDefault.iconName, "")
            compare(bDefault.trailingIconName, "")
            compare(bDefault.implicitHeight, 20)   // h-5
        }

        // Enum values/names are stable API (referenced by name elsewhere).
        function test_enum_values() {
            compare(Badge.Default, 0)
            compare(Badge.Secondary, 1)
            compare(Badge.Outline, 2)
            compare(Badge.Destructive, 3)
            compare(Badge.Ghost, 4)
            compare(Badge.Link, 5)
        }

        function test_default_colors() {
            compare(bDefault.background.color, Theme.primary)
            compare(bDefault.fgColor, Theme.primaryForeground)
            compare(bDefault.background.border.width, 0)
        }

        function test_secondary_colors() {
            compare(bSecondary.background.color, Theme.secondary)
            compare(bSecondary.fgColor, Theme.secondaryForeground)
            compare(bSecondary.background.border.width, 0)
        }

        // Outline: faint input-tinted fill, foreground text, visible 1px border.
        function test_outline_colors() {
            compare(bOutline.background.color, Theme.alpha(Theme.input, 0.2))
            compare(bOutline.fgColor, Theme.foreground)
            compare(bOutline.background.border.width, 1)
            compare(bOutline.background.border.color, Theme.border)
        }

        // Destructive: faint destructive fill, destructive text, no border.
        function test_destructive_colors() {
            compare(bDestructive.background.color, Theme.alpha(Theme.destructive, 0.1))
            compare(bDestructive.fgColor, Theme.destructive)
            compare(bDestructive.background.border.width, 0)
        }

        // Ghost: transparent fill, foreground text.
        function test_ghost_colors() {
            compare(bGhost.background.color.a, 0)
            compare(bGhost.fgColor, Theme.foreground)
            compare(bGhost.background.border.width, 0)
        }

        // Link: transparent fill, primary text, underlined.
        function test_link_colors() {
            compare(bLink.background.color.a, 0)
            compare(bLink.fgColor, Theme.primary)
            compare(bLink.background.border.width, 0)
        }

        // Rendered geometry: pill is 20px tall, background fills the control,
        // and text padding (px-2 = 8+8) leaves a non-trivial width.
        function test_geometry() {
            compare(bDefault.height, 20)
            compare(bDefault.background.width, bDefault.width)
            compare(bDefault.background.height, 20)
            verify(bDefault.width > 16)
        }

        // A leading icon switches left padding pl-1.5 (6) < px-2 (8), so the
        // same text renders narrower than the icon-free badge is wide by content.
        function test_icon_padding() {
            verify(bIcon._padLeft < bDefault._padLeft)
            compare(bIcon._padLeft, Theme.space1_5)
            compare(bDefault._padLeft, Theme.space2)
        }
    }
}
