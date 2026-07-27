import QtQuick
import QtQuick.Layouts
import Shadcn

// Basic field: Label + Input + description (FormField vertical container).
FormField {
    width: 300
    label: qsTr("Username")
    description: qsTr("This is your public display name.")

    Input {
        Layout.fillWidth: true
        placeholderText: qsTr("shadcn")
    }
}
