import QtQuick
import QtQuick.Layouts
import Shadcn

// FormField is control-agnostic: Input / Textarea / Select can all go in the slot.
// The last field shows a static error state (non-empty error → control invalid + destructive-colored error text).
ColumnLayout {
    width: 360
    spacing: Theme.space4          // matches FieldGroup gap-4

    FormField {
        Layout.fillWidth: true
        label: qsTr("Bio")
        description: qsTr("Tell us a little bit about yourself.")
        Textarea {
            Layout.fillWidth: true
            placeholderText: qsTr("I'm a...")
        }
    }

    FormField {
        Layout.fillWidth: true
        label: qsTr("Country")
        Select {
            Layout.fillWidth: true
            placeholder: qsTr("Select a country")
            model: [qsTr("United States"), qsTr("United Kingdom"), qsTr("Canada")]
        }
    }

    FormField {
        id: userField
        Layout.fillWidth: true
        label: qsTr("Username")
        required: true
        error: "This username is already taken."
        Input {
            Layout.fillWidth: true
            text: qsTr("evilrabbit")
            invalid: userField.invalid
        }
    }
}
