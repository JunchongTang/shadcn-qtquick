import QtQuick
import QtQuick.Controls.Basic as C
import QtQuick.Effects
import LucideIcons

// shadcn Select —— 触发器(trigger)+ 弹出列表(popover)。
// 文件名 Select 与基类 ComboBox 大小写不同,无需别名。用标准 model/currentIndex API。
//
// 扩展能力(对齐官方小节):
//   · placeholder —— currentIndex<0 时显示占位文字(data-placeholder:text-muted-foreground)。
//   · invalid     —— aria-invalid 破坏色边框 + 破坏色环(对标 Switch.qml 写法)。
//   · 分组模型    —— model 里的对象若含 { header: "…" } 渲染为分组标题(SelectLabel),
//                   含 { separator: true } 渲染为分隔线(SelectSeparator),二者均不可选;
//                   普通条目可含 { disabled: true } 单项禁用。字符串数组照旧当普通条目。
//   · alignItemWithTrigger —— true 时弹层上移,使当前项覆盖触发器(base-ui 默认行为的简化实现,
//                   不含滚动/视口夹取,详见弹层 y 处注释)。
C.ComboBox {
    id: control

    property string placeholder: ""     // 未选中时的占位文字
    property bool invalid: false        // aria-invalid → 破坏色描边 + 环
    property bool alignItemWithTrigger: false  // 当前项对齐触发器(简化实现)
    // 在 ButtonGroup 中的相邻位置(由 ButtonGroup 自动设置)—— 拉直相邻内侧圆角。
    property int groupPosition: Button.GroupNone
    property bool groupVertical: false

    readonly property int _itemHeight: 28

    implicitHeight: 28              // data-[size=default]:h-7
    leftPadding: Theme.space2       // px-2
    rightPadding: Theme.space2 + 14 + Theme.space1_5 // 给右侧 chevron 留位(gap-1.5)
    font.pixelSize: Theme.textXs
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus     // 键盘可 Tab 聚焦;Space/Enter/方向键由 ComboBox 基类处理
    opacity: enabled ? 1.0 : 0.5

    // 分组内(键盘)聚焦/展开时抬到最上层(对标 focus-visible:z-10),让 ring 色边框盖住
    // 与相邻控件重合(spacing:-1)的共享边。用 visualFocus:鼠标点击打开不算 focus-visible。
    z: (visualFocus || popup.visible) ? 10 : 0

    // ==== 触发器文字(选中值 / 占位)====
    contentItem: Text {
        readonly property bool _empty: control.currentIndex < 0 || control.displayText === ""
        text: _empty && control.placeholder !== "" ? control.placeholder : control.displayText
        font: control.font
        color: _empty ? Theme.mutedForeground : Theme.foreground  // data-placeholder:text-muted-foreground
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    // ==== 右侧 chevron ====
    indicator: LucideIcon {
        x: control.width - width - Theme.space2
        y: (control.height - height) / 2
        name: "chevrons-up-down"
        size: 14                                  // svg size-3.5
        color: Theme.mutedForeground
    }

    // ==== 触发器背景 + 焦点外圈 ====
    background: Rectangle {
        id: bg
        radius: Theme.radiusMd
        // 分组时拉直相邻内侧角(逐角推导,机制同 Button)。
        readonly property bool _n: control.groupPosition === Button.GroupNone
        readonly property bool _f: control.groupPosition === Button.GroupFirst
        readonly property bool _l: control.groupPosition === Button.GroupLast
        readonly property bool _v: control.groupVertical
        topLeftRadius:     (_n || _f) ? radius : 0
        bottomRightRadius: (_n || _l) ? radius : 0
        topRightRadius:    (_n || (!_v && _l) || (_v && _f)) ? radius : 0
        bottomLeftRadius:  (_n || (!_v && _f) || (_v && _l)) ? radius : 0
        color: Theme.alpha(Theme.input, 0.2)      // bg-input/20 微填充
        border.width: 1
        // aria-invalid:border-destructive 优先于 focus-visible:border-ring。
        // border-ring 属 focus-visible(仅键盘),用 visualFocus:鼠标点击打开不高亮边框、不显环。
        border.color: control.invalid ? Theme.destructive
                      : control.visualFocus ? Theme.ring : Theme.border
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

        // 焦点环随背景逐角圆角(分组拉直的一侧同为直角);仅键盘 focus-visible 时显示。
        FocusRing {
            active: control.visualFocus && !control.invalid
            targetRadius: bg.radius
            targetTopLeft: bg.topLeftRadius
            targetTopRight: bg.topRightRadius
            targetBottomLeft: bg.bottomLeftRadius
            targetBottomRight: bg.bottomRightRadius
        }
    }

    // ==== 列表项 delegate(普通条目 / 分组标题 / 分隔线)====
    delegate: C.ItemDelegate {
        id: item
        required property int index
        required property var model
        width: ListView.view ? ListView.view.width : control.width
        padding: 0
        hoverEnabled: true

        // 分组标题:{ header: "…" };分隔线:{ separator: true };其余为普通条目。
        readonly property bool _isHeader: model.header !== undefined
        readonly property bool _isSeparator: model.separator === true
        readonly property bool _isItem: !_isHeader && !_isSeparator
        readonly property bool _selected: control.currentIndex === index

        enabled: _isItem && model.disabled !== true   // 标题/分隔线/单项禁用均不可选
        height: _isSeparator ? 9 : control._itemHeight // 分隔线 h-px + my-1
        opacity: (_isItem && model.disabled === true) ? 0.5 : 1.0  // data-disabled:opacity-50

        contentItem: Item {
            // ---- 分隔线(SelectSeparator: bg-border/50 -mx-1 my-1 h-px)----
            Rectangle {
                visible: item._isSeparator
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: 1
                color: Theme.alpha(Theme.border, 0.5)
            }
            // ---- 分组标题(SelectLabel: text-muted-foreground px-2 py-1.5 text-xs)----
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
            // ---- 普通条目文字 ----
            Text {
                visible: item._isItem
                anchors.left: parent.left
                anchors.leftMargin: Theme.space2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - Theme.space2 * 2 - 14
                text: item.model[control.textRole] !== undefined
                      ? item.model[control.textRole] : item.model.modelData
                font.pixelSize: Theme.textXs
                color: item.hovered ? Theme.accentForeground : Theme.foreground
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            // 选中项右侧 check(absolute right-2)。
            LucideIcon {
                anchors.right: parent.right
                anchors.rightMargin: Theme.space2
                anchors.verticalCenter: parent.verticalCenter
                name: "check"
                size: 14                          // svg size-3.5
                color: item.hovered ? Theme.accentForeground : Theme.foreground
                visible: item._isItem && item._selected
            }
        }

        background: Rectangle {
            visible: item._isItem
            radius: Theme.radiusMd                // rounded-md
            color: item.hovered ? Theme.accent : "transparent"  // focus:bg-accent
        }
    }

    // ==== 弹出层(popover surface)====
    popup: C.Popup {
        // alignItemWithTrigger=true 时上移,使当前项覆盖触发器(条目与触发器同高 28)。
        // 简化实现:未处理列表滚动 / 视口上边缘夹取(官方会夹取并回退到贴边);多项滚动
        // 场景下建议保持 false。false 时贴触发器下沿弹出(= 官方 alignItemWithTrigger={false})。
        y: control.alignItemWithTrigger && control.currentIndex >= 0
           ? -(control.currentIndex * control._itemHeight + padding)
           : control.height + Theme.space1
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

        // popover 面:rounded-lg + ring-1 ring-foreground/10 + shadow-md。
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
