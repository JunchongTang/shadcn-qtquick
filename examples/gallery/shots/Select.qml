import QtQuick
import Shadcn

Rectangle {
    color: Theme.background
    implicitWidth: 300
    implicitHeight: 250

    Select {
        id: sel
        x: 24
        y: 24
        width: 220
        model: [qsTr("Apple"), qsTr("Banana"), qsTr("Blueberry"), qsTr("Grapes"), qsTr("Pineapple")]
    }

    Component.onCompleted: sel.popup.open()
}
