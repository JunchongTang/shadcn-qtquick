import QtQuick
import QtTest
import Shadcn

// Input unit tests: defaults (size, padding, font, focusPolicy), the background
// radius / border width, at-rest fill and border colors for the normal and
// invalid states, placeholder round-trip, disabled opacity (disabled:opacity-50),
// and the group-position corner straightening reused from Button.GroupPosition.
// Appearance is asserted by reading the rendered background rectangle; all states
// are at-rest (no real focus, light theme), so results are deterministic under
// the offscreen platform. Animated border color uses tryCompare.
Item {
    id: root
    width: 400
    height: 400

    Input { id: inpDefault; placeholderText: "Enter text" }
    Input { id: inpInvalid; invalid: true; placeholderText: "Error" }
    Input { id: inpDisabled; enabled: false; text: "x" }

    // Group-position specimens (horizontal) for corner assertions.
    Input { id: inpFirst;  groupPosition: Button.GroupFirst }
    Input { id: inpMiddle; groupPosition: Button.GroupMiddle }
    Input { id: inpLast;   groupPosition: Button.GroupLast }

    TestCase {
        name: "Input"
        when: windowShown

        function test_defaults() {
            compare(inpDefault.invalid, false)
            compare(inpDefault.groupPosition, Button.GroupNone)
            compare(inpDefault.groupVertical, false)
            compare(inpDefault.enabled, true)
            compare(inpDefault.focusPolicy, Qt.StrongFocus)
            compare(inpDefault.color, Theme.foreground)
            compare(inpDefault.placeholderTextColor, Theme.mutedForeground)
        }

        // Compact metrics: h-7 (28), px-2 (8) horizontal, 0 vertical, text-xs.
        function test_metrics() {
            compare(inpDefault.implicitHeight, 28)
            compare(inpDefault.leftPadding, Theme.space2)
            compare(inpDefault.rightPadding, Theme.space2)
            compare(inpDefault.topPadding, 0)
            compare(inpDefault.bottomPadding, 0)
            compare(inpDefault.font.pixelSize, Theme.textXs)
        }

        // rounded-md background with a 1px border.
        function test_background_shape() {
            compare(inpDefault.background.radius, Theme.radiusMd)
            compare(inpDefault.background.border.width, 1)
        }

        // At-rest (light, unfocused, valid): bg-input/20 fill, border-input outline.
        function test_colors_normal() {
            compare(inpDefault.background.color, Theme.alpha(Theme.input, 0.2))
            compare(inpDefault.background.border.color, Theme.input)
        }

        // Invalid: destructive border (light mode, no dark/50 branch).
        function test_colors_invalid() {
            compare(inpInvalid.background.border.color, Theme.destructive)
        }

        // Toggling invalid animates the border to destructive and back.
        function test_invalid_toggle() {
            inpDefault.invalid = true
            tryCompare(inpDefault.background.border, "color", Theme.destructive)
            inpDefault.invalid = false
            tryCompare(inpDefault.background.border, "color", Theme.input)
        }

        function test_placeholder() {
            compare(inpDefault.placeholderText, "Enter text")
            inpDefault.placeholderText = "Search"
            compare(inpDefault.placeholderText, "Search")
            inpDefault.placeholderText = "Enter text"
        }

        // disabled:opacity-50.
        function test_disabled_opacity() {
            compare(inpDisabled.opacity, 0.5)
            compare(inpDefault.opacity, 1.0)
        }

        // GroupNone -> every corner rounded.
        function test_corners_none() {
            const r = inpDefault.background.radius
            compare(inpDefault.background.topLeftRadius, r)
            compare(inpDefault.background.topRightRadius, r)
            compare(inpDefault.background.bottomLeftRadius, r)
            compare(inpDefault.background.bottomRightRadius, r)
        }

        // First (horizontal): left corners rounded, right corners straight.
        function test_corners_first() {
            const r = inpFirst.background.radius
            compare(inpFirst.background.topLeftRadius, r)
            compare(inpFirst.background.bottomLeftRadius, r)
            compare(inpFirst.background.topRightRadius, 0)
            compare(inpFirst.background.bottomRightRadius, 0)
        }

        // Last (horizontal): right corners rounded, left corners straight.
        function test_corners_last() {
            const r = inpLast.background.radius
            compare(inpLast.background.topRightRadius, r)
            compare(inpLast.background.bottomRightRadius, r)
            compare(inpLast.background.topLeftRadius, 0)
            compare(inpLast.background.bottomLeftRadius, 0)
        }

        // Middle: every corner straightened.
        function test_corners_middle() {
            compare(inpMiddle.background.topLeftRadius, 0)
            compare(inpMiddle.background.topRightRadius, 0)
            compare(inpMiddle.background.bottomLeftRadius, 0)
            compare(inpMiddle.background.bottomRightRadius, 0)
        }

        // First (vertical): top corners rounded, bottom corners straight.
        function test_corners_first_vertical() {
            inpFirst.groupVertical = true
            const r = inpFirst.background.radius
            compare(inpFirst.background.topLeftRadius, r)
            compare(inpFirst.background.topRightRadius, r)
            compare(inpFirst.background.bottomLeftRadius, 0)
            compare(inpFirst.background.bottomRightRadius, 0)
            inpFirst.groupVertical = false
        }
    }
}
