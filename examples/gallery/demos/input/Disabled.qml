import QtQuick
import QtQuick.Layouts
import Shadcn

// Disabled: 整个 Field 禁用(标签变暗 + 输入不可编辑)。对标前端 <Field data-disabled>。
ColumnLayout {
    width: 260
    spacing: 6
    enabled: false

    Label {
        text: "Email"
        Layout.fillWidth: true
    }
    Input {
        Layout.fillWidth: true
        placeholderText: "Email"
    }
    Text {
        Layout.fillWidth: true
        text: "This field is currently disabled."
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
        opacity: 0.5
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }
}
