import QtQuick
import QtQuick.Layouts
import Shadcn

// Field: 标签 + 描述 + 文本域。对标前端 textarea-field。
ColumnLayout {
    width: 320
    spacing: 6

    Label {
        text: "Message"
        Layout.fillWidth: true
    }
    Text {
        Layout.fillWidth: true
        text: "Enter your message below."
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }
    Textarea {
        Layout.fillWidth: true
        implicitHeight: 88
        placeholderText: "Type your message here."
    }
}
