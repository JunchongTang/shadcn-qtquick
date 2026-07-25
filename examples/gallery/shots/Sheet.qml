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
        text: "Settings"
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
            Label { text: "Name" }
            Input { Layout.fillWidth: true; text: "Pedro Duarte" }
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.space3
            Label { text: "Username" }
            Input { Layout.fillWidth: true; text: "@peduarte" }
        }

        footer: ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.space2
            Button { Layout.fillWidth: true; text: "Save changes" }
            Button { Layout.fillWidth: true; text: "Close"; variant: Button.Outline }
        }
    }

    Component.onCompleted: sheet.open()
}
