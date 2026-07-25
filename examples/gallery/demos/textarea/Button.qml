import QtQuick
import QtQuick.Layouts
import Shadcn

// 文本域 + 提交按钮。对标前端 textarea-button。
ColumnLayout {
    width: 320
    spacing: 8

    Textarea {
        Layout.fillWidth: true
        implicitHeight: 88
        placeholderText: qsTr("Type your message here.")
    }
    Button {
        Layout.fillWidth: true
        text: qsTr("Send message")
    }
}
