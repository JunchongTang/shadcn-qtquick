import QtQuick
import QtQuick.Layouts
import Shadcn

// Validation/errors: Field.invalid turns the label/description destructive-colored, an invalid control shows a destructive border ring,
// FieldError follows right after the control. The second field demonstrates an errors array → a multi-item bulleted list.
FieldGroup {
    width: 280        // max-w-xs

    Field {
        invalid: true
        FieldLabel { text: qsTr("Email"); invalid: parent.invalid }
        Input {
            Layout.fillWidth: true
            invalid: true
            text: qsTr("evil@")
            placeholderText: qsTr("you@example.com")
        }
        FieldError { text: qsTr("Enter a valid email address.") }
    }

    Field {
        invalid: true
        FieldLabel { text: qsTr("Password"); invalid: parent.invalid }
        Input {
            Layout.fillWidth: true
            invalid: true
            echoMode: TextInput.Password
            text: qsTr("abc")
        }
        FieldError {
            errors: [
                "Must be at least 8 characters long.",
                "Must contain at least one number."
            ]
        }
    }
}
