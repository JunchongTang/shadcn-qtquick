import QtQuick
import Shadcn

// side 属性改变气泡放置方向(对标 tooltip-sides:left / top / bottom / right)。
Flow {
    spacing: Theme.space2

    Button {
        id: leftBtn
        text: "Left"
        variant: Button.Outline
        Tooltip { text: "Add to library"; side: Tooltip.Side.LeftEdge; visible: leftBtn.hovered }
    }
    Button {
        id: topBtn
        text: "Top"
        variant: Button.Outline
        Tooltip { text: "Add to library"; side: Tooltip.Side.TopEdge; visible: topBtn.hovered }
    }
    Button {
        id: bottomBtn
        text: "Bottom"
        variant: Button.Outline
        Tooltip { text: "Add to library"; side: Tooltip.Side.BottomEdge; visible: bottomBtn.hovered }
    }
    Button {
        id: rightBtn
        text: "Right"
        variant: Button.Outline
        Tooltip { text: "Add to library"; side: Tooltip.Side.RightEdge; visible: rightBtn.hovered }
    }
}
