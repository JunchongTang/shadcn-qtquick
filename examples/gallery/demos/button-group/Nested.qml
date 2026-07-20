import QtQuick
import Shadcn

// 官方 button-group-nested:外层套多个 ButtonGroup → 组间留 gap-2(外层 Row spacing 8)。
// 结构:[+] 图标按钮  |  InputGroup(输入框 + inline-end 内嵌 audio-lines 图标按钮)。
// 注:官方内层为 <ButtonGroup> 包 <InputGroup>,inline-end addon 是带 Tooltip 的语音图标;
//     此处以 InputGroupButton(ghost 图标)近似,tooltip 从略。
Row {
    spacing: 8

    ButtonGroup {
        Button { variant: Button.Outline; size: Button.Icon; iconName: "plus" }
    }
    InputGroup {
        width: 260
        InputGroupInput { placeholderText: "Send a message..." }
        InputGroupAddon {
            align: InputGroupAddon.InlineEnd
            InputGroupButton {
                kind: InputGroupButton.KindIconXs
                iconName: "audio-lines"
            }
        }
    }
}
