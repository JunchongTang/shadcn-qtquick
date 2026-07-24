import QtQuick
import QtTest
import Shadcn

// ButtonGroup family unit tests: enum values, default layout (orientation,
// spacing, single-row / single-column Grid constraints), automatic First /
// Middle / Last / None position assignment, the vertical-orientation flag
// propagated to children (#010 regression), overlapping geometry after render,
// ButtonGroupText corner straightening per group position, and
// ButtonGroupSeparator sizing/color per orientation. All states are at-rest, so
// results are deterministic under the offscreen platform.
Item {
    id: root
    width: 400
    height: 400

    // Horizontal group with three buttons -> First / Middle / Last.
    ButtonGroup {
        id: hGroup
        Button { id: hb0; variant: Button.Outline; text: "One" }
        Button { id: hb1; variant: Button.Outline; text: "Two" }
        Button { id: hb2; variant: Button.Outline; text: "Three" }
    }

    // Single-item group -> GroupNone.
    ButtonGroup {
        id: singleGroup
        Button { id: sb0; variant: Button.Outline; text: "Solo" }
    }

    // Vertical group -> children get groupVertical = true.
    ButtonGroup {
        id: vGroup
        orientation: ButtonGroup.Vertical
        Button { id: vb0; variant: Button.Outline; text: "Up" }
        Button { id: vb1; variant: Button.Outline; text: "Down" }
    }

    // ButtonGroupText specimens for corner assertions.
    ButtonGroupText { id: txtNone;   text: "N" }
    ButtonGroupText { id: txtFirst;  text: "F"; groupPosition: Button.GroupFirst }
    ButtonGroupText { id: txtMiddle; text: "M"; groupPosition: Button.GroupMiddle }
    ButtonGroupText { id: txtLast;   text: "L"; groupPosition: Button.GroupLast }

    // Separators.
    ButtonGroupSeparator { id: sepV }
    ButtonGroupSeparator { id: sepH; orientation: ButtonGroupSeparator.Horizontal; length: 40 }

    TestCase {
        name: "ButtonGroup"
        when: windowShown

        // Orientation enum ordering (demos/components depend on these values).
        function test_orientation_enum() {
            compare(ButtonGroup.Horizontal, 0)
            compare(ButtonGroup.Vertical, 1)
        }

        // Default: horizontal, spacing -1, single row (rows 1, columns auto).
        function test_group_defaults() {
            compare(hGroup.orientation, ButtonGroup.Horizontal)
            compare(hGroup.spacing, -1)
            compare(hGroup.rows, 1)
            compare(hGroup.columns, -1)
        }

        // Vertical orientation -> single column (columns 1, rows auto). #010.
        function test_vertical_layout() {
            compare(vGroup.columns, 1)
            compare(vGroup.rows, -1)
        }

        // Three children are tagged First / Middle / Last.
        function test_assign_positions_three() {
            tryCompare(hb0, "groupPosition", Button.GroupFirst)
            tryCompare(hb1, "groupPosition", Button.GroupMiddle)
            tryCompare(hb2, "groupPosition", Button.GroupLast)
        }

        // A lone child is GroupNone (fully rounded).
        function test_assign_positions_single() {
            tryCompare(sb0, "groupPosition", Button.GroupNone)
        }

        // Vertical group propagates groupVertical to its children and tags them.
        function test_group_vertical_flag() {
            tryCompare(vb0, "groupVertical", true)
            tryCompare(vb1, "groupVertical", true)
            tryCompare(vb0, "groupPosition", Button.GroupFirst)
            tryCompare(vb1, "groupPosition", Button.GroupLast)
        }

        // Horizontal geometry: children in a single row, adjacent borders
        // overlapping by 1px (the -1 spacing) so there is no double line.
        function test_geometry_overlap() {
            // Same row (top aligned).
            compare(hb1.y, hb0.y)
            compare(hb2.y, hb0.y)
            // Left-to-right, each starting 1px before the previous item ends.
            compare(hb1.x - (hb0.x + hb0.width), -1)
            compare(hb2.x - (hb1.x + hb1.width), -1)
        }

        // Vertical geometry: single column, 1px overlap top-to-bottom.
        function test_geometry_vertical_overlap() {
            compare(vb1.x, vb0.x)
            compare(vb1.y - (vb0.y + vb0.height), -1)
        }

        // --- ButtonGroupText ---------------------------------------------

        function test_text_defaults() {
            compare(txtNone.color, Theme.muted)
            compare(txtNone.radius, Theme.radiusMd)
            compare(txtNone.border.width, 1)
            compare(txtNone.border.color, Theme.border)
            compare(txtNone.implicitHeight, 28)
            compare(txtNone.groupPosition, Button.GroupNone)
            compare(txtNone.groupVertical, false)
            compare(txtNone.text, "N")
        }

        // No group -> all four corners rounded.
        function test_text_corners_none() {
            const r = txtNone.radius
            compare(txtNone.topLeftRadius, r)
            compare(txtNone.topRightRadius, r)
            compare(txtNone.bottomLeftRadius, r)
            compare(txtNone.bottomRightRadius, r)
        }

        // First (horizontal): left corners rounded, right corners straight.
        function test_text_corners_first() {
            const r = txtFirst.radius
            compare(txtFirst.topLeftRadius, r)
            compare(txtFirst.bottomLeftRadius, r)
            compare(txtFirst.topRightRadius, 0)
            compare(txtFirst.bottomRightRadius, 0)
        }

        // Last (horizontal): right corners rounded, left corners straight.
        function test_text_corners_last() {
            const r = txtLast.radius
            compare(txtLast.topRightRadius, r)
            compare(txtLast.bottomRightRadius, r)
            compare(txtLast.topLeftRadius, 0)
            compare(txtLast.bottomLeftRadius, 0)
        }

        // Middle: every corner straightened.
        function test_text_corners_middle() {
            compare(txtMiddle.topLeftRadius, 0)
            compare(txtMiddle.topRightRadius, 0)
            compare(txtMiddle.bottomLeftRadius, 0)
            compare(txtMiddle.bottomRightRadius, 0)
        }

        // First (vertical): top corners rounded, bottom corners straight.
        function test_text_corners_first_vertical() {
            txtFirst.groupVertical = true
            const r = txtFirst.radius
            compare(txtFirst.topLeftRadius, r)
            compare(txtFirst.topRightRadius, r)
            compare(txtFirst.bottomLeftRadius, 0)
            compare(txtFirst.bottomRightRadius, 0)
            txtFirst.groupVertical = false
        }

        // --- ButtonGroupSeparator ----------------------------------------

        function test_separator_enum() {
            compare(ButtonGroupSeparator.Horizontal, 0)
            compare(ButtonGroupSeparator.Vertical, 1)
        }

        // Default vertical: 1px wide, `length` tall, input-colored.
        function test_separator_vertical() {
            compare(sepV.orientation, ButtonGroupSeparator.Vertical)
            compare(sepV.implicitWidth, 1)
            compare(sepV.implicitHeight, sepV.length)
            compare(sepV.color, Theme.input)
        }

        // Horizontal: `length` wide, 1px tall.
        function test_separator_horizontal() {
            compare(sepH.implicitWidth, 40)
            compare(sepH.implicitHeight, 1)
        }
    }
}
