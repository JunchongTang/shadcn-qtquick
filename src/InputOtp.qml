pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

// shadcn Input OTP —— 分段验证码输入(对标 .cn-input-otp / -group / -slot)。
//
// 用法:
//   InputOtp { length: 6 }                         // 单组 6 位
//   InputOtp { length: 6; groups: [3, 3] }          // 3+3,组间自动加分隔符
//   InputOtp { length: 6; pattern: "[0-9]" }        // 仅数字(逐字符正则)
//
// 属性:
//   length   位数(总格子数)
//   groups   各组格子数数组;为空则视作单组 [length];组间显示 InputOtpSeparator
//   pattern  逐字符校验正则源(空串=接受任意可见字符;如 "[0-9]"、"[a-zA-Z0-9]")
//   invalid  aria-invalid:边框/环转破坏色
//   value    输出:已输入字符串(只读语义,内部维护)
//   complete value.length === length
//
// 说明:整件为单一可聚焦控件,键盘输入统一由此处理(输入/退格);当前输入位显 ring + caret。
// 复杂输入(粘贴多字符、方向键改写中间位、RTL)已简化 —— 仅支持顺序输入与退格。
FocusScope {
    id: control

    property int length: 6
    property var groups: []
    property string pattern: ""
    property bool invalid: false
    property string value: ""
    readonly property bool complete: value.length === control.length

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    activeFocusOnTab: true
    opacity: enabled ? 1 : 0.5          // has-disabled:opacity-50

    // 归一化分组:无 groups → 单组;并夹逼 value 长度不超过 length。
    readonly property var _groups: (control.groups && control.groups.length > 0)
                                   ? control.groups : [control.length]
    // 当前输入位(聚焦时高亮 + caret)。
    readonly property int _activeIndex: Math.min(control.value.length, control.length - 1)

    // 构建布局项:交替 group 与 sep,group 携带其全局格子索引数组。
    readonly property var _items: {
        let res = []
        let start = 0
        for (let g = 0; g < control._groups.length; g++) {
            if (g > 0)
                res.push({ "type": "sep" })
            let idx = []
            for (let k = 0; k < control._groups[g]; k++) {
                idx.push(start)
                start++
            }
            res.push({ "type": "grp", "indices": idx })
        }
        return res
    }

    function _accepts(ch) {
        if (control.pattern === "")
            return true
        return new RegExp(control.pattern).test(ch)
    }

    // caret 闪烁(animate-caret-blink,~1s 周期)。
    property bool _caretOn: true
    Timer {
        interval: 500
        repeat: true
        running: control.activeFocus
        onTriggered: control._caretOn = !control._caretOn
        onRunningChanged: if (!running) control._caretOn = true
    }

    Keys.onPressed: (e) => {
        if (!control.enabled)
            return
        if (e.key === Qt.Key_Backspace || e.key === Qt.Key_Delete) {
            control.value = control.value.slice(0, -1)
            e.accepted = true
            return
        }
        const t = e.text
        if (t && t.length === 1 && t.charCodeAt(0) >= 32) {
            e.accepted = true
            if (control.value.length >= control.length)
                return
            if (control._accepts(t))
                control.value += t
        }
    }

    TapHandler {
        enabled: control.enabled
        onTapped: control.forceActiveFocus()
    }

    RowLayout {
        id: row
        spacing: Theme.space2            // .cn-input-otp gap-2(组/分隔符之间)

        Repeater {
            model: control._items
            delegate: Item {
                id: cell
                required property var modelData

                readonly property bool _isSep: cell.modelData.type === "sep"
                implicitWidth: _isSep ? sep.implicitWidth : grp.implicitWidth
                implicitHeight: 28
                Layout.preferredWidth: implicitWidth
                Layout.preferredHeight: 28

                InputOtpSeparator {
                    id: sep
                    anchors.centerIn: parent
                    visible: cell._isSep
                }

                // ---- 组:圆角边框 + 微填充背景,内含相邻格子 ----
                Rectangle {
                    id: grp
                    visible: !cell._isSep
                    implicitWidth: slots.implicitWidth
                    implicitHeight: 28
                    radius: Theme.radiusMd
                    color: Theme.alpha(Theme.input, 0.2)     // bg-input/20
                    border.width: 1
                    border.color: control.invalid ? Theme.destructive : Theme.input

                    // has-aria-invalid:ring(整组破坏色环)
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -Theme.ringWidth
                        radius: grp.radius + Theme.ringWidth
                        color: "transparent"
                        border.width: Theme.ringWidth
                        border.color: Theme.alpha(Theme.destructive, 0.2)
                        visible: control.invalid
                    }

                    Row {
                        id: slots
                        spacing: 0
                        Repeater {
                            model: cell._isSep ? [] : cell.modelData.indices
                            delegate: InputOtpSlot {
                                id: slotItem
                                required property var modelData      // 全局格子索引
                                required property int index          // 组内序号
                                first: index === 0
                                last: index === (cell.modelData.indices.length - 1)
                                glyph: (slotItem.modelData < control.value.length)
                                       ? control.value.charAt(slotItem.modelData) : ""
                                active: control.activeFocus
                                        && slotItem.modelData === control._activeIndex
                                showCaret: active
                                caretOn: control._caretOn
                                invalid: control.invalid
                            }
                        }
                    }
                }
            }
        }
    }
}
