import QtQuick
import QtQuick.Layouts
import Shadcn

Button {
    text: "Edit Profile"
    onClicked: dialog.open()

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
            Button { text: "Save changes"; onClicked: dialog.close() }
        }
    }
}
