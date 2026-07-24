import QtQuick
import QtTest
import Shadcn

// InputGroup unit tests: default metrics and orientation, the shared
// border/background geometry and at-rest / invalid border colors, child sorting
// and placement (inline-start / inline-end / block-start / block-end), the
// control padding overrides driven by addon presence, addon edge-pull with a
// button, the block-addon divider, and the InputGroupButton size mapping plus
// InputGroupText styling. Layout geometry is read after render; all states are
// at-rest (light theme, no real focus) so results are deterministic under the
// offscreen platform. The animated invalid border color uses tryCompare.
Item {
    id: root
    width: 600
    height: 600

    // Plain single-line group.
    InputGroup {
        id: gPlain
        InputGroupInput { id: gPlainInput; placeholderText: "Placeholder" }
    }

    // Invalid group.
    InputGroup {
        id: gInvalid
        invalid: true
        InputGroupInput {}
    }

    // Inline-start addon.
    InputGroup {
        id: gStart
        InputGroupInput { id: gStartInput }
        InputGroupAddon { id: gStartAddon; InputGroupText { text: "@" } }
    }

    // Inline-end addon.
    InputGroup {
        id: gEnd
        InputGroupInput { id: gEndInput }
        InputGroupAddon { id: gEndAddon; align: InputGroupAddon.InlineEnd; InputGroupText { text: "x" } }
    }

    // Both inline ends.
    InputGroup {
        id: gBoth
        InputGroupInput { id: gBothInput }
        InputGroupAddon { id: gBothStart; InputGroupText { text: "a" } }
        InputGroupAddon { id: gBothEnd; align: InputGroupAddon.InlineEnd; InputGroupText { text: "b" } }
    }

    // Inline-start addon holding a button (edge-pull).
    InputGroup {
        id: gBtn
        InputGroupInput {}
        InputGroupAddon { id: gBtnAddon; InputGroupButton { id: gBtnButton; text: "Go" } }
    }

    // Textarea group (auto vertical).
    InputGroup {
        id: gTa
        InputGroupTextarea { id: gTaControl }
    }

    // Block-end addon (auto vertical).
    InputGroup {
        id: gBlockEnd
        InputGroupInput { id: gBlockEndInput }
        InputGroupAddon { id: gBlockEndAddon; align: InputGroupAddon.BlockEnd; InputGroupText { text: "0/240" } }
    }

    // Block-start addon with divider.
    InputGroup {
        id: gBlockStart
        InputGroupInput { id: gBlockStartInput }
        InputGroupAddon { id: gBlockStartAddon; align: InputGroupAddon.BlockStart; border: true; InputGroupText { text: "Name" } }
    }

    // Standalone specimens for enum / mapping checks.
    InputGroupButton { id: btnXs }
    InputGroupButton { id: btnSm; kind: InputGroupButton.KindSm }
    InputGroupButton { id: btnIconXs; kind: InputGroupButton.KindIconXs }
    InputGroupButton { id: btnIconSm; kind: InputGroupButton.KindIconSm }
    InputGroupText { id: txt; text: "hello" }

    function gy(item, group) { return item.mapToItem(group, 0, 0).y }
    function gx(item, group) { return item.mapToItem(group, 0, 0).x }

    TestCase {
        name: "InputGroup"
        when: windowShown

        // Defaults: valid, horizontal, h-7.
        function test_defaults() {
            compare(gPlain.invalid, false)
            compare(gPlain.vertical, false)
            compare(gPlain._hasBlock, false)
            compare(gPlain._hasTextarea, false)
            compare(gPlain.implicitHeight, 28)
            compare(gPlain._firstControl, gPlainInput)
        }

        // Shared background: rounded-md, 1px border; at-rest border-input / bg-input/20.
        function test_background_shape_and_colors() {
            compare(gPlain.background.radius, Theme.radiusMd)
            compare(gPlain.background.border.width, 1)
            compare(gPlain.background.color, Theme.alpha(Theme.input, 0.2))
            compare(gPlain.background.border.color, Theme.border)
        }

        // Invalid paints the destructive border.
        function test_invalid_border() {
            compare(gInvalid.background.border.color, Theme.destructive)
        }

        // Toggling invalid animates the border to destructive and back.
        function test_invalid_toggle() {
            gPlain.invalid = true
            tryCompare(gPlain.background.border, "color", Theme.destructive)
            gPlain.invalid = false
            tryCompare(gPlain.background.border, "color", Theme.border)
        }

        // No addon: control keeps px-2 both sides.
        function test_padding_none() {
            compare(gPlainInput.leftPadding, Theme.space2)
            compare(gPlainInput.rightPadding, Theme.space2)
            compare(gPlainInput.topPadding, 0)
            compare(gPlainInput.bottomPadding, 0)
        }

        // Inline-start addon: pl-1.5 on the control, addon left of control.
        function test_inline_start() {
            compare(gStartInput.leftPadding, Theme.space1_5)
            compare(gStartInput.rightPadding, Theme.space2)
            verify(gx(gStartAddon, gStart) < gx(gStartInput, gStart))
        }

        // Inline-end addon: pr-1.5 on the control, addon right of control.
        function test_inline_end() {
            compare(gEndInput.rightPadding, Theme.space1_5)
            compare(gEndInput.leftPadding, Theme.space2)
            verify(gx(gEndAddon, gEnd) > gx(gEndInput, gEnd))
        }

        // Both ends: pl-1.5 + pr-1.5, order start < control < end.
        function test_inline_both() {
            compare(gBothInput.leftPadding, Theme.space1_5)
            compare(gBothInput.rightPadding, Theme.space1_5)
            verify(gx(gBothStart, gBoth) < gx(gBothInput, gBoth))
            verify(gx(gBothInput, gBoth) < gx(gBothEnd, gBoth))
        }

        // A child button tightens the inline-start padding (space2 -> space1).
        function test_addon_edge_pull() {
            compare(gBtnAddon._edgePull, true)
            compare(gBtnAddon._padL, Theme.space1)
            compare(gBtnButton._igButton, true)
        }

        // Textarea forces vertical layout.
        function test_textarea_vertical() {
            compare(gTa.vertical, true)
            compare(gTa._hasTextarea, true)
            compare(gTaControl._igType, "textarea")
            compare(gTaControl.topPadding, Theme.space2)
            compare(gTaControl.bottomPadding, Theme.space2)
        }

        // Block-end addon: vertical, control gets pt-3, addon below the control.
        function test_block_end() {
            compare(gBlockEnd.vertical, true)
            compare(gBlockEnd._hasBlock, true)
            compare(gBlockEndInput.topPadding, Theme.space3)
            verify(gy(gBlockEndAddon, gBlockEnd) > gy(gBlockEndInput, gBlockEnd))
        }

        // Block-start addon: control gets pb-3, addon above the control.
        function test_block_start() {
            compare(gBlockStart.vertical, true)
            compare(gBlockStartInput.bottomPadding, Theme.space3)
            verify(gy(gBlockStartAddon, gBlockStart) < gy(gBlockStartInput, gBlockStart))
        }

        // Addon enum defaults and alignment tokens.
        function test_addon_align_tokens() {
            compare(gStartAddon.align, InputGroupAddon.InlineStart)
            compare(gStartAddon.igAlign, "inline-start")
            compare(gStartAddon._block, false)
            compare(gEndAddon.igAlign, "inline-end")
            compare(gBlockEndAddon.igAlign, "block-end")
            compare(gBlockEndAddon._block, true)
            compare(gBlockStartAddon.igAlign, "block-start")
        }

        // Divider is present only for a bordered block addon.
        function test_addon_divider() {
            compare(gBlockStartAddon.border, true)
            compare(gStartAddon.border, false)
        }

        // InputGroupButton size mapping.
        function test_button_size_mapping() {
            compare(btnXs.kind, InputGroupButton.KindXs)
            compare(btnXs.size, Button.Xs)
            compare(btnXs.variant, Button.Ghost)
            compare(btnSm.size, Button.Sm)
            compare(btnIconXs.size, Button.IconSm)
            compare(btnIconSm.size, Button.Icon)
        }

        // InputGroupText styling.
        function test_text_styling() {
            compare(txt.color, Theme.mutedForeground)
            compare(txt.font.pixelSize, Theme.textXs)
            compare(txt.font.weight, Font.Medium)
        }
    }
}
