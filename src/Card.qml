import QtQuick
import QtQuick.Controls.Basic as C

// shadcn Card —— 卡片容器(card 底 + 边框 + 圆角 + 内边距)。子项放入即可。
C.Frame {
    id: control
    padding: Theme.space4

    background: Rectangle {
        color: Theme.card
        radius: Theme.radiusLg
        border.width: 1
        border.color: Theme.border
    }
}
