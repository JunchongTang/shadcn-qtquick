import QtQuick
import QtQuick.Layouts
import Shadcn

// Field: 标签 + 输入 + 描述(纵向)。对标前端 <Field><FieldLabel/><Input/><FieldDescription/>。
ColumnLayout {
    width: 260
    spacing: 6

    Label {
        text: "Username"
        Layout.fillWidth: true
    }
    Input {
        Layout.fillWidth: true
        placeholderText: "Enter your username"
    }
    Text {
        Layout.fillWidth: true
        text: "Choose a unique username for your account."
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }
}
