import QtQuick
import QtQuick.Layouts
import Shadcn

// 基础字段:Label + Input + 描述(FormField 纵向容器)。
FormField {
    width: 300
    label: "Username"
    description: "This is your public display name."

    Input {
        Layout.fillWidth: true
        placeholderText: "shadcn"
    }
}
