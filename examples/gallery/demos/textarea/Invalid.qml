import QtQuick
import QtQuick.Layouts
import Shadcn

// <Field data-invalid> with a label, an aria-invalid textarea and a description.
// Same inheritance as the input: label and typed text turn destructive, the
// description stays muted.
Field {
    width: 320
    invalid: true

    FieldLabel { text: qsTr("Message"); invalid: parent.invalid }
    Textarea {
        Layout.fillWidth: true
        implicitHeight: 88
        placeholderText: qsTr("Type your message here.")
        text: qsTr("Hello")
        invalid: true
    }
    FieldDescription { text: qsTr("Please enter a valid message.") }
}
