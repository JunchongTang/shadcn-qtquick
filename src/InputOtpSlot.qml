import QtQuick

// shadcn InputOTPSlot —— 单个字符格子(对标 .cn-input-otp-slot)。
// size-7、text-xs;组内借由父层 group 的圆角边框呈现「首尾圆角 + 共享竖线」:
// 每格除首格外在左侧画 1px 分隔线;激活格(data-active)显 ring 环 + 边框变 ring 色,
// 并画闪烁 caret(空格时)。纯展示件,状态由父层 InputOtp 注入。
Item {
    id: slot

    property string glyph: ""
    property bool active: false
    property bool first: false          // 组内首格 → 左侧圆角
    property bool last: false           // 组内末格 → 右侧圆角
    property bool invalid: false
    property bool showCaret: false      // 该格是否为当前输入位
    property bool caretOn: true         // caret 闪烁相位

    implicitWidth: 28                   // size-7
    implicitHeight: 28

    // ---- 组内竖向分隔线(= slot 之间共享的 border) ----
    Rectangle {
        visible: !slot.first
        width: 1
        height: parent.height
        color: slot.invalid ? Theme.destructive : Theme.border
    }

    // ---- 字符 ----
    Text {
        anchors.centerIn: parent
        text: slot.glyph
        color: Theme.foreground
        font.pixelSize: Theme.textXs
        font.family: Theme.fontSans
    }

    // ---- 闪烁 caret(仅当前输入位且为空时) ----
    Rectangle {
        anchors.centerIn: parent
        visible: slot.showCaret && slot.glyph === ""
        width: 1
        height: 16                      // h-4
        color: Theme.foreground
        opacity: slot.caretOn ? 1 : 0
    }

    // ---- 激活态覆盖:ring 环 + ring 色边框(z 抬高压过相邻边) ----
    Rectangle {
        id: activeBox
        anchors.fill: parent
        visible: slot.active
        z: 10                           // data-[active=true]:z-10
        color: "transparent"
        border.width: 1
        border.color: slot.invalid ? Theme.destructive : Theme.ring
        topLeftRadius: slot.first ? Theme.radiusMd : 0
        bottomLeftRadius: slot.first ? Theme.radiusMd : 0
        topRightRadius: slot.last ? Theme.radiusMd : 0
        bottomRightRadius: slot.last ? Theme.radiusMd : 0

        // focus ring:向外扩 ringWidth,颜色 ring/30(invalid → destructive/20)
        Rectangle {
            anchors.fill: parent
            anchors.margins: -Theme.ringWidth
            color: "transparent"
            border.width: Theme.ringWidth
            border.color: slot.invalid ? Theme.alpha(Theme.destructive, 0.2)
                                       : Theme.alpha(Theme.ring, Theme.ringOpacity)
            topLeftRadius: activeBox.topLeftRadius > 0 ? activeBox.topLeftRadius + Theme.ringWidth : 0
            bottomLeftRadius: activeBox.bottomLeftRadius > 0 ? activeBox.bottomLeftRadius + Theme.ringWidth : 0
            topRightRadius: activeBox.topRightRadius > 0 ? activeBox.topRightRadius + Theme.ringWidth : 0
            bottomRightRadius: activeBox.bottomRightRadius > 0 ? activeBox.bottomRightRadius + Theme.ringWidth : 0
        }
    }
}
