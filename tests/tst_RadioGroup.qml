import QtQuick
import QtTest
import Shadcn

// RadioGroup/RadioButton unit tests: API defaults, indicator geometry (16px
// circle, radius 8, dot), single-selection exclusivity within a group, the
// selected dot + fill visibility, label-less vs labelled sizing, disabled
// opacity, and the invalid (aria-invalid) state incl. the invalid+checked
// border rule. Appearance is asserted from rendered geometry/colors; animated
// fills use tryCompare. Deterministic under offscreen; default light theme.
Item {
    id: root
    width: 360
    height: 360

    // Standalone items for geometry/state checks.
    RadioButton { id: rbNoText }                    // bare circle (choice-card usage)
    RadioButton { id: rbText; text: "Comfortable" } // labelled
    RadioButton { id: rbChecked; checked: true }
    RadioButton { id: rbDisabled; enabled: false }
    RadioButton { id: rbInvalid; invalid: true }
    RadioButton { id: rbInvalidChecked; invalid: true; checked: true }

    // A real group to exercise autoExclusive single-selection.
    RadioGroup {
        id: group
        RadioButton { id: g1; text: "A"; checked: true }
        RadioButton { id: g2; text: "B" }
        RadioButton { id: g3; text: "C" }
    }

    TestCase {
        name: "RadioGroup"
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
            compare(rbNoText.checked, false)
            compare(rbNoText.invalid, false)
            compare(rbNoText.spacing, Theme.space2)
            compare(rbNoText.padding, 0)
            compare(rbNoText.focusPolicy, Qt.StrongFocus)
            compare(rbNoText.autoExclusive, true)   // Qt default; drives group exclusivity
        }

        // RadioGroup is a gap-3 column.
        function test_group_spacing() {
            compare(group.spacing, Theme.space3)
        }

        // 16x16 circle (radius 8) anchored at the left edge, with an 8px dot.
        function test_indicator_geometry() {
            compare(rbNoText.indicator.implicitWidth, 16)
            compare(rbNoText.indicator.implicitHeight, 16)
            compare(rbNoText.indicator.width, 16)
            compare(rbNoText.indicator.height, 16)
            compare(rbNoText.indicator.radius, 8)
            compare(rbNoText.indicator.x, 0)
            const dot = byName(rbNoText.indicator, "indicatorDot")
            verify(dot !== null)
            compare(dot.width, 8)
            compare(dot.height, 8)
            compare(dot.radius, 4)
        }

        // Label-less radio collapses to the 16x16 circle (no trailing gap);
        // a labelled one grows wider and offsets its text past the circle.
        function test_size_with_and_without_label() {
            compare(rbNoText.implicitWidth, 16)
            compare(rbNoText.implicitHeight, 16)
            compare(rbNoText.contentItem.leftPadding, 0)
            compare(rbNoText.contentItem.visible, false)
            verify(rbText.implicitWidth > 16)
            compare(rbText.contentItem.visible, true)
            compare(rbText.contentItem.leftPadding,
                    rbText.indicator.width + rbText.spacing)
        }

        // Unselected (light theme): transparent fill, no dot, input border.
        function test_unchecked_appearance() {
            compare(rbNoText.indicator.color.a, 0)
            const dot = byName(rbNoText.indicator, "indicatorDot")
            compare(dot.visible, false)
            compare(rbNoText.indicator.border.color, Theme.input)
        }

        // Selected: fill settles to primary, primary border, dot visible.
        function test_checked_appearance() {
            const dot = byName(rbChecked.indicator, "indicatorDot")
            compare(dot.visible, true)
            tryCompare(rbChecked.indicator, "color", Theme.primary)
            compare(rbChecked.indicator.border.color, Theme.primary)
        }

        // Selecting one item in a group deselects the previously selected one.
        function test_single_selection_exclusivity() {
            compare(g1.checked, true)
            compare(g2.checked, false)
            compare(g3.checked, false)
            g2.checked = true
            compare(g1.checked, false)
            compare(g2.checked, true)
            compare(g3.checked, false)
            g3.checked = true
            compare(g2.checked, false)
            compare(g3.checked, true)
            // restore
            g1.checked = true
            compare(g2.checked, false)
            compare(g3.checked, false)
        }

        // Toggling checked flips the dot and animates the fill back.
        function test_toggle_dot_and_fill() {
            const dot = byName(rbNoText.indicator, "indicatorDot")
            rbNoText.checked = true
            compare(dot.visible, true)
            tryCompare(rbNoText.indicator, "color", Theme.primary)
            rbNoText.checked = false
            compare(dot.visible, false)
            tryCompare(rbNoText.indicator, "color", Theme.alpha(Theme.primary, 0))
        }

        // Disabled -> opacity 0.5.
        function test_disabled_opacity() {
            compare(rbDisabled.opacity, 0.5)
            compare(rbNoText.opacity, 1.0)
        }

        // Invalid + unselected: destructive border and a visible destructive ring.
        function test_invalid_unchecked() {
            const ring = byName(rbInvalid.indicator, "invalidRing")
            verify(ring !== null)
            compare(ring.visible, true)
            compare(rbInvalid.indicator.border.color, Theme.destructive)
            compare(ring.border.color, Theme.alpha(Theme.destructive, 0.2))
        }

        // Invalid + selected keeps the primary border
        // (aria-invalid:aria-checked:border-primary).
        function test_invalid_checked_keeps_primary_border() {
            compare(rbInvalidChecked.indicator.border.color, Theme.primary)
        }

        // Toggling invalid shows/hides the ring; default radio has none.
        function test_invalid_ring_visibility() {
            const ring = byName(rbNoText.indicator, "invalidRing")
            verify(ring !== null)
            compare(ring.visible, false)
            rbNoText.invalid = true
            compare(ring.visible, true)
            rbNoText.invalid = false
            compare(ring.visible, false)
        }
    }
}
