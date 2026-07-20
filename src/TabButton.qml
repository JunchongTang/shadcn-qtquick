import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import QtQuick.Effects
import LucideIcons

// shadcn Tabs 触发器 —— 文件名与基类同名(TabButton),必须别名导入并以 C.TabButton 为根,
// 释放 TabButton 供枚举访问、规避继承环。
// Default 变体:选中 → background 底 + foreground 字 + radiusMd + 轻投影(激活胶囊)。
// Line 变体:无胶囊底,选中 → 底部 2px 前景色下划线(vertical 时移到右侧)。
// iconName:左侧 Lucide 图标(size-3.5 = 14),gap-1.5。disabled:整体变暗不可点。
C.TabButton {
    id: control

    property string iconName: ""   // 前置图标(Lucide kebab-case 名)

    // 从所属 Tabs(TabBar)读取变体/方向,决定胶囊 vs 下划线、横排 vs 竖排。
    readonly property var _bar: C.TabBar.tabBar
    readonly property bool _line: _bar ? _bar._line === true : false
    readonly property bool _vertical: _bar ? _bar.vertical === true : false

    readonly property color _fg: (control.checked || control.hovered || control.down)
                                 ? Theme.foreground : Theme.mutedForeground

    leftPadding: Theme.space1_5     // px-1.5
    rightPadding: Theme.space1_5
    topPadding: _vertical ? 5 : 0   // vertical: py-[calc(--spacing(1.25))] = 5px
    bottomPadding: _vertical ? 5 : 0
    implicitHeight: _vertical ? (contentItem.implicitHeight + topPadding + bottomPadding)
                              : 26  // h-8 列表(32) - p-[3px] 两侧 = 26
    // 垂直模式:每个触发器铺满列表宽度,使激活胶囊与 muted 背景等宽对齐(修复过窄)。
    // 用 width(而非 implicitWidth),避免与 Tabs 的 _maxChildWidth 形成绑定环。
    width: (control._vertical && ListView.view) ? ListView.view.width : implicitWidth
    font.pixelSize: Theme.textXs
    font.weight: Font.Medium
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus     // 键盘可 Tab 聚焦;方向键在 TabBar 内切换由基类处理
    opacity: enabled ? 1.0 : 0.5   // disabled

    contentItem: Item {
        implicitWidth: row.implicitWidth
        implicitHeight: row.implicitHeight

        RowLayout {
            id: row
            spacing: Theme.space1_5   // gap-1.5
            anchors.verticalCenter: parent.verticalCenter
            // vertical:justify-start(左对齐);horizontal:居中。
            anchors.left: control._vertical ? parent.left : undefined
            anchors.horizontalCenter: control._vertical ? undefined : parent.horizontalCenter

            LucideIcon {
                visible: control.iconName !== ""
                name: control.iconName
                size: 14              // size-3.5
                color: control._fg
                Behavior on color { ColorAnimation { duration: Theme.durFast } }
            }
            Text {
                text: control.text
                visible: control.text !== ""
                font: control.font
                color: control._fg
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                Behavior on color { ColorAnimation { duration: Theme.durFast } }
            }
        }
    }

    background: Item {
        // Default 变体激活胶囊:选中时显 background 底 + 轻投影(shadow-sm);暗色下加 input 描边。
        Rectangle {
            id: pill
            anchors.fill: parent
            visible: !control._line
            radius: Theme.radiusMd          // rounded-md
            color: control.checked ? Theme.background : Theme.alpha(Theme.background, 0)
            border.width: control.checked && Theme.dark ? 1 : 0
            border.color: Theme.input
        }

        // Line 变体下划线:选中时淡入。horizontal 贴底满宽;vertical 贴右满高。均 2px 前景色。
        Rectangle {
            id: underline
            visible: control._line
            color: Theme.foreground
            opacity: control.checked ? 1 : 0
            width: control._vertical ? 2 : undefined
            height: control._vertical ? undefined : 2
            anchors.left: control._vertical ? undefined : parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: control._vertical ? parent.top : undefined
            Behavior on opacity { NumberAnimation { duration: Theme.durFast } }
        }

        FocusRing {
            active: control.visualFocus
            targetRadius: control._line ? Theme.radiusSm : pill.radius
        }
    }
}
