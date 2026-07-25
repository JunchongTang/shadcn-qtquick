import QtQuick
import QtQuick.Layouts
import Shadcn

// Right-edge sheet (edit profile), opened over a little page content.
Rectangle {
    color: Theme.background
    implicitWidth: 680
    implicitHeight: 460

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 40
        text: qsTr("Settings")
        color: Theme.foreground
        font.pixelSize: 24
        font.weight: Font.DemiBold
    }

    Sheet {
        id: sheet
        side: Sheet.RightEdge
        title: qsTr("Edit profile")
        description: qsTr("Make changes to your profile here. Click save when you're done.")

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.space3
            Label { text: qsTr("Name") }
            Input { Layout.fillWidth: true; text: qsTr("Pedro Duarte") }
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.space3
            Label { text: qsTr("Username") }
            Input { Layout.fillWidth: true; text: qsTr("@peduarte") }
        }

        footer: ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.space2
            Button { Layout.fillWidth: true; text: qsTr("Save changes") }
            Button { Layout.fillWidth: true; text: qsTr("Close"); variant: Button.Outline }
        }
    }

    Component.onCompleted: sheet.open()
}
