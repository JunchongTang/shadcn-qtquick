import QtQuick
import QtQuick.Layouts
import Shadcn

// side 属性控制卡片相对触发器的方向:left / top / bottom / right。
Flow {
    id: root
    width: 360
    spacing: 8

    component SideCard: Button {
        id: trigger
        property int cardSide: HoverCard.Side.BottomEdge
        property string label: ""
        text: label
        variant: Button.Outline
        size: Button.Sm

        HoverCard {
            id: hc
            delay: 100
            closeDelay: 100
            cardWidth: 224
            side: trigger.cardSide

            ColumnLayout {
                width: hc.availableWidth
                spacing: 4
                Text {
                    text: "Hover Card"
                    color: Theme.foreground
                    font.pixelSize: Theme.textXs
                    font.weight: Font.Medium
                }
                Text {
                    Layout.fillWidth: true
                    text: "This hover card appears on the " + trigger.label.toLowerCase() + " side of the trigger."
                    color: Theme.mutedForeground
                    font.pixelSize: Theme.textXs
                    lineHeight: Theme.lineRelaxed
                    lineHeightMode: Text.ProportionalHeight
                    wrapMode: Text.Wrap
                }
            }
        }
    }

    SideCard { label: "Left";   cardSide: HoverCard.Side.LeftEdge }
    SideCard { label: "Top";    cardSide: HoverCard.Side.TopEdge }
    SideCard { label: "Bottom"; cardSide: HoverCard.Side.BottomEdge }
    SideCard { label: "Right";  cardSide: HoverCard.Side.RightEdge }
}
