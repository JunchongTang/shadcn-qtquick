import QtQuick
import Shadcn

// The side property changes the tooltip placement direction (matches tooltip-sides: left / top / bottom / right).
Flow {
    spacing: Theme.space2

    Button {
        id: leftBtn
        text: qsTr("Left")
        variant: Button.Outline
        Tooltip { text: qsTr("Add to library"); side: Tooltip.Side.LeftEdge; visible: leftBtn.hovered }
    }
    Button {
        id: topBtn
        text: qsTr("Top")
        variant: Button.Outline
        Tooltip { text: qsTr("Add to library"); side: Tooltip.Side.TopEdge; visible: topBtn.hovered }
    }
    Button {
        id: bottomBtn
        text: qsTr("Bottom")
        variant: Button.Outline
        Tooltip { text: qsTr("Add to library"); side: Tooltip.Side.BottomEdge; visible: bottomBtn.hovered }
    }
    Button {
        id: rightBtn
        text: qsTr("Right")
        variant: Button.Outline
        Tooltip { text: qsTr("Add to library"); side: Tooltip.Side.RightEdge; visible: rightBtn.hovered }
    }
}
