import QtQuick
import QtQuick.Layouts

// shadcn Item(base-mira) —— 通用内容行容器:media | content(拉伸) | actions,
// 可选 header / footer 独占整行(对标 flex-wrap + basis-full)。
// 变体 default(透明无边)/ outline(描边)/ muted(muted/50 底);尺寸 default / sm / xs。
// 类型名用 ShadItem(而非 Item):经实测,把名为 Item 的类型注册进 Shadcn 模块会遮蔽
// QtQuick.Item —— 同模块内所有用裸 `Item {}` 的兄弟文件(Card/Badge/AccordionItem 根等)
// 及所有先 import QtQuick 后 import Shadcn 的消费文件都会被改指到本类型,破坏全库。
// 故根用 `import QtQuick as QQ`(QQ.Item),对外暴露类型 ShadItem。
// asLink=true 时:悬停 bg-muted、指针手型、可点击(clicked),并显示焦点环。
Item {
    id: control

    enum Variant { Default, Outline, Muted }
    enum Size { Default, Sm, Xs }

    property int variant: ShadItem.Default
    property int size: ShadItem.Default
    property bool asLink: false
    signal clicked()

    // 标识槽位(供 ItemGroup 识别并据子项尺寸决定间距)。
    readonly property string itemSlot: "item"

    // 消费方子项(ItemMedia/ItemContent/ItemActions/ItemHeader/ItemFooter)进入主行,
    // 完成后按 itemSlot 把 header/footer 迁出到独立整行区。
    default property alias content: mainRow.data

    // 内边距:default/sm px-3 py-2.5;xs px-2.5 py-2。flex gap 统一 gap-2.5(10)。
    readonly property real _padH: size === ShadItem.Xs ? Theme.space2_5 : Theme.space3
    readonly property real _padV: size === ShadItem.Xs ? Theme.space2 : Theme.space2_5
    readonly property real _gap: Theme.space2_5

    implicitWidth: layoutCol.implicitWidth + _padH * 2
    implicitHeight: layoutCol.implicitHeight + _padV * 2

    activeFocusOnTab: asLink

    // 背景 + 边框(按变体;asLink 悬停变 bg-muted)。
    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Theme.radiusMd
        border.width: control.variant === ShadItem.Outline ? 1 : 0
        border.color: Theme.border
        color: {
            var hov = control.asLink && hover.hovered
            if (control.variant === ShadItem.Muted)
                return hov ? Theme.muted : Theme.alpha(Theme.muted, 0.5)
            return hov ? Theme.muted : "transparent"
        }
    }

    ColumnLayout {
        id: layoutCol
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: control._padH
        anchors.rightMargin: control._padH
        anchors.topMargin: control._padV
        anchors.bottomMargin: control._padV
        spacing: control._gap

        // ---- header 区(basis-full,独占整行,置顶)----
        ColumnLayout {
            id: headerZone
            Layout.fillWidth: true
            spacing: control._gap
            visible: children.length > 0
        }

        // ---- 主行:media | content(拉伸) | actions ----
        RowLayout {
            id: mainRow
            Layout.fillWidth: true
            spacing: control._gap
        }

        // ---- footer 区(basis-full,独占整行,置底)----
        ColumnLayout {
            id: footerZone
            Layout.fillWidth: true
            spacing: control._gap
            visible: children.length > 0
        }
    }

    FocusRing {
        active: control.asLink && control.activeFocus
        targetRadius: Theme.radiusMd
    }

    HoverHandler {
        id: hover
        enabled: control.asLink
        cursorShape: Qt.PointingHandCursor
    }
    TapHandler {
        enabled: control.asLink
        onTapped: control.clicked()
    }

    Component.onCompleted: _route()
    function _route() {
        var kids = []
        for (var i = 0; i < mainRow.children.length; i++)
            kids.push(mainRow.children[i])

        var contentCount = 0
        var hasDesc = false
        var medias = []
        for (var j = 0; j < kids.length; j++) {
            var c = kids[j]
            if (!c || c.itemSlot === undefined)
                continue
            switch (c.itemSlot) {
            case "item-header":
                c.parent = headerZone
                break
            case "item-footer":
                c.parent = footerZone
                break
            case "item-media":
                if (c.hostSize !== undefined)
                    c.hostSize = control.size
                medias.push(c)
                break
            case "item-content":
                if (c.hostSize !== undefined)
                    c.hostSize = control.size
                contentCount++
                // [&+[data-slot=item-content]]:flex-none —— 第二个及以后的 content 不拉伸。
                if (contentCount > 1 && c.contentFill !== undefined)
                    c.contentFill = false
                if (c.hasDescription)
                    hasDesc = true
                break
            }
        }
        // group-has-data-[slot=item-description]:media 顶对齐 + 下移 0.5(2px)。
        for (var k = 0; k < medias.length; k++) {
            if (medias[k].topShift !== undefined)
                medias[k].topShift = hasDesc
        }
    }
}
