import QtQuick
import QtQuick.Layouts
import Shadcn

// Responsive dialog: the same "edit profile" form is presented as a centered
// Dialog on wide viewports (>= 768) and as a bottom Drawer on narrow ones,
// mirroring the official useMediaQuery example.
Button {
    id: root
    text: qsTr("Edit Profile")
    variant: Button.Outline
    readonly property bool desktop: root.Window.width >= 768
    onClicked: desktop ? dialog.open() : drawer.open()

    Dialog {
        id: dialog
        title: qsTr("Edit profile")
        description: qsTr("Make changes to your profile here. Click save when you're done.")
        ColumnLayout {
            spacing: Theme.space3
            RowLayout {
                spacing: Theme.space2
                Label { text: qsTr("Name"); Layout.preferredWidth: 80 }
                Input { Layout.fillWidth: true; text: qsTr("Pedro Duarte") }
            }
            RowLayout {
                spacing: Theme.space2
                Label { text: qsTr("Username"); Layout.preferredWidth: 80 }
                Input { Layout.fillWidth: true; text: qsTr("@peduarte") }
            }
        }
        footerContent: RowLayout {
            Item { Layout.fillWidth: true }
            Button { text: qsTr("Save changes"); onClicked: dialog.close() }
        }
    }

    Drawer {
        id: drawer
        side: "bottom"
        title: qsTr("Edit profile")
        description: qsTr("Make changes to your profile here. Click save when you're done.")
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.space3
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.space1
                Label { text: qsTr("Name") }
                Input { Layout.fillWidth: true; text: qsTr("Pedro Duarte") }
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.space1
                Label { text: qsTr("Username") }
                Input { Layout.fillWidth: true; text: qsTr("@peduarte") }
            }
        }
        footer: ColumnLayout {
            spacing: Theme.space2
            Button { Layout.fillWidth: true; text: qsTr("Save changes"); onClicked: drawer.close() }
            Button { Layout.fillWidth: true; text: qsTr("Cancel"); variant: Button.Outline; onClicked: drawer.close() }
        }
    }
}
