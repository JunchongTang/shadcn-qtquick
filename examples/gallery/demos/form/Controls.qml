import QtQuick
import QtQuick.Layouts
import Shadcn

// FormField 与控件无关:Input / Textarea / Select 均可置入槽位。
// 最后一个字段演示静态错误态(error 非空 → 控件 invalid + 破坏色错误文本)。
ColumnLayout {
    width: 360
    spacing: Theme.space4          // 对标 FieldGroup gap-4

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
