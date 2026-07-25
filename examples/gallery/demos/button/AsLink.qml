import QtQuick
import QtQuick.Layouts
import Shadcn

// As Link:让链接看起来像按钮 / 让按钮充当链接。
// 官方用 buttonVariants({variant:"secondary",size:"sm"}) 包在 <a> 上;
// QML 无原生锚点,这里用 Link 变体与 secondary/sm 按钮 + onClicked 打开外链演示。
RowLayout {
    spacing: 8
    Button {
        variant: Button.Link
        text: qsTr("Login")
        onClicked: Qt.openUrlExternally("https://ui.shadcn.com/docs/components/button")
    }
    Button {
        variant: Button.Secondary
        size: Button.Sm
        text: qsTr("Login")
        onClicked: Qt.openUrlExternally("https://ui.shadcn.com/docs/components/button")
    }
}
