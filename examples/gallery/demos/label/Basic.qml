import QtQuick
import QtQuick.Layouts
import Shadcn

// Label paired with a Checkbox. Mirrors the web label-demo.
RowLayout {
    spacing: 8

    Checkbox { id: terms }
    Label {
        text: qsTr("Accept terms and conditions")
        // Clicking the label toggles the checkbox (mirrors htmlFor).
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: terms.toggle()
        }
    }
}
