import QtQuick
import QtQuick.Layouts
import Shadcn

// Label within a form — paired with Input and Checkbox.
// Mirrors the web "Label in Field": label + input vertical, and label + checkbox horizontal.
ColumnLayout {
    width: 280
    spacing: 16

    // Label + Input
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 6
        Label { text: qsTr("Your email address") }
        Input { Layout.fillWidth: true; placeholderText: qsTr("you@example.com") }
    }

    // Label + Checkbox
    RowLayout {
        spacing: 8
        Checkbox { id: news }
        Label {
            text: qsTr("Subscribe to the newsletter")
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: news.toggle()
            }
        }
    }
}
