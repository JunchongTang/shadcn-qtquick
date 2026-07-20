import QtQuick
import QtQuick.Layouts
import Shadcn

// 卡片式选择:整张卡片可点击切换开关(FieldLabel 包裹 Field 的形态)。
ColumnLayout {
    width: 360
    spacing: 12

    component ChoiceRow: Rectangle {
        id: choiceRoot
        property alias title: titleText.text
        property alias description: descText.text
        property bool value: false
        Layout.fillWidth: true
        implicitHeight: rowLayout.implicitHeight + Theme.space3 * 2
        radius: Theme.radiusLg
        color: Theme.card
        border.width: 1
        border.color: Theme.border

        RowLayout {
            id: rowLayout
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Theme.space3
            anchors.rightMargin: Theme.space3
            spacing: 16
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                Text {
                    id: titleText
                    color: Theme.foreground
                    font.pixelSize: Theme.textXs
                    font.weight: Font.Medium
                }
                Text {
                    id: descText
                    Layout.fillWidth: true
                    color: Theme.mutedForeground
                    font.pixelSize: Theme.textXs
                    lineHeight: Theme.lineRelaxed
                    lineHeightMode: Text.ProportionalHeight
                    wrapMode: Text.Wrap
                }
            }
            Switch { id: sw; checked: choiceRoot.value }
        }
        TapHandler { onTapped: sw.toggle() }
    }

    ChoiceRow {
        title: "Share across devices"
        description: "Focus is shared across devices, and turns off when you leave the app."
    }
    ChoiceRow {
        title: "Enable notifications"
        description: "Receive notifications when focus mode is enabled or disabled."
        value: true
    }
}
