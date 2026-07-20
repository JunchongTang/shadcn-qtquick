import QtQuick
import Shadcn

// 禁用按钮上仍显示气泡(对标 tooltip-disabled:用外层 span 包裹以接收 hover)。
// 禁用的 Button 自身不接收悬停,故由外层 Item 的 HoverHandler 触发。
Item {
    id: wrapper
    implicitWidth: disabledBtn.implicitWidth
    implicitHeight: disabledBtn.implicitHeight

    HoverHandler { id: hh }

    Button {
        id: disabledBtn
        text: "Disabled"
        variant: Button.Outline
        enabled: false
    }

    Tooltip {
        text: "This feature is currently unavailable"
        visible: hh.hovered
    }
}
