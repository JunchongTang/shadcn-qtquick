import QtQuick
import QtQuick.Layouts
import QtTest
import Shadcn

// Field family unit tests. Orientation, layout gaps and fill behaviour are
// asserted from rendered geometry; label/title/description/error typography and
// colours are read off the Text-derived types after render. FieldError
// visibility and de-duplication are checked via the normalised _list. The
// separator rule/chip and group/set/content spacing are asserted from
// geometry. Deterministic under offscreen (no animations); Theme.dark defaults
// to false so light-mode tokens apply.
Item {
    id: root
    width: 640
    height: 900

    // ---- Vertical field: label + control + description stack ------------
    Field {
        id: vField
        width: 300
        orientation: Field.Vertical
        FieldLabel { id: vLabel; text: "Email" }
        Rectangle {
            id: vControl
            Layout.fillWidth: true
            implicitHeight: 28
            color: "#123456"
        }
        FieldDescription { id: vDesc; text: "We never share it." }
    }

    // ---- Horizontal field: label then control in one row ----------------
    Field {
        id: hField
        width: 300
        orientation: Field.Horizontal
        Rectangle {
            id: hA
            Layout.preferredWidth: 80
            Layout.preferredHeight: 20
            color: "#aa0000"
        }
        Rectangle {
            id: hB
            Layout.preferredWidth: 60
            Layout.preferredHeight: 20
            color: "#00aa00"
        }
    }

    // ---- Invalid field: bound children turn destructive -----------------
    Field {
        id: invField
        width: 300
        invalid: true
        FieldLabel { id: invLabel; text: "Name"; invalid: parent.invalid }
        FieldTitle { id: invTitle; text: "Nickname"; invalid: parent.invalid }
        FieldDescription { id: invDesc; text: "Bad"; invalid: parent.invalid }
    }

    // ---- FieldTitle disabled dims to 0.5 --------------------------------
    FieldTitle { id: disabledTitle; text: "Off"; enabled: false }

    // ---- FieldError variants --------------------------------------------
    FieldError { id: errEmpty }
    FieldError { id: errSingle; text: "Enter a valid email address." }
    FieldError {
        id: errMulti
        errors: [
            "Must be at least 8 characters long.",
            "Must contain at least one number.",
            "Must be at least 8 characters long."   // duplicate → removed
        ]
    }

    // ---- Legend variants -------------------------------------------------
    FieldLegend { id: legendDefault; text: "Address" }
    FieldLegend { id: legendLabel; text: "Nested"; variant: FieldLegend.Label }

    // ---- Separator: plain rule and labelled chip ------------------------
    FieldSeparator { id: sepPlain; width: 300 }
    FieldSeparator { id: sepText; width: 300; text: "OR" }

    // A group with a separator between two fixed blocks, used to observe the
    // separator's negative vertical margins (-my-2) from rendered geometry.
    FieldGroup {
        id: sepGroup
        width: 300
        Rectangle { id: gTop; Layout.fillWidth: true; implicitHeight: 20; color: "#202020" }
        FieldSeparator { id: gSep }
        Rectangle { id: gBottom; Layout.fillWidth: true; implicitHeight: 20; color: "#303030" }
    }

    // ---- Structural containers ------------------------------------------
    FieldGroup { id: group; width: 300 }
    FieldSet { id: fieldSet; width: 300 }
    FieldContent { id: fieldContent; width: 300 }

    TestCase {
        name: "Field"
        when: windowShown

        // ---- Enum + defaults --------------------------------------------
        function test_orientation_enum() {
            compare(Field.Vertical, 0)
            compare(Field.Horizontal, 1)
            compare(Field.Responsive, 2)
        }

        function test_defaults() {
            let f = Qt.createQmlObject("import Shadcn; Field {}", root)
            compare(f.orientation, Field.Vertical)
            compare(f.invalid, false)
            compare(f.horizontal, false)
            compare(f.rowSpacing, Theme.space2)      // gap-2 = 8
            compare(f.columnSpacing, Theme.space2)
            f.destroy()
        }

        function test_horizontal_flag() {
            compare(vField.horizontal, false)
            compare(hField.horizontal, true)
            let r = Qt.createQmlObject(
                "import Shadcn; Field { orientation: Field.Responsive }", root)
            compare(r.horizontal, true)   // responsive simplified to a row
            r.destroy()
        }

        // ---- Vertical layout: children stack, fill width ----------------
        function test_vertical_stacking() {
            // Same left edge for stacked children.
            compare(vControl.x, vLabel.x)
            compare(vDesc.x, vLabel.x)
            // Ordered top to bottom.
            verify(vControl.y > vLabel.y)
            verify(vDesc.y > vControl.y)
            // Row gap == gap-2 between label and control.
            fuzzyCompare(vControl.y - (vLabel.y + vLabel.height), Theme.space2, 0.6)
        }

        function test_vertical_fill_width() {
            fuzzyCompare(vControl.width, vField.width, 0.6)
            fuzzyCompare(vLabel.width, vField.width, 0.6)
        }

        // ---- Horizontal layout: children sit in a row -------------------
        // Delta is 1.5px to absorb GridLayout sub-pixel distribution rounding
        // (the row's centred vertical alignment can nudge y by a fraction).
        function test_horizontal_row() {
            // Horizontal orientation lays the children out in a single row: the
            // second control sits after the first (no overlap) and both share the
            // same vertical position. (The row distributes space between label and
            // control, so the inter-item gap is not a fixed gap-2.)
            verify(hB.x >= hA.x + hA.width - 0.5)
            fuzzyCompare(hA.y, hB.y, 1.5)
        }

        // ---- FieldLabel typography --------------------------------------
        function test_label_typography() {
            compare(vLabel.color, Theme.foreground)
            compare(vLabel.font.pixelSize, Theme.textXs)   // 12
            compare(vLabel.font.weight, Font.Medium)
            fuzzyCompare(vLabel.lineHeight, 1.375, 0.001)  // leading-snug
        }

        function test_label_invalid() {
            compare(invLabel.color, Theme.destructive)
        }

        // ---- FieldDescription typography --------------------------------
        function test_description_typography() {
            compare(vDesc.color, Theme.mutedForeground)
            compare(vDesc.font.pixelSize, Theme.textXs)    // 12
            compare(vDesc.lineHeight, Theme.lineRelaxed)
            compare(vDesc.lineHeightMode, Text.ProportionalHeight)
        }

        function test_description_invalid() {
            compare(invDesc.color, Theme.destructive)
        }

        // ---- FieldTitle typography + disabled ---------------------------
        function test_title_typography() {
            compare(invTitle.color, Theme.destructive)     // invalid
            let t = Qt.createQmlObject(
                "import Shadcn; FieldTitle { text: \"T\" }", root)
            compare(t.color, Theme.foreground)
            compare(t.font.pixelSize, Theme.textXs)        // 12
            compare(t.font.weight, Font.Medium)
            compare(t.lineHeight, Theme.lineRelaxed)
            compare(t.opacity, 1.0)
            t.destroy()
        }

        function test_title_disabled_opacity() {
            compare(disabledTitle.opacity, 0.5)
        }

        // ---- FieldError visibility + typography -------------------------
        function test_error_hidden_when_empty() {
            compare(errEmpty.visible, false)
            compare(errEmpty._list.length, 0)
        }

        function test_error_single() {
            compare(errSingle.visible, true)
            compare(errSingle._list.length, 1)
            compare(errSingle._list[0], "Enter a valid email address.")
        }

        function test_error_multi_dedup() {
            compare(errMulti.visible, true)
            // Three entries with one duplicate collapse to two.
            compare(errMulti._list.length, 2)
        }

        function test_error_color() {
            // The rendered delegate text is destructive, text-xs/relaxed.
            let e = Qt.createQmlObject(
                "import Shadcn; FieldError { width: 200; text: \"x\" }", root)
            // Find the delegate Text child by its rendered content.
            let txt = null
            for (let i = 0; i < e.children.length; i++) {
                if (e.children[i].text === "x") { txt = e.children[i]; break }
            }
            verify(txt !== null)
            compare(txt.color, Theme.destructive)
            compare(txt.font.pixelSize, Theme.textXs)
            compare(txt.lineHeight, Theme.lineRelaxed)
            e.destroy()
        }

        // ---- FieldLegend variants ---------------------------------------
        function test_legend_variant_enum() {
            compare(FieldLegend.Legend, 0)
            compare(FieldLegend.Label, 1)
        }

        function test_legend_default() {
            compare(legendDefault.variant, FieldLegend.Legend)
            compare(legendDefault.color, Theme.foreground)
            compare(legendDefault.font.pixelSize, Theme.textSm)   // 14
            compare(legendDefault.font.weight, Font.Medium)
        }

        function test_legend_label_variant() {
            compare(legendLabel.font.pixelSize, Theme.textXs)     // 12
            compare(legendLabel.lineHeight, Theme.lineRelaxed)
        }

        // ---- Separator: rule + optional chip ----------------------------
        function test_separator_geometry() {
            compare(sepPlain.implicitHeight, 20)                  // h-5
        }

        // The -my-2 negative margins pull the separator up into the gap-4 group
        // spacing: its top sits above (block height + full group spacing).
        function test_separator_negative_margins() {
            let baseline = gTop.height + sepGroup.spacing        // no-margin top
            verify(gSep.y < baseline)
            // -my-2 removes space2 from each side.
            fuzzyCompare(gSep.y, baseline - Theme.space2, 0.6)
        }

        function test_separator_rule() {
            // First child is the 1px rule at the vertical centre.
            let rule = sepPlain.children[0]
            compare(rule.height, 1)
            compare(rule.color, Theme.border)
            fuzzyCompare(rule.width, sepPlain.width, 0.6)
        }

        function test_separator_chip_visibility() {
            // The chip Rectangle (second child) is hidden without text.
            let plainChip = sepPlain.children[1]
            compare(plainChip.visible, false)
            let textChip = sepText.children[1]
            compare(textChip.visible, true)
            verify(textChip.width > Theme.space2 * 2)   // chip text + px-2
            compare(textChip.color, Theme.background)
        }

        // ---- Structural spacing -----------------------------------------
        function test_group_spacing() {
            compare(group.spacing, Theme.space4)          // gap-4 = 16
        }

        function test_set_spacing() {
            compare(fieldSet.spacing, Theme.space4)       // gap-4 = 16
        }

        function test_content_spacing() {
            compare(fieldContent.spacing, Theme.space0_5) // gap-0.5 = 2
        }
    }
}
