import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import Shadcn

ColumnLayout {
    width: 320
    spacing: 12
    C.ButtonGroup { id: grp }

    component PlanCard: Rectangle {
        id: root
        property alias title: t.text
        property alias description: d.text
        property alias value: rb.checked
        Layout.fillWidth: true
        implicitHeight: row.implicitHeight + Theme.space3 * 2
        radius: Theme.radiusLg
        color: Theme.card
        border.width: 1
        border.color: rb.checked ? Theme.primary : Theme.border

        RowLayout {
            id: row
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Theme.space3
            anchors.rightMargin: Theme.space3
            spacing: 12
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                Text { id: t; color: Theme.foreground; font.pixelSize: Theme.textXs; font.weight: Font.Medium }
                Text {
                    id: d
                    Layout.fillWidth: true
                    color: Theme.mutedForeground
                    font.pixelSize: Theme.textXs
                    lineHeight: Theme.lineRelaxed
                    lineHeightMode: Text.ProportionalHeight
                    wrapMode: Text.Wrap
                }
            }
            RadioButton { id: rb; C.ButtonGroup.group: grp; Layout.preferredWidth: 16 }
        }
        TapHandler { onTapped: rb.toggle() }
    }

    PlanCard { title: "Plus"; description: "For individuals and small teams."; value: true }
    PlanCard { title: "Pro"; description: "For growing businesses." }
    PlanCard { title: "Enterprise"; description: "For large teams and enterprises." }
}
