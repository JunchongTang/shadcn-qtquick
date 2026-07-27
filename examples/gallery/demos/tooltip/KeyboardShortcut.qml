import QtQuick
import Shadcn

// Tooltip content = text + Kbd key hint (matches tooltip-keyboard: Save Changes <Kbd>S</Kbd>).
Button {
    id: saveBtn
    iconName: "save"
    size: Button.IconSm
    variant: Button.Outline
    Tooltip { text: qsTr("Save Changes"); kbd: "S"; visible: saveBtn.hovered }
}
