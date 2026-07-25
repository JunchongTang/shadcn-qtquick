import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    width: 300
    spacing: 8

    Label { text: qsTr("Subscription Plan") }
    Text {
        Layout.fillWidth: true
        text: qsTr("Yearly and lifetime plans offer significant savings.")
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }
    RadioGroup {
        Layout.topMargin: 4
        RadioButton { text: qsTr("Monthly ($9.99/month)"); checked: true }
        RadioButton { text: qsTr("Yearly ($99.99/year)") }
        RadioButton { text: qsTr("Lifetime ($299.99)") }
    }
}
