import QtQuick
import QtQuick.Layouts
import Shadcn

// 完整校验示例(注册表单):多个 FormField + 提交按钮,演示「提交后显示字段错误态」。
// 说明:QML 无 react-hook-form/zod;此处用手写轻量校验做结构/视觉等价,不接入 schema 校验库。
// 交互:点 Create account → submitted=true,各字段按规则显示错误并驱动控件 invalid;
//       修正后错误实时消失;全部通过时显示成功提示。
ColumnLayout {
    id: form
    width: 360
    spacing: Theme.space4                 // 对标 FieldGroup gap-4

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

    // ---- 操作 + 成功提示 ----
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
