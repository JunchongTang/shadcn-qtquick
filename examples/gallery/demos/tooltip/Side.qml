import QtQuick
import Shadcn

// side 属性改变气泡放置方向(对标 tooltip-sides:left / top / bottom / right)。
Flow {
    spacing: Theme.space2

    Button {
        id: leftBtn
        text: "Left"
        variant: Button.Outline
        Tooltip { text: "Add to library"; side: Tooltip.Left; visible: leftBtn.hovered }
    }
    Button {
        id: topBtn
        text: "Top"
        variant: Button.Outline
        Tooltip { text: "Add to library"; side: Tooltip.Top; visible: topBtn.hovered }
    }
    Button {
        id: bottomBtn
        text: "Bottom"
        variant: Button.Outline
        Tooltip { text: "Add to library"; side: Tooltip.Bottom; visible: bottomBtn.hovered }
    }
    Button {
        id: rightBtn
        text: "Right"
        variant: Button.Outline
        Tooltip { text: "Add to library"; side: Tooltip.Right; visible: rightBtn.hovered }
    }
}
