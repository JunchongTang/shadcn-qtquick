import QtQuick
import QtQuick.Layouts

// shadcn Collapsible(base-mira)—— 由 `expanded` 受控的可折叠面板。
// 对标 base-ui Collapsible:Root(open) / Trigger / Panel。mira 无专属 .cn-collapsible
// 样式,组件本身仅提供结构 + 高度动画,视觉由内部放置的 Button/内容自行决定。
//
// 组成:
//   · trigger 槽 —— 常驻的顶部触发区(内含负责开合的控件,通常调用 collapsible.toggle())。
//   · 默认内容 —— 可折叠面板(Panel),展开/收起时高度动画(参照 AccordionItem 范式)。
//
// 用法:
//   Collapsible {
//       id: c
//       trigger: Button { text: "Toggle"; onClicked: c.toggle() }
//       // 以下为可折叠内容(默认 content 槽)
//       Text { Layout.fillWidth: true; text: "..." }
//   }
Item {
    id: root

    property bool expanded: false
    // trigger 与内容之间、以及内容各子项之间的间距(对标 demo 的 gap-2)。
    property real gap: Theme.space2
    // 可选背景(对标 Basic 的 rounded-md data-open:bg-muted)。默认无背景。
    property color background: "transparent"
    property real radius: 0

    property alias trigger: triggerSlot.data
    default property alias content: body.data

    function toggle() { expanded = !expanded }

    // 尺寸由子项驱动;宽度需由外部(Layout/显式 width)提供,避免自引用循环。
    implicitWidth: Math.max(triggerSlot.implicitWidth, body.implicitWidth)
    implicitHeight: triggerSlot.height + contentClip.height

    // 背景铺满当前(随高度动画)区域。
    Rectangle {
        anchors.fill: parent
        color: root.background
        radius: root.radius
        visible: root.background.a > 0
    }

    // ---- 常驻触发区 ----
    Item {
        id: triggerSlot
        width: root.width
        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
        height: childrenRect.height
    }

    // ---- 可折叠面板(高度动画)----
    Item {
        id: contentClip
        anchors.top: triggerSlot.bottom
        width: root.width
        clip: true
        height: root.expanded ? body.implicitHeight + root.gap : 0
        Behavior on height { NumberAnimation { duration: Theme.durBase; easing.type: Easing.OutCubic } }

        ColumnLayout {
            id: body
            y: root.gap
            width: parent.width
            spacing: root.gap
        }
    }
}
