import QtQuick
import Shadcn

Alert {
    width: 420
    title: qsTr("Dark mode is now available")
    description: qsTr("Enable it under your profile settings to get started.")
    Button { text: qsTr("Enable"); size: Button.Xs }
}
