import QtQuick
import Shadcn

// 官方 kbd-tooltip:两个按钮编成一组(ButtonGroup),气泡内文本后跟 Kbd 键位提示。
// 注:Tooltip.kbd 为单个字符串键位,组合键(官方用 KbdGroup)在此以 "Ctrl P" 单键近似。
ButtonGroup {
    Button {
        id: saveBtn
        text: "Save"
        variant: Button.Outline
        Tooltip { text: "Save Changes"; kbd: "S"; visible: saveBtn.hovered }
    }
    Button {
        id: printBtn
        text: "Print"
        variant: Button.Outline
        Tooltip { text: "Print Document"; kbd: "Ctrl P"; visible: printBtn.hovered }
    }
}
