import QtQuick
import QtQuick.Layouts
import Shadcn

// FieldSet + FieldGroup: two vertical Fields (label/input/description).
// The second field deliberately places the description above the input, verifying free child ordering.
FieldSet {
    width: 280        // max-w-xs

    FieldGroup {
        Field {
            FieldLabel { text: qsTr("Username") }
            Input {
                Layout.fillWidth: true
                text: qsTr("Max Leiter")
                placeholderText: qsTr("Max Leiter")
            }
            FieldDescription { text: qsTr("Choose a unique username for your account.") }
        }
        Field {
            FieldLabel { text: qsTr("Password") }
            FieldDescription { text: qsTr("Must be at least 8 characters long.") }
            Input {
                Layout.fillWidth: true
                echoMode: TextInput.Password
                placeholderText: "••••••••"
            }
        }
    }
}
