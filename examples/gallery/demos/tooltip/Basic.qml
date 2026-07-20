import QtQuick
import Shadcn

Button {
    id: hoverBtn
    text: "Hover me"
    variant: Button.Outline
    Tooltip { text: "Add to library"; visible: hoverBtn.hovered }
}
