import QtQuick
import Shadcn

// 官方 button-group-orientation:orientation=vertical 让整组纵向排列(媒体控制)。
// 纵向时 ButtonGroup 自动为相邻按钮拉直上/下内侧角。
ButtonGroup {
    orientation: ButtonGroup.Vertical

    Button { variant: Button.Outline; size: Button.Icon; iconName: "plus" }
    Button { variant: Button.Outline; size: Button.Icon; iconName: "minus" }
}
