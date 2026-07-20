import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C

// shadcn Attachment(base-mira) —— 文件/图片附件卡:左侧媒体(缩略图/文件类型图标)+
// 名称/大小元信息 + 右侧操作(移除/重试…),并按上传生命周期呈现不同外观。
// 对标 .cn-attachment 与 registry/bases/base/ui/attachment.tsx。
//
// 组成:Attachment > AttachmentMedia | AttachmentContent(AttachmentName/AttachmentSize) |
//        AttachmentActions(AttachmentAction) | AttachmentTrigger(全卡覆盖点击)。
// 多个附件用 AttachmentGroup 横向排列。
//
// 说明:官方 root 属性名为 `state`,但 QtQuick.Item 已内置 string 型 `state`,为避免
// 冲突,这里改名 `uploadState`(语义完全一致)。子件通过路由注入 hostState/hostSize/
// hostOrientation。拖放/真实上传逻辑用静态状态近似(见 demos 标注)。
Item {
    id: control

    // 上传生命周期(= 官方 state)。驱动描边样式与标题微光。
    enum State { Idle, Uploading, Processing, Error, Done }
    enum Size { Default, Sm, Xs }
    enum Orientation { Horizontal, Vertical }

    property int uploadState: Attachment.Done
    property int size: Attachment.Default
    property int orientation: Attachment.Horizontal

    // 全卡 AttachmentTrigger 被激活(点击/回车)时触发。
    signal triggered()

    // 默认子项进入 sink,onCompleted 后按 attachSlot 路由到布局。
    default property alias content: sink.data

    readonly property bool _horizontal: orientation === Attachment.Horizontal
    readonly property bool _idle: uploadState === Attachment.Idle
    readonly property bool _error: uploadState === Attachment.Error

    // 内边距 / 间距 / 圆角(对标 .cn-attachment-size-*)。
    // default: px-2 py-1.5 gap-2;sm/xs: px-1.5 py-1;sm gap-2.5;xs gap-1.5 rounded-md。
    readonly property real _padH: size === Attachment.Default ? Theme.space2 : Theme.space1_5
    readonly property real _padV: size === Attachment.Default ? Theme.space1_5 : Theme.space1
    readonly property real _gap: size === Attachment.Default ? Theme.space2
                               : size === Attachment.Sm ? Theme.space2_5 : Theme.space1_5
    readonly property real _radius: size === Attachment.Xs ? Theme.radiusMd : Theme.radiusLg

    // 垂直:固定窄卡 w-24(96)/ 有内容 w-30(120);水平:min-w-40(160)。
    property bool _hasContent: false
    property bool _hasTrigger: false

    implicitWidth: _horizontal
        ? Math.max(160, rowFlow.implicitWidth + _padH * 2)
        : (_hasContent ? 120 : 96)
    implicitHeight: _horizontal
        ? rowFlow.implicitHeight + _padV * 2
        : colFlow.implicitHeight + _padV * 2

    activeFocusOnTab: false

    // 隐藏收集区。
    Item { id: sink; visible: false; width: 0; height: 0 }

    // ==== 背景 + 描边 ====
    // bg-card;含 trigger 且悬停 → bg-muted/50。idle 用虚线,error 用 destructive/30。
    Rectangle {
        id: bgRect
        anchors.fill: parent
        radius: control._radius
        color: (control._hasTrigger && rootHover.hovered)
               ? Theme.alpha(Theme.muted, 0.5) : Theme.card
        border.width: control._idle ? 0 : 1
        border.color: control._error ? Theme.alpha(Theme.destructive, 0.30) : Theme.border
        Behavior on color { ColorAnimation { duration: Theme.durBase } }
    }

    // idle 虚线描边(Qt Rectangle 不支持 dash,用 Canvas 近似 border-dashed)。
    Canvas {
        id: dashBorder
        anchors.fill: parent
        visible: control._idle
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            var r = control._radius, w = width - 1, h = height - 1, x = 0.5, y = 0.5
            ctx.strokeStyle = Theme.border
            ctx.lineWidth = 1
            ctx.setLineDash([4, 4])
            ctx.beginPath()
            ctx.moveTo(x + r, y)
            ctx.arcTo(x + w, y, x + w, y + h, r)
            ctx.arcTo(x + w, y + h, x, y + h, r)
            ctx.arcTo(x, y + h, x, y, r)
            ctx.arcTo(x, y, x + w, y, r)
            ctx.closePath()
            ctx.stroke()
        }
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        // 主题切换(border 颜色随明暗变化)时重绘。
        readonly property color _strokeColor: Theme.border
        on_StrokeColorChanged: requestPaint()
    }

    // ==== 全卡触发覆盖(位于内容之下,以便 actions 保持独立可点)====
    // 内容里的 Text/Image/Rectangle 不吃鼠标 → 事件穿透到此;actions 为真实按钮,自行拦截。
    C.Button {
        id: triggerButton
        anchors.fill: parent
        visible: control._hasTrigger
        enabled: control._hasTrigger
        activeFocusOnTab: control._hasTrigger
        hoverEnabled: true
        background: Item {}
        contentItem: Item {}
        onClicked: {
            if (control._trigger)
                control._trigger.clicked()
            control.triggered()
        }
    }
    property var _trigger: null
    HoverHandler {
        id: rootHover
        enabled: control._hasTrigger
        cursorShape: Qt.PointingHandCursor
    }

    // ==== 水平布局:media | content(拉伸) | actions ====
    RowLayout {
        id: rowFlow
        visible: control._horizontal
        anchors.fill: parent
        anchors.leftMargin: control._padH
        anchors.rightMargin: control._padH
        anchors.topMargin: control._padV
        anchors.bottomMargin: control._padV
        spacing: control._gap
    }

    // ==== 垂直布局:media(整宽方形)/ content;actions 绝对定位右上 ====
    ColumnLayout {
        id: colFlow
        visible: !control._horizontal
        anchors.fill: parent
        anchors.leftMargin: control._padH
        anchors.rightMargin: control._padH
        anchors.topMargin: control._padV
        anchors.bottomMargin: control._padV
        spacing: control._gap
    }

    // 1px 焦点内环(focus-within:ring-1 ring-ring/30 近似:trigger 获焦时)。
    Rectangle {
        anchors.fill: parent
        anchors.margins: -1
        radius: control._radius + 1
        color: "transparent"
        border.width: 1
        border.color: Theme.alpha(Theme.ring, Theme.ringOpacity)
        visible: triggerButton.activeFocus
        z: 5
    }

    Component.onCompleted: _route()

    function _route() {
        var kids = []
        for (var i = 0; i < sink.children.length; i++)
            kids.push(sink.children[i])

        var media = null, contents = [], actions = null
        for (var j = 0; j < kids.length; j++) {
            var c = kids[j]
            if (!c || c.attachSlot === undefined)
                continue
            switch (c.attachSlot) {
            case "attachment-media": media = c; break
            case "attachment-content": contents.push(c); break
            case "attachment-actions": actions = c; break
            case "attachment-trigger":
                control._trigger = c
                control._hasTrigger = true
                break
            }
        }
        _hasContent = contents.length > 0

        // 注入宿主状态。
        if (media) {
            if (media.hostSize !== undefined) media.hostSize = Qt.binding(function(){ return control.size })
            if (media.hostOrientation !== undefined) media.hostOrientation = Qt.binding(function(){ return control.orientation })
            if (media.hostState !== undefined) media.hostState = Qt.binding(function(){ return control.uploadState })
        }
        for (var k = 0; k < contents.length; k++) {
            var ct = contents[k]
            if (ct.hostSize !== undefined) ct.hostSize = Qt.binding(function(){ return control.size })
            if (ct.hostState !== undefined) ct.hostState = Qt.binding(function(){ return control.uploadState })
        }

        var flow = control._horizontal ? rowFlow : colFlow

        if (media) {
            media.parent = flow
            if (control._horizontal) {
                media.Layout.alignment = Qt.AlignVCenter
            } else {
                media.Layout.fillWidth = true
                media.Layout.preferredHeight = Qt.binding(function(){ return media.width })
            }
        }
        for (var m = 0; m < contents.length; m++) {
            var cc = contents[m]
            cc.parent = flow
            cc.Layout.fillWidth = true
            // 第二个及以后的 content 不拉伸(flex-none),对标 Item 家族。
            if (m > 0 && cc.contentFill !== undefined) {
                cc.contentFill = false
                cc.Layout.fillWidth = false
            }
        }
        if (actions) {
            if (control._horizontal) {
                actions.parent = flow
                actions.Layout.alignment = Qt.AlignVCenter
                if (actions.hostOrientation !== undefined)
                    actions.hostOrientation = Attachment.Horizontal
            } else {
                // 垂直:绝对定位右上(top-3 right-3)、z-20。
                actions.parent = control
                actions.z = 20
                actions.anchors.top = control.top
                actions.anchors.right = control.right
                actions.anchors.topMargin = Theme.space3
                actions.anchors.rightMargin = Theme.space3
                if (actions.hostOrientation !== undefined)
                    actions.hostOrientation = Attachment.Vertical
            }
        }
    }
}
