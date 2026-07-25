import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 kbd-button:Kbd 放在 Button 内(后置位)。
// Button 只有 Lucide 图标插槽,无法直接塞 Kbd,故覆盖 contentItem 以内联 "Accept" + Kbd。
Button {
    id: btn
    variant: Button.Outline

    contentItem: RowLayout {
        spacing: Theme.space1                    // gap-1
        Text {
            text: qsTr("Accept")
            color: Theme.foreground              // outline 前景色
            font.pixelSize: btn.font.pixelSize
            font.weight: btn.font.weight
            font.family: Theme.fontSans
            verticalAlignment: Text.AlignVCenter
        }
        Kbd { text: "⏎" }                   // data-icon=inline-end
    }
}
