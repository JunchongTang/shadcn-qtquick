import QtQuick
import QtTest
import Shadcn

// Checkbox unit tests: API defaults, indicator geometry (16px box, radius 4),
// checked/unchecked background + check-glyph visibility, label-less sizing,
// disabled opacity, and the invalid (aria-invalid) state. Appearance is asserted
// by reading rendered geometry/colors; animated colors use tryCompare.
// Deterministic under offscreen; runs in the default light theme (Theme.dark=false).
Item {
    id: root
    width: 320
    height: 320

    Checkbox { id: cbNoText }                       // bare box (table usage)
    Checkbox { id: cbText; text: "Accept terms" }   // labelled
    Checkbox { id: cbChecked; checked: true }
    Checkbox { id: cbDisabled; enabled: false }
    Checkbox { id: cbInvalid; invalid: true }
    Checkbox { id: cbInvalidChecked; invalid: true; checked: true }

    TestCase {
        name: "Checkbox"
        when: windowShown

        // Recursively locate a rendered child by objectName.
        function byName(node, n) {
            for (let i = 0; i < node.children.length; i++) {
                const c = node.children[i]
                if (c.objectName === n)
                    return c
                const r = byName(c, n)
                if (r)
                    return r
            }
            return null
        }

        function test_defaults() {
            compare(cbNoText.checked, false)
            compare(cbNoText.invalid, false)
            compare(cbNoText.spacing, Theme.space2)
            compare(cbNoText.padding, 0)
            compare(cbNoText.focusPolicy, Qt.StrongFocus)
        }

        // 16x16 rounded box anchored at the left edge.
        function test_indicator_geometry() {
            compare(cbNoText.indicator.implicitWidth, 16)
            compare(cbNoText.indicator.implicitHeight, 16)
            compare(cbNoText.indicator.width, 16)
            compare(cbNoText.indicator.height, 16)
            compare(cbNoText.indicator.radius, 4)
            compare(cbNoText.indicator.x, 0)
        }

        // A label-less checkbox collapses to the 16x16 box (no trailing gap);
        // a labelled one grows wider and offsets its text past the box.
        function test_size_with_and_without_label() {
            compare(cbNoText.implicitWidth, 16)
            compare(cbNoText.implicitHeight, 16)
            compare(cbNoText.contentItem.leftPadding, 0)
            verify(cbText.implicitWidth > 16)
            verify(cbText.implicitHeight >= 16)
            compare(cbText.contentItem.leftPadding,
                    cbText.indicator.width + cbText.spacing)
            compare(cbText.contentItem.visible, true)
            compare(cbNoText.contentItem.visible, false)
        }

        // Unchecked (light theme): transparent background, no check glyph.
        function test_unchecked_appearance() {
            compare(cbNoText.indicator.color.a, 0)
            const icon = byName(cbNoText.indicator, "checkIcon")
            verify(icon !== null)
            compare(icon.visible, false)
            compare(cbNoText.indicator.border.color, Theme.input)
        }

        // Checked: background settles to primary and the check glyph shows.
        function test_checked_appearance() {
            const icon = byName(cbChecked.indicator, "checkIcon")
            verify(icon !== null)
            compare(icon.visible, true)
            tryCompare(cbChecked.indicator, "color", Theme.primary)
            compare(cbChecked.indicator.border.color, Theme.primary)
        }

        // Toggling checked flips the glyph and animates the background back.
        function test_toggle() {
            const icon = byName(cbNoText.indicator, "checkIcon")
            cbNoText.checked = true
            compare(icon.visible, true)
            tryCompare(cbNoText.indicator, "color", Theme.primary)
            cbNoText.checked = false
            compare(icon.visible, false)
            tryCompare(cbNoText.indicator, "color", Theme.alpha(Theme.primary, 0))
        }

        // Disabled -> opacity 0.5.
        function test_disabled_opacity() {
            compare(cbDisabled.opacity, 0.5)
            compare(cbNoText.opacity, 1.0)
        }

        // Invalid + unchecked: destructive border and a visible destructive ring.
        function test_invalid_unchecked() {
            const ring = byName(cbInvalid.indicator, "invalidRing")
            verify(ring !== null)
            compare(ring.visible, true)
            compare(cbInvalid.indicator.border.color, Theme.destructive)
            compare(ring.border.color, Theme.alpha(Theme.destructive, 0.2))
        }

        // Invalid + checked keeps the primary border (aria-invalid:aria-checked:border-primary).
        function test_invalid_checked_keeps_primary_border() {
            compare(cbInvalidChecked.indicator.border.color, Theme.primary)
        }

        // Toggling invalid shows/hides the ring; default checkbox has none.
        function test_invalid_ring_visibility() {
            const ring = byName(cbNoText.indicator, "invalidRing")
            verify(ring !== null)
            compare(ring.visible, false)
            cbNoText.invalid = true
            compare(ring.visible, true)
            cbNoText.invalid = false
            compare(ring.visible, false)
        }
    }
}
