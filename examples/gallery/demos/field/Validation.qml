import QtQuick
import QtQuick.Layouts
import Shadcn

// 校验/错误:Field.invalid 让标签/描述转破坏色,控件 invalid 显破坏边框环,
// FieldError 紧随控件之后。第二个字段演示 errors 数组 → 多条项目符号列表。
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
