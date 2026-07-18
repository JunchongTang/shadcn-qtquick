import QtQuick
import QtQuick.Controls.Basic as C
import QtQuick.Effects

// shadcn DropdownMenu 的弹出容器。文件名 Menu 与基类 Menu 同名 → 别名导入(as C),根用 C.Menu。
C.Menu {
    id: control

    padding: Theme.space1            // p-1
    font.pixelSize: Theme.textXs
    overlap: 0
    modal: false

    // 弹出面 popover:1px 边框 + radiusLg + 轻微投影(shadow-md 的近似)
    background: Rectangle {
        implicitWidth: 128           // min-w-32 = 8rem
        color: Theme.popover
        radius: Theme.radiusLg
        border.width: 1
        border.color: Theme.border
        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: true
            shadowEnabled: true
            shadowColor: Theme.alpha(Theme.foreground, 0.18)
            shadowBlur: 0.4
            shadowVerticalOffset: 2
        }
    }

    // 弹出动效:fade + zoom-95(对标 data-open:fade-in/zoom-in-95)
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.durFast }
        NumberAnimation { property: "scale"; from: 0.95; to: 1; duration: Theme.durFast }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.durFast }
        NumberAnimation { property: "scale"; from: 1; to: 0.95; duration: Theme.durFast }
    }
}
