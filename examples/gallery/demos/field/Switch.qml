import QtQuick
import QtQuick.Layouts
import Shadcn

// 横排 Field(w-fit):标签在左、开关在右。
Field {
    orientation: Field.Horizontal

    FieldLabel {
        text: qsTr("Multi-factor authentication")
        Layout.fillWidth: false          // w-fit:不拉伸
        Layout.alignment: Qt.AlignVCenter
    }
    Switch {
        Layout.alignment: Qt.AlignVCenter
    }
}
