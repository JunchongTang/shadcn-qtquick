import QtQuick
import QtQuick.Controls.Basic as C
import QtQuick.Effects
import LucideIcons

// shadcn Native Select —— 比富 Select 更朴素的原生下拉(.cn-native-select)。
// 与 Select 的区别:trigger 内只有「单个」右侧箭头 chevron-down(而非 chevrons-up-down),
// 弹层为朴素条目列表(无逐项 check 勾选标)。视觉:border-input + bg-input/20 微填充,
// h-7(size=sm 时 h-6)、圆角 md、text-xs/relaxed(sm 用 0.625rem)、右内边距 pr-6 让位箭头。
//
// 扩展能力(对齐官方小节):
//   · size        —— Default(h-7)/ Sm(h-6);sm 同时缩小字号与箭头。
//   · placeholder —— currentIndex<0 时显示占位文字(对标 value="" 的首个 option)。
//   · invalid     —— aria-invalid 破坏色边框 + 破坏色环。
//   · 分组模型    —— model 里 { header: "…" } 渲染为 optgroup 标题(不可选);
//                   普通条目可含 { disabled: true } 单项禁用。字符串数组照旧当普通条目。
C.ComboBox {
    id: control

    enum Size { Default, Sm }

    property int size: NativeSelect.Default
    property string placeholder: ""     // 未选中时的占位文字
    property bool invalid: false        // aria-invalid → 破坏色描边 + 环

    readonly property bool _sm: size === NativeSelect.Sm
    readonly property int _itemHeight: 28

    implicitHeight: _sm ? 24 : 28              // h-6 / h-7
    leftPadding: Theme.space2                  // pl-2
    rightPadding: Theme.space6                 // pr-6(为右侧 chevron 让位)
    font.pixelSize: _sm ? 10 : Theme.textXs    // text-[0.625rem] / text-xs
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus     // 键盘可 Tab 聚焦;Space/Enter/方向键由 ComboBox 基类处理
    opacity: enabled ? 1.0 : 0.5               // has-[select:disabled]:opacity-50

    // ==== 触发器文字(选中值 / 占位)====
    contentItem: Text {
        readonly property bool _empty: control.currentIndex < 0 || control.displayText === ""
        text: _empty && control.placeholder !== "" ? control.placeholder : control.displayText
        font: control.font
        color: _empty ? Theme.mutedForeground : Theme.foreground  // placeholder:text-muted-foreground
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    // ==== 右侧单个 chevron-down ====
    indicator: LucideIcon {
        x: control.width - width - Theme.space1_5  // right-1.5
        y: (control.height - height) / 2
        name: "chevron-down"
        size: control._sm ? 12 : 14                // size-3 / size-3.5
        color: Theme.mutedForeground
    }

    // ==== 触发器背景 + 焦点外圈 ====
    background: Rectangle {
        id: bg
        radius: Theme.radiusMd
        // bg-input/20;dark:bg-input/30 + dark:hover:bg-input/50(明色态无 hover 变化)
        color: Theme.dark
               ? Theme.alpha(Theme.input, control.hovered ? 0.5 : 0.3)
               : Theme.alpha(Theme.input, 0.2)
        Behavior on color { ColorAnimation { duration: Theme.durFast } }
        border.width: 1
        // aria-invalid:border-destructive 优先于 focus-visible:border-ring。
        // border-ring 属 focus-visible(仅键盘):鼠标点击打开不高亮边框、不显环。
        border.color: control.invalid ? Theme.destructive
                      : control.visualFocus ? Theme.ring : Theme.input
        Behavior on border.color { ColorAnimation { duration: Theme.durFast } }

        // aria-invalid 破坏色环(ring-destructive/20,dark 40)
        Rectangle {
            anchors.fill: parent
            anchors.margins: -Theme.ringWidth
            radius: bg.radius + Theme.ringWidth
            color: "transparent"
            border.width: Theme.ringWidth
            border.color: Theme.alpha(Theme.destructive, Theme.dark ? 0.4 : 0.2)
            visible: control.invalid
            z: -1
        }

        // 焦点环仅键盘 focus-visible 时显示(鼠标点击打开不显)。
        FocusRing { active: control.visualFocus && !control.invalid; targetRadius: bg.radius }
    }

    // ==== 朴素条目 delegate(普通条目 / optgroup 标题,无 check 勾选标)====
    delegate: C.ItemDelegate {
        id: item
        required property int index
        required property var model
        width: ListView.view ? ListView.view.width : control.width
        padding: 0
        hoverEnabled: true

        // optgroup 标题:{ header: "…" };其余为普通条目。
        readonly property bool _isHeader: model.header !== undefined
        readonly property bool _isItem: !_isHeader
        readonly property bool _selected: control.currentIndex === index

        enabled: _isItem && model.disabled !== true   // 标题 / 单项禁用不可选
        height: control._itemHeight
        opacity: (_isItem && model.disabled === true) ? 0.5 : 1.0  // disabled:opacity-50

        contentItem: Item {
            // ---- optgroup 标题(text-muted-foreground px-2 text-xs)----
            Text {
                visible: item._isHeader
                anchors.left: parent.left
                anchors.leftMargin: Theme.space2
                anchors.verticalCenter: parent.verticalCenter
                text: item._isHeader ? item.model.header : ""
                font.pixelSize: Theme.textXs
                color: Theme.mutedForeground
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            // ---- 普通条目文字(optgroup 内缩进)----
            Text {
                visible: item._isItem
                anchors.left: parent.left
                anchors.leftMargin: Theme.space2
                anchors.right: parent.right
                anchors.rightMargin: Theme.space2
                anchors.verticalCenter: parent.verticalCenter
                text: item.model[control.textRole] !== undefined
                      ? item.model[control.textRole] : item.model.modelData
                font.pixelSize: Theme.textXs
                color: item.hovered || item._selected ? Theme.accentForeground : Theme.foreground
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
        }

        // 朴素高亮:hover / 当前项整行填充(近似原生高亮,无逐项勾选标)
        background: Rectangle {
            visible: item._isItem && (item.hovered || item._selected)
            radius: Theme.radiusSm
            color: Theme.accent
        }
    }

    // ==== 弹出层(朴素列表 surface)====
    popup: C.Popup {
        y: control.height + Theme.space1
        width: control.width
        implicitHeight: Math.min(contentItem.implicitHeight + 2 * padding, 300)
        padding: Theme.space1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            boundsBehavior: Flickable.StopAtBounds
            C.ScrollIndicator.vertical: C.ScrollIndicator {}
        }

        // 面板:rounded-lg + ring-1 ring-foreground/10 + shadow-md。
        background: Rectangle {
            radius: Theme.radiusLg
            color: Theme.popover
            border.width: Theme.overlayRingWidth
            border.color: Theme.overlayRing
            layer.enabled: true
            layer.effect: MultiEffect {
                autoPaddingEnabled: true
                shadowEnabled: true
                shadowColor: Theme.shadowColor
                shadowBlur: Theme.shadowBlur
                shadowVerticalOffset: Theme.shadowOffset
            }
        }
    }
}
