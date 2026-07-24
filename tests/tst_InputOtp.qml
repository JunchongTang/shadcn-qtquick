import QtQuick
import QtTest
import Shadcn

// InputOtp family unit tests: slot count derived from length / groups, separator
// placement, value-to-glyph binding, the current-input-position (_activeIndex)
// logic and active-slot highlighting, invalid-state propagation, the pattern
// acceptor, and rendered geometry (control implicit size, slot size-7, separator
// size-4 width). Structure is inspected by recursively collecting the rendered
// InputOtpSlot / InputOtpSeparator instances (identified by their declared
// properties). All non-focus assertions are at-rest and deterministic under
// QT_QPA_PLATFORM=offscreen; the one focus-dependent check is guarded on
// activeFocus so it never fails when the offscreen platform withholds activation.
Item {
    id: root
    width: 480
    height: 200

    InputOtp { id: otpSingle; length: 6 }
    InputOtp { id: otpSplit;  length: 6; groups: [3, 3] }
    InputOtp { id: otpThree;  length: 6; groups: [2, 2, 2] }
    InputOtp { id: otpDigits; length: 4; pattern: "[0-9]" }
    InputOtp { id: otpInvalid; length: 4; invalid: true; value: "12" }
    InputOtp { id: otpFocus;  length: 6; value: "123" }

    TestCase {
        name: "InputOtp"
        when: windowShown

        // A slot exposes both `glyph` (string) and `showCaret` (bool).
        function isSlot(o) {
            return typeof o.glyph === "string" && typeof o.showCaret === "boolean"
        }
        // A separator exposes `iconName` (string).
        function isSep(o) {
            return typeof o.iconName === "string"
        }
        // Recursively collect visual descendants matching a predicate.
        function collect(node, pred, acc) {
            for (let i = 0; i < node.children.length; i++) {
                const c = node.children[i]
                if (pred(c))
                    acc.push(c)
                collect(c, pred, acc)
            }
            return acc
        }
        function slotsOf(otp) {
            const arr = collect(otp, isSlot, [])
            // Order by the global slot index the component injects as `modelData`.
            arr.sort((a, b) => a.modelData - b.modelData)
            return arr
        }
        function sepsOf(otp) {
            // Every cell instantiates a separator; only real separator cells keep
            // it visible, so filter on the local visible binding.
            return collect(otp, o => isSep(o) && o.visible === true, [])
        }

        // Single group: `length` slots, no separators.
        function test_slot_count_single() {
            compare(slotsOf(otpSingle).length, 6)
            compare(sepsOf(otpSingle).length, 0)
        }

        // groups=[3,3]: 6 slots, one separator between the two groups.
        function test_slot_count_split() {
            compare(slotsOf(otpSplit).length, 6)
            compare(sepsOf(otpSplit).length, 1)
        }

        // groups=[2,2,2]: 6 slots, two separators.
        function test_slot_count_three_groups() {
            compare(slotsOf(otpThree).length, 6)
            compare(sepsOf(otpThree).length, 2)
        }

        // First/last flags mark the group's outer corners.
        function test_first_last_flags() {
            const s = slotsOf(otpSplit)
            compare(s[0].first, true)          // group A start
            compare(s[2].last, true)           // group A end
            compare(s[3].first, true)          // group B start
            compare(s[5].last, true)           // group B end
            compare(s[1].first, false)
            compare(s[1].last, false)
        }

        // value maps character-by-character onto slot glyphs; unfilled slots empty.
        function test_value_glyph_binding() {
            otpSingle.value = "12"
            const s = slotsOf(otpSingle)
            compare(s[0].glyph, "1")
            compare(s[1].glyph, "2")
            compare(s[2].glyph, "")
            compare(s[5].glyph, "")
            otpSingle.value = ""
            compare(slotsOf(otpSingle)[0].glyph, "")
        }

        // complete is true only at exactly `length` characters.
        function test_complete() {
            otpSingle.value = "12345"
            compare(otpSingle.complete, false)
            otpSingle.value = "123456"
            compare(otpSingle.complete, true)
            otpSingle.value = ""
            compare(otpSingle.complete, false)
        }

        // _activeIndex tracks the caret position, clamped to the last slot.
        function test_active_index() {
            otpSingle.value = ""
            compare(otpSingle._activeIndex, 0)
            otpSingle.value = "123"
            compare(otpSingle._activeIndex, 3)
            otpSingle.value = "123456"
            compare(otpSingle._activeIndex, 5)   // clamped to length - 1
            otpSingle.value = ""
        }

        // Without active focus no slot is highlighted.
        function test_no_focus_no_active() {
            const s = slotsOf(otpSingle)
            for (let i = 0; i < s.length; i++)
                compare(s[i].active, false)
        }

        // With focus, exactly the _activeIndex slot is active and shows a caret;
        // guarded because offscreen may decline to activate the window.
        function test_active_highlight() {
            otpFocus.forceActiveFocus()
            if (!otpFocus.activeFocus)
                skip("offscreen platform did not grant active focus")
            const s = slotsOf(otpFocus)
            const ai = otpFocus._activeIndex
            compare(ai, 3)
            for (let i = 0; i < s.length; i++)
                compare(s[i].active, i === ai)
            compare(s[ai].showCaret, true)       // active slot draws the caret
            compare(s[ai].glyph, "")             // and is empty
        }

        // invalid propagates to every slot.
        function test_invalid_propagation() {
            const s = slotsOf(otpInvalid)
            for (let i = 0; i < s.length; i++)
                compare(s[i].invalid, true)
            const ok = slotsOf(otpSingle)
            compare(ok[0].invalid, false)
        }

        // Per-character pattern acceptor.
        function test_pattern_accepts() {
            compare(otpDigits._accepts("5"), true)
            compare(otpDigits._accepts("a"), false)
            compare(otpSingle._accepts("a"), true)   // empty pattern accepts anything
        }

        // Control geometry: single group of 6 = 6 * size-7 (28) wide, 28 tall.
        function test_geometry_single() {
            compare(otpSingle.implicitWidth, 6 * 28)
            compare(otpSingle.implicitHeight, 28)
        }

        // Split geometry: two 3-slot groups (84) + one separator (16) + gap-2 (8)
        // between each of the three row items = 84 + 8 + 16 + 8 + 84.
        function test_geometry_split() {
            compare(otpSplit.implicitWidth, 84 + 8 + 16 + 8 + 84)
            compare(otpSplit.implicitHeight, 28)
        }

        // Slot is size-7 (28 x 28); separator is size-4 wide (16) x 28.
        function test_child_sizes() {
            const s = slotsOf(otpSplit)[0]
            compare(s.implicitWidth, 28)
            compare(s.implicitHeight, 28)
            const sep = sepsOf(otpSplit)[0]
            compare(sep.implicitWidth, 16)
            compare(sep.implicitHeight, 28)
        }

        // Separator defaults to the base-mira minus icon.
        function test_separator_default_icon() {
            compare(sepsOf(otpSplit)[0].iconName, "minus")
        }

        // disabled -> opacity-50 (has-disabled:opacity-50).
        function test_disabled_opacity() {
            otpSingle.enabled = false
            compare(otpSingle.opacity, 0.5)
            otpSingle.enabled = true
            compare(otpSingle.opacity, 1.0)
        }
    }
}
