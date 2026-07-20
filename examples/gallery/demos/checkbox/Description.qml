import QtQuick
import QtQuick.Layouts
import Shadcn

// Checkbox + 标签 + 辅助描述内联组合(对标 FieldContent + FieldDescription)。
RowLayout {
    width: 300
    spacing: 8

    Checkbox {
        checked: true
        Layout.alignment: Qt.AlignTop
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 2
        Label { text: "Accept terms and conditions" }
        Text {
            Layout.fillWidth: true
            text: "By clicking this checkbox, you agree to the terms and conditions."
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
            lineHeight: Theme.lineRelaxed
            lineHeightMode: Text.ProportionalHeight
            wrapMode: Text.Wrap
        }
    }
}
