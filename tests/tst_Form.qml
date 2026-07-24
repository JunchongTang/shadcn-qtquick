import QtQuick
import QtTest
import Shadcn

// Form helper tests: FormDescription / FormMessage typography and colors, the
// destructive color of the error message, and FormField wiring (invalid derived
// from error, content routed into the control slot, description/error forwarded
// to the internal Text nodes). Appearance is asserted by reading resolved
// property values, so the suite is deterministic under the offscreen platform
// (no hover/focus needed). Theme.dark defaults to false -> light-mode colors.
Item {
    id: root
    width: 400
    height: 400

    FormDescription { id: desc; text: "We'll never share it." }
    FormDescription { id: descEmpty; text: "" }
    FormMessage { id: msg; text: "Enter a valid email." }
    FormMessage { id: msgEmpty; text: "" }

    FormField {
        id: field
        label: "Email"
        required: true
        description: "We'll never share it."
        error: ""
        Rectangle { id: slotChild; width: 10; height: 10 }
    }

    FormField {
        id: fieldErr
        label: "Email"
        error: "Enter a valid email."
    }

    // Locate an internal Text node (FormDescription/FormMessage) of a FormField
    // by its resolved color. Layout children expose no 'color', yielding
    // undefined, so the color match uniquely picks the Text node.
    function findText(f, wantColor) {
        for (var i = 0; i < f.children.length; ++i) {
            var c = f.children[i]
            if (c.color !== undefined && Qt.colorEqual(c.color, wantColor))
                return c
        }
        return null
    }

    TestCase {
        name: "Form"
        when: windowShown

        // ---- FormDescription: muted, text-xs/relaxed, left-aligned ----
        function test_description_typography() {
            compare(desc.color, Theme.mutedForeground)
            compare(desc.font.pixelSize, Theme.textXs)
            compare(desc.lineHeight, Theme.lineRelaxed)
            compare(desc.lineHeightMode, Text.ProportionalHeight)
            compare(desc.horizontalAlignment, Text.AlignLeft)
            verify(desc.visible)
        }

        function test_description_hidden_when_empty() {
            verify(!descEmpty.visible)
        }

        // ---- FormMessage: destructive, text-xs/relaxed ----
        function test_message_typography_and_color() {
            compare(msg.color, Theme.destructive)
            compare(msg.font.pixelSize, Theme.textXs)
            compare(msg.lineHeight, Theme.lineRelaxed)
            compare(msg.lineHeightMode, Text.ProportionalHeight)
            verify(msg.visible)
        }

        function test_message_hidden_when_empty() {
            verify(!msgEmpty.visible)
        }

        // The error message is destructive-colored and distinct from the muted
        // description (regression guard against a color mix-up).
        function test_message_is_destructive_not_muted() {
            compare(msg.color, Theme.destructive)
            verify(!Qt.colorEqual(msg.color, desc.color))
        }

        // ---- FormField wiring ----
        function test_field_spacing() {
            compare(field.spacing, Theme.space2)   // .cn-field gap-2
        }

        function test_field_invalid_wiring() {
            compare(field.error, "")
            verify(!field.invalid)
            verify(fieldErr.invalid)
            compare(fieldErr.invalid, fieldErr.error !== "")
        }

        // Default content is routed into the nested control slot, not left as a
        // direct child of the field root.
        function test_field_content_routed_to_slot() {
            verify(slotChild.parent !== null)
            verify(slotChild.parent !== field)
            compare(slotChild.width, 10)
        }

        // The field forwards its description text to the muted internal node.
        function test_field_forwards_description() {
            var d = findText(field, Theme.mutedForeground)
            verify(d !== null)
            compare(d.text, field.description)
            verify(d.visible)
        }

        // The field's error node is the destructive one and carries the error text.
        function test_field_error_node_destructive() {
            var e = findText(fieldErr, Theme.destructive)
            verify(e !== null)
            compare(e.text, fieldErr.error)
            compare(e.color, Theme.destructive)
            verify(e.visible)
        }

        // With no error, the field's error node exists but is hidden.
        function test_field_error_hidden_when_no_error() {
            var e = findText(field, Theme.destructive)
            verify(e !== null)
            verify(!e.visible)
        }
    }
}
