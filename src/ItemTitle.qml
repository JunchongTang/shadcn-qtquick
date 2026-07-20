import QtQuick
import QtQuick.Layouts

// shadcn ItemTitle —— 标题行:text-xs/leading-snug/font-medium,line-clamp-1(单行省略)。
// 便捷 text 属性即内置一段标题文本;也可直接放自定义子项(如彩色 span、徽章)。
RowLayout {
    id: title

    readonly property string itemSlot: "item-title"
    property string text: ""
    property color color: Theme.foreground

    Layout.fillWidth: true
    spacing: Theme.space2   // gap-2

    Text {
        visible: title.text !== ""
        text: title.text
        color: title.color
        font.pixelSize: Theme.textXs
        font.weight: Font.Medium
        elide: Text.ElideRight       // line-clamp-1
        Layout.fillWidth: true
    }
}
