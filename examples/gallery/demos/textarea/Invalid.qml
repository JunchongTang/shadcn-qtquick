import QtQuick
import QtQuick.Layouts
import Shadcn

// Field(data-invalid): 标签 + 破坏色文本域 + 描述。对标前端 aria-invalid。
ColumnLayout {
    width: 320
    spacing: 6

    Label {
        text: qsTr("Message")
        Layout.fillWidth: true
    }
    Textarea {
        Layout.fillWidth: true
        implicitHeight: 88
        placeholderText: qsTr("Type your message here.")
        invalid: true
    }
    Text {
        Layout.fillWidth: true
        text: qsTr("Please enter a valid message.")
        color: Theme.destructive
        font.pixelSize: Theme.textXs
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }
}
