import QtQuick
import QtQuick.Layouts
import Shadcn

// Full validation example (sign-up form): multiple FormFields + submit button, demonstrating "show field errors after submit".
// Note: QML has no react-hook-form/zod; here we use hand-written lightweight validation for structural/visual parity, without a schema validation library.
// Interaction: click Create account → submitted=true, each field shows errors per its rule and drives the control invalid;
//       errors clear in real time once fixed; a success message shows when all pass.
ColumnLayout {
    id: form
    width: 360
    spacing: Theme.space4                 // matches FieldGroup gap-4

    property bool submitted: false
    readonly property bool valid: !nameField.invalid && !emailField.invalid && !pwField.invalid

    FormField {
        id: nameField
        Layout.fillWidth: true
        label: qsTr("Name")
        required: true
        error: form.submitted && nameInput.text.trim() === "" ? qsTr("Name is required.") : ""
        Input {
            id: nameInput
            Layout.fillWidth: true
            placeholderText: qsTr("Evil Rabbit")
            invalid: nameField.invalid
        }
    }

    FormField {
        id: emailField
        Layout.fillWidth: true
        label: qsTr("Email")
        required: true
        description: qsTr("We'll never share your email with anyone.")
        error: form.submitted && !/^.+@.+\..+$/.test(emailInput.text) ? qsTr("Enter a valid email address.") : ""
        Input {
            id: emailInput
            Layout.fillWidth: true
            placeholderText: qsTr("john@example.com")
            invalid: emailField.invalid
        }
    }

    FormField {
        id: pwField
        Layout.fillWidth: true
        label: qsTr("Password")
        required: true
        description: qsTr("Must be at least 8 characters.")
        error: form.submitted && pwInput.text.length < 8 ? qsTr("Password must be at least 8 characters.") : ""
        Input {
            id: pwInput
            Layout.fillWidth: true
            placeholderText: qsTr("Enter a password")
            echoMode: TextInput.Password
            invalid: pwField.invalid
        }
    }

    // ---- Actions + success message ----
    RowLayout {
        Layout.fillWidth: true
        Layout.topMargin: Theme.space1
        spacing: Theme.space2

        FormDescription {
            text: qsTr("Account created.")
            color: Theme.foreground
            visible: form.submitted && form.valid
            Layout.alignment: Qt.AlignVCenter
        }
        Item { Layout.fillWidth: true }
        Button {
            text: qsTr("Reset")
            variant: Button.Outline
            onClicked: {
                form.submitted = false
                nameInput.clear()
                emailInput.clear()
                pwInput.clear()
            }
        }
        Button {
            text: qsTr("Create account")
            onClicked: form.submitted = true
        }
    }
}
