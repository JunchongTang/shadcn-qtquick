import QtQuick
import Shadcn

Button {
    id: hoverBtn
    text: qsTr("Hover me")
    variant: Button.Outline
    Tooltip { text: qsTr("Add to library"); visible: hoverBtn.hovered }
}
