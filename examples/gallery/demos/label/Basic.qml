import QtQuick
import QtQuick.Layouts
import Shadcn

// Label 配合 Checkbox。对标前端 label-demo。
RowLayout {
    spacing: 8

    Checkbox { id: terms }
    Label {
        text: "Accept terms and conditions"
        // 点击标签联动勾选(对标 htmlFor)。
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: terms.toggle()
        }
    }
}
