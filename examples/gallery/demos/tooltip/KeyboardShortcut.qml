import QtQuick
import Shadcn

// 气泡内容 = 文本 + Kbd 键位提示(对标 tooltip-keyboard:Save Changes <Kbd>S</Kbd>)。
Button {
    id: saveBtn
    iconName: "save"
    size: Button.IconSm
    variant: Button.Outline
    Tooltip { text: qsTr("Save Changes"); kbd: "S"; visible: saveBtn.hovered }
}
