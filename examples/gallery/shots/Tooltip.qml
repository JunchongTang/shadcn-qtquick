import QtQuick
import Shadcn

// Hero shot: the tooltip forced visible above its trigger.
Rectangle {
    color: Theme.background
    implicitWidth: 320
    implicitHeight: 160

    Button {
        anchors.centerIn: parent
        text: qsTr("Hover me")
        variant: Button.Outline
        Tooltip { text: qsTr("Add to library"); visible: true }
    }
}
