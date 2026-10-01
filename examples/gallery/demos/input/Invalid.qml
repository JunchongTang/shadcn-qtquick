import QtQuick
import QtQuick.Layouts
import Shadcn

// <Field data-invalid> with a label, an aria-invalid input and a description.
// The label and the typed text turn destructive by inheriting from the Field;
// the description keeps its own muted colour, as it does on the web.
Field {
    width: 260
    invalid: true

    FieldLabel { text: qsTr("Invalid Input"); invalid: parent.invalid }
    Input {
        Layout.fillWidth: true
        placeholderText: qsTr("Error")
        invalid: true
    }
    FieldDescription { text: qsTr("This field contains validation errors.") }
}
