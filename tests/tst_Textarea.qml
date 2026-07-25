import QtQuick
import QtTest
import Shadcn

// Textarea unit tests: defaults (invalid, focusPolicy, colors, wrapping), the
// compact metrics (min-h-16 floor, px-2/py-2 padding, text-xs), the background
// radius / border width, at-rest fill and border colors for the normal and
// invalid states, placeholder round-trip, disabled opacity (disabled:opacity-50),
// and that the height grows with content above the min-h-16 floor.
// Appearance is asserted by reading the rendered background rectangle; all states
// are at-rest (no real focus, light theme), so results are deterministic under
// the offscreen platform. Animated border color uses tryCompare.
Item {
    id: root
    width: 400
    height: 400

    Textarea { id: taDefault; placeholderText: "Type your message here." }
    Textarea { id: taInvalid; invalid: true; placeholderText: "Error" }
    Textarea { id: taDisabled; enabled: false; text: "x" }

    // Fixed-width specimen with multi-line content to exercise content growth.
    Textarea {
        id: taTall
        width: 200
        text: "line 1\nline 2\nline 3\nline 4\nline 5\nline 6\nline 7\nline 8"
    }

    TestCase {
        name: "Textarea"
        when: windowShown

        function test_defaults() {
            compare(taDefault.invalid, false)
            compare(taDefault.enabled, true)
            compare(taDefault.focusPolicy, Qt.StrongFocus)
            compare(taDefault.color, Theme.foreground)
            compare(taDefault.placeholderTextColor, Theme.mutedForeground)
            compare(taDefault.wrapMode, TextEdit.Wrap)
        }

        // Compact metrics: min-h-16 (64) floor, px-2 (8) / py-2 (8), text-xs.
        // An empty field sits exactly on the min-height floor.
        function test_metrics() {
            compare(taDefault.implicitHeight, 64)
            compare(taDefault.leftPadding, Theme.space2)
            compare(taDefault.rightPadding, Theme.space2)
            compare(taDefault.topPadding, Theme.space2)
            compare(taDefault.bottomPadding, Theme.space2)
            compare(taDefault.font.pixelSize, Theme.textXs)
        }

        // field-sizing-content: multi-line content grows past the 64px floor.
        function test_min_height_grows() {
            verify(taTall.implicitHeight > 64)
            verify(taTall.implicitHeight
                   >= taTall.contentHeight + taTall.topPadding + taTall.bottomPadding)
        }

        // rounded-md background with a 1px border.
        function test_background_shape() {
            compare(taDefault.background.radius, Theme.radiusMd)
            compare(taDefault.background.border.width, 1)
        }

        // At-rest (light, unfocused, valid): bg-input/20 fill, border-input outline.
        function test_colors_normal() {
            compare(taDefault.background.color, Theme.alpha(Theme.input, 0.2))
            compare(taDefault.background.border.color, Theme.input)
        }

        // Invalid: destructive border (light mode, no dark/50 branch).
        function test_colors_invalid() {
            compare(taInvalid.background.border.color, Theme.destructive)
        }

        // Toggling invalid animates the border to destructive and back.
        function test_invalid_toggle() {
            taDefault.invalid = true
            tryCompare(taDefault.background.border, "color", Theme.destructive)
            taDefault.invalid = false
            tryCompare(taDefault.background.border, "color", Theme.input)
        }

        function test_placeholder() {
            compare(taDefault.placeholderText, "Type your message here.")
            taDefault.placeholderText = "Message"
            compare(taDefault.placeholderText, "Message")
            taDefault.placeholderText = "Type your message here."
        }

        // disabled:opacity-50.
        function test_disabled_opacity() {
            compare(taDisabled.opacity, 0.5)
            compare(taDefault.opacity, 1.0)
        }
    }
}
