import QtQuick
import QtQuick.Layouts
import Shadcn

// Checkbox 列表(对标 FieldSet + FieldLegend + FieldGroup)。
ColumnLayout {
    width: 300
    spacing: 6

    Label { text: qsTr("Show these items on the desktop:") }
    Text {
        Layout.fillWidth: true
        text: qsTr("Select the items you want to show on the desktop.")
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }

    ColumnLayout {
        Layout.topMargin: 6
        spacing: 12
        Checkbox { text: qsTr("Hard disks"); checked: true }
        Checkbox { text: qsTr("External disks"); checked: true }
        Checkbox { text: qsTr("CDs, DVDs, and iPods") }
        Checkbox { text: qsTr("Connected servers") }
    }
}
