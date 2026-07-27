import QtQuick
import QtQuick.Layouts
import Shadcn

// Official sheet-demo: slides in from the right, edit-profile form + Save / Close at the bottom.
Button {
    text: qsTr("Open")
    variant: Button.Outline
    onClicked: sheet.open()

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
            Button { Layout.fillWidth: true; text: qsTr("Save changes"); onClicked: sheet.close() }
            Button { Layout.fillWidth: true; text: qsTr("Close"); variant: Button.Outline; onClicked: sheet.close() }
        }
    }
}
