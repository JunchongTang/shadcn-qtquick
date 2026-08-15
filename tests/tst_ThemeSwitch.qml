import QtQuick
import QtTest
import Shadcn

// Colour transitions must not play while the palette itself is turning over.
// Every token changes at once, but only properties carrying a Behavior ramp, so
// an animated component is left holding the old scheme on a surface that has
// already repainted -- an input keeping its dark border on a page gone white.
// Theme.dark is a plain flag here rather than a platform style hint, so this is
// deterministic under the offscreen platform.
Item {
    id: root
    width: 320
    height: 240

    Input { id: input; width: 200 }
    Button { id: button; text: "Save" }

    TestCase {
        name: "ThemeSwitch"
        when: windowShown

        // Theme is a singleton: anything a case writes leaks into the ones
        // that follow, and QuickTest runs them in alphabetical order.
        function init() {
            Theme.resetTheme()
            Theme.dark = false
            wait(80)
        }

        function cleanupTestCase() {
            Theme.resetTheme()
            Theme.dark = false
            wait(80)
        }

        function test_dark_toggle_lands_in_one_frame() {
            compare(button.background.color, Theme.primary)
            compare(input.background.border.color, Theme.input)

            Theme.dark = true
            wait(16)
            compare(button.background.color, Theme.primary,
                    "one frame after the toggle the fill should already be dark; "
                    + "anything in between means the ramp played")
            compare(input.background.border.color, Theme.input,
                    "and the same for an animated border")

            Theme.dark = false
            wait(16)
            compare(button.background.color, Theme.primary, "and on the way back")
            compare(input.background.border.color, Theme.input)
        }

        function test_gate_closes_and_reopens() {
            Theme.dark = true
            verify(!Theme.animateColors,
                   "transitions should be off for the turn the palette changes in")
            tryVerify(() => Theme.animateColors, 1000,
                      "and back on, or hover feedback would stay dead")
        }

        // Wholesale token changes are the same class of event as a dark toggle.
        function test_bulk_token_changes_also_close_the_gate() {
            Theme.setToken("secondary", "#ff0000", false)
            wait(80)

            Theme.resetTheme()
            verify(!Theme.animateColors, "resetTheme replaces every override at once")
            tryVerify(() => Theme.animateColors, 1000)

            verify(Theme.importJson('{"light":{"secondary":"#00ff00"},"dark":{},"radius":-1}'))
            verify(!Theme.animateColors, "importJson does too")
            tryVerify(() => Theme.animateColors, 1000)
        }
    }
}
