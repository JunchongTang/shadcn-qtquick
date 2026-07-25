import QtQuick
import QtQuick.Layouts
import Shadcn

// Field(data-invalid): 标签 + 破坏色输入 + 描述。对标前端 aria-invalid。
ColumnLayout {
    width: 260
    spacing: 6

    Label {
        text: qsTr("Invalid Input")
        Layout.fillWidth: true
    }
    Input {
        Layout.fillWidth: true
        placeholderText: qsTr("Error")
        invalid: true
    }
    Text {
        Layout.fillWidth: true
        text: qsTr("This field contains validation errors.")
        color: Theme.destructive
        font.pixelSize: Theme.textXs
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }
}
