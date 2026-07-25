import QtQuick
import QtQuick.Layouts
import Shadcn

// 基础字段:Label + Input + 描述(FormField 纵向容器)。
FormField {
    width: 300
    label: qsTr("Username")
    description: qsTr("This is your public display name.")

    Input {
        Layout.fillWidth: true
        placeholderText: qsTr("shadcn")
    }
}
