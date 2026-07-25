import QtQuick
import QtQuick.Layouts
import Shadcn

// 在表单中的 Label —— 与 Input、Checkbox 配合。
// 对标前端「Label in Field」:标签 + 输入 纵向,以及标签 + 复选框 横向。
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
