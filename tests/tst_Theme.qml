import QtQuick
import QtTest
import Shadcn

// Theme unit tests: assert the key design-token values that the whole library
// depends on (radii, spacing, font sizes, focus-ring metrics), verify the
// alpha() helper, and confirm the dark flag swaps the palette. Values are read
// directly from the singleton, so the tests are deterministic under offscreen.
//
// Theme is a QML singleton: Theme.dark is process-global state shared with the
// other tst_*.qml files, which assume light mode. The dark-toggle test always
// restores Theme.dark = false, and cleanup() enforces that after every test.
Item {
    id: root
    width: 320
    height: 240

    TestCase {
        name: "Theme"
        when: windowShown

        // Start every test from a clean singleton: no leaked overrides, light mode.
        function init() {
            Theme.resetTheme()
            Theme.dark = false
        }

        // Never leak dark mode / overrides into sibling test files.
        function cleanup() {
            Theme.resetTheme()
            Theme.dark = false
        }

        // Corner-radius scale: base 10 with the base-mira ratios.
        function test_radius_scale() {
            compare(Theme.radius, 10)
            compare(Theme.radiusSm, 6)    // 10 * 0.6
            compare(Theme.radiusMd, 8)    // 10 * 0.8
            compare(Theme.radiusLg, 10)   // base
            compare(Theme.radiusXl, 14)   // 10 * 1.4
            compare(Theme.radius2xl, 18)  // 10 * 1.8
            compare(Theme.radius3xl, 22)  // 10 * 2.2
            compare(Theme.radius4xl, 26)  // 10 * 2.6
            // Pill radius is a large value so any box renders fully rounded.
            verify(Theme.radiusFull >= 9999)
        }

        // Spacing scale in px (Tailwind spacing = 4px * n, with half steps).
        function test_spacing_scale() {
            compare(Theme.space0_5, 2)
            compare(Theme.space1, 4)
            compare(Theme.space1_5, 6)
            compare(Theme.space2, 8)
            compare(Theme.space2_5, 10)
            compare(Theme.space3, 12)
            compare(Theme.space3_5, 14)
            compare(Theme.space4, 16)
            compare(Theme.space5, 20)
            compare(Theme.space6, 24)
            compare(Theme.space8, 32)
        }

        // Font-size scale in px (Tailwind text-xs..text-4xl).
        function test_font_size_scale() {
            compare(Theme.textXs, 12)
            compare(Theme.textSm, 14)
            compare(Theme.textBase, 16)
            compare(Theme.textLg, 18)
            compare(Theme.textXl, 20)
            compare(Theme.text2xl, 24)
            compare(Theme.text3xl, 30)
            compare(Theme.text4xl, 36)
            compare(Theme.lineRelaxed, 1.625)
        }

        // Focus-ring metrics: 2px stroke at 30% opacity (ring-2 ring-ring/30).
        function test_ring_tokens() {
            compare(Theme.ringWidth, 2)
            compare(Theme.ringOpacity, 0.30)
            // Overlay elevation uses a 1px foreground ring at 10%.
            compare(Theme.overlayRingWidth, 1)
        }

        // Motion durations in ms.
        function test_durations() {
            compare(Theme.durFast, 100)
            compare(Theme.durBase, 150)
        }

        // alpha(c, a) keeps the RGB channels and replaces the alpha channel.
        function test_alpha_helper() {
            var base = Qt.rgba(0.2, 0.4, 0.6, 1.0)
            var out = Theme.alpha(base, 0.25)
            compare(out.r, base.r)
            compare(out.g, base.g)
            compare(out.b, base.b)
            fuzzyCompare(out.a, 0.25, 0.001)
        }

        // overlayRing is the foreground token at 10% opacity, derived via alpha().
        function test_alpha_drives_overlay_ring() {
            fuzzyCompare(Theme.overlayRing.a, 0.10, 0.001)
            compare(Theme.overlayRing.r, Theme.foreground.r)
            compare(Theme.overlayRing.g, Theme.foreground.g)
            compare(Theme.overlayRing.b, Theme.foreground.b)
        }

        // Toggling dark swaps the palette: light and dark values differ, and the
        // active token follows the flag. Restored via cleanup().
        //
        // NOTE: a color read into a JS var is a live handle, not a snapshot -- it
        // re-reads the (bound) property at use time, so it would reflect the mode
        // set *after* capture. Snapshot to a hex string with toString() so the
        // light-mode value is frozen before flipping to dark.
        function test_dark_toggle_swaps_palette() {
            Theme.dark = false
            var lightBg = Theme.background.toString()
            var lightFg = Theme.foreground.toString()
            var lightCard = Theme.card.toString()

            Theme.dark = true
            var darkBg = Theme.background.toString()
            var darkFg = Theme.foreground.toString()
            var darkCard = Theme.card.toString()

            verify(!Qt.colorEqual(lightBg, darkBg))
            verify(!Qt.colorEqual(lightFg, darkFg))
            verify(!Qt.colorEqual(lightCard, darkCard))

            // Sanity: known endpoints for the neutral surface tokens.
            compare(Qt.colorEqual(lightBg, "#ffffff"), true)
            compare(Qt.colorEqual(darkBg, "#0a0a0a"), true)
        }

        // Per-mode override wins over the built-in value and reverts on reset.
        function test_override_layer() {
            Theme.dark = false
            Theme.setToken("primary", "#123456", false)
            compare(Qt.colorEqual(Theme.primary, "#123456"), true)
            Theme.resetTheme()
            compare(Qt.colorEqual(Theme.primary, "#fdc700"), true)
        }
    }
}
