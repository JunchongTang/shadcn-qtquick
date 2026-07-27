import QtQuick
import QtQuick.Layouts
import Shadcn

// Checkbox + label + helper description composed inline (mirrors FieldContent + FieldDescription).
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
        Label { text: qsTr("Accept terms and conditions") }
        Text {
            Layout.fillWidth: true
            text: qsTr("By clicking this checkbox, you agree to the terms and conditions.")
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
            lineHeight: Theme.lineRelaxed
            lineHeightMode: Text.ProportionalHeight
            wrapMode: Text.Wrap
        }
    }
}
