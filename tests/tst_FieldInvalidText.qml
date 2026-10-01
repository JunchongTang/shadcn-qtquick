import QtQuick
import QtQuick.Layouts
import QtTest
import Shadcn

// On the web a Field in its error state turns the text typed into its controls
// red, by inheritance: the Field carries data-[invalid=true]:text-destructive
// and an input is color: inherit. The same input on its own, even with
// aria-invalid, keeps its foreground text -- only the border and ring change.
// QML has no inherited colour, so the text controls look for the enclosing
// Field explicitly; these cases pin both halves of that distinction.
Item {
    id: root
    width: 400
    height: 400

    // A bare control, invalid on its own.
    Input { id: bareInput; invalid: true }
    Textarea { id: bareArea; invalid: true }

    Field {
        id: invalidField
        invalid: true
        Input { id: inField }
        Textarea { id: areaInField }

        // The control is rarely a direct child: FieldContent and similar
        // wrappers sit between, and inheritance would cross them.
        Item {
            implicitWidth: 100
            implicitHeight: 28
            Input { id: nested; width: 100 }
        }
    }

    Field {
        id: calmField
        invalid: false
        Input { id: inCalmField }
    }

    // A calm Field inside an invalid one inherits from the outer, as CSS would.
    Field {
        id: outerField
        invalid: true
        Field {
            id: innerField
            invalid: false
            Input { id: inInner }
        }
    }

    TestCase {
        name: "FieldInvalidText"
        when: windowShown

        function init() {
            invalidField.invalid = true
            Theme.dark = false
        }

        function cleanupTestCase() {
            Theme.dark = false
        }

        function test_bare_invalid_control_keeps_foreground_text() {
            compare(bareInput.color, Theme.foreground,
                    "aria-invalid alone does not colour the text")
            compare(bareArea.color, Theme.foreground)
        }

        function test_control_in_invalid_field_turns_destructive() {
            compare(inField.color, Theme.destructive)
            compare(areaInField.color, Theme.destructive)
        }

        function test_inheritance_crosses_wrapper_items() {
            compare(nested.color, Theme.destructive)
        }

        function test_control_in_calm_field_keeps_foreground() {
            compare(inCalmField.color, Theme.foreground)
        }

        function test_calm_field_inside_an_invalid_one_still_inherits() {
            compare(inInner.color, Theme.destructive,
                    "a Field that is not invalid sets no colour, so the outer one shows through")
        }

        function test_follows_the_field_flipping() {
            compare(inField.color, Theme.destructive)
            invalidField.invalid = false
            compare(inField.color, Theme.foreground)
            invalidField.invalid = true
            compare(inField.color, Theme.destructive)
        }

        function test_follows_the_theme() {
            // Compared as strings: color is a value type, and !== on two of them
            // is not a comparison of what they hold.
            const light = inField.color.toString()
            Theme.dark = true
            compare(inField.color, Theme.destructive)
            verify(inField.color.toString() !== light,
                   "destructive differs between light (" + light + ") and dark ("
                   + inField.color.toString() + "), and the text should follow it")
        }
    }
}
