import QtQuick
import QtQuick.Layouts
import Shadcn

// Horizontal Field (w-fit): label on the left, switch on the right.
Field {
    orientation: Field.Horizontal

    FieldLabel {
        text: qsTr("Multi-factor authentication")
        Layout.fillWidth: false          // w-fit: no stretch
        Layout.alignment: Qt.AlignVCenter
    }
    Switch {
        Layout.alignment: Qt.AlignVCenter
    }
}
