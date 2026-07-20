import QtQuick
import QtQuick.Layouts
import Shadcn

// Required: 标签带红色星号,提示必填。对标前端 <FieldLabel>… <span className="text-destructive">*</span>。
ColumnLayout {
    width: 260
    spacing: 6

    // Label + 破坏色星号内联组合(不新建 Field 组件)。
    RowLayout {
        Layout.fillWidth: true
        spacing: 2
        Label { text: "Required Field" }
        Label {
            text: "*"
            color: Theme.destructive
        }
    }
    Input {
        Layout.fillWidth: true
        placeholderText: "This field is required"
    }
    Text {
        Layout.fillWidth: true
        text: "This field must be filled out."
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }
}
