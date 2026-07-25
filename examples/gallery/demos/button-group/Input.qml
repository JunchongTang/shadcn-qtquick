import QtQuick
import Shadcn

// 官方 button-group-input:Input 与按钮编成一组。ButtonGroup 自动为 Input(左)与
// Button(右)拉直相邻内侧角:Input 圆左直右、Button 圆右直左。
ButtonGroup {
    Input {
        width: 200
        placeholderText: qsTr("Search...")
    }
    Button { variant: Button.Outline; size: Button.Icon; iconName: "search" }
}
