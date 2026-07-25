import QtQuick
import QtQuick.Layouts
import Shadcn

// Hero shot: the dialog opened over a little page content so the modal
// blur backdrop has something to blur.
Rectangle {
    id: stage
    color: Theme.background
    implicitWidth: 640
    implicitHeight: 460

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10
        Text {
            text: "Account settings"
            color: Theme.foreground
            font.pixelSize: 24
            font.weight: Font.DemiBold
            Layout.alignment: Qt.AlignHCenter
        }
        Text {
            text: "Manage your profile and preferences."
            color: Theme.mutedForeground
            font.pixelSize: 14
            Layout.alignment: Qt.AlignHCenter
        }
    }

    Dialog {
        id: dialog
        title: qsTr("Edit profile")
        description: qsTr("Make changes to your profile here. Click save when you're done.")

        ColumnLayout {
            spacing: 10
            RowLayout {
                spacing: 10
                Label { text: "Name"; Layout.preferredWidth: 80 }
                Input { Layout.preferredWidth: 220; text: "Pedro Duarte" }
            }
            RowLayout {
                spacing: 10
                Label { text: "Username"; Layout.preferredWidth: 80 }
                Input { Layout.preferredWidth: 220; text: "@peduarte" }
            }
        }
        footerContent: RowLayout {
            Item { Layout.fillWidth: true }
            Button { text: "Save changes" }
        }
    }

    Component.onCompleted: dialog.open()
}
