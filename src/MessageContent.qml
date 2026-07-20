import QtQuick
import QtQuick.Layouts
import LucideIcons

// shadcn MessageContent(base-mira)—— 包裹 header / 气泡 / footer 的纵向内容列。
// 自包含:气泡由本组件直接绘制(不依赖 Bubble 组件),通过 text + variant 驱动;
// 常见附件(图片封面 / 文件卡)以 imageSource / fileName 便捷属性内建绘制。
// hover 操作按钮由默认子项提供,经内部 MessageActions 落在 footer 行内(默认随 hover 淡显)。
//
// 根用 Item 包裹一个具名 ColumnLayout:内部布局子项落在具名列里,
// 而消费方的默认子项(操作按钮)则经 default alias 路由到 footer 的 MessageActions。
//
// align:0=Start(靠左)/1=End(靠右)。放入 Message 内时自动继承父 Message.align;
// 独立使用时可显式设置。
//
// 未实现(基础版诚实跳过):富文本/markdown、代码块、气泡尾巴、反应表情(reactions)、
// 附件的完整变体与操作、多气泡 BubbleGroup 的精细圆角。
Item {
    id: root

    // 气泡变体(对齐 cn-bubble-variant-*)。
    enum Variant { Default, Muted, Outline, Destructive, Ghost, Secondary }

    // 自动继承祖先 Message 的 align;未找到则 Start(0)。
    property int align: {
        var p = parent
        while (p) {
            if (p.isMessageRow === true)
                return p.align
            p = p.parent
        }
        return 0
    }

    property string header: ""
    property string text: ""
    property int variant: MessageContent.Muted
    property bool typing: false                  // 打字机点动画(替代 text)
    property string footer: ""                   // 底部状态文本
    property bool footerDestructive: false        // 状态文本用 destructive 色
    property bool actionsOnHover: true            // 操作按钮:仅悬停显示
    property url imageSource                       // 图片附件(气泡上方)
    property string fileName: ""                  // 文件附件标题(气泡下方)
    property string fileMeta: ""                  // 文件附件副信息

    // 默认子项 → hover 操作按钮(落入 footer 内的 MessageActions)。
    default property alias actions: actionsInner.actions

    readonly property bool _end: align === 1
    readonly property int _side: _end ? Qt.AlignRight : Qt.AlignLeft
    readonly property bool _ghost: variant === MessageContent.Ghost
    readonly property int _padH: _ghost ? 0 : Theme.space2_5   // px-2.5
    readonly property int _padV: _ghost ? 0 : Theme.space1_5   // py-1.5

    readonly property color _bubbleBg: {
        switch (variant) {
        case MessageContent.Default:     return Theme.primary
        case MessageContent.Secondary:   return Theme.secondary
        case MessageContent.Muted:       return Theme.muted
        case MessageContent.Outline:     return Theme.background
        case MessageContent.Destructive: return Theme.alpha(Theme.destructive, Theme.dark ? 0.2 : 0.1)
        default:                         return "transparent" // Ghost
        }
    }
    readonly property color _bubbleFg: {
        switch (variant) {
        case MessageContent.Default:     return Theme.primaryForeground
        case MessageContent.Secondary:   return Theme.secondaryForeground
        case MessageContent.Destructive: return Theme.destructive
        default:                         return Theme.foreground
        }
    }

    Layout.fillWidth: true
    implicitWidth: col.implicitWidth
    implicitHeight: col.implicitHeight

    HoverHandler { id: hov }

    ColumnLayout {
        id: col
        anchors.fill: parent
        spacing: Theme.space2               // gap-2

        // ==== Header ====
        MessageHeader {
            text: root.header
            Layout.alignment: Qt.AlignLeft
        }

        // ==== 图片附件(气泡上方)====
        Rectangle {
            id: imageAttachment
            visible: String(root.imageSource) !== ""
            Layout.alignment: root._side
            implicitWidth: Math.min(220, root.width * 0.8)
            implicitHeight: implicitWidth * 0.66
            radius: Theme.radiusLg
            color: Theme.muted
            // 按圆角真正裁剪(clip 只裁矩形边界,会留方角)。
            RoundedImage {
                anchors.fill: parent
                source: root.imageSource
                radius: imageAttachment.radius
            }
        }

        // ==== 气泡 ====
        Rectangle {
            id: bubble
            visible: root.text !== "" || root.typing
            Layout.alignment: root._side
            Layout.maximumWidth: root.width * 0.8
            implicitWidth: (root.typing ? typingRow.width : bubbleText.width) + root._padH * 2
            implicitHeight: (root.typing ? typingRow.height : bubbleText.height) + root._padV * 2
            radius: root._ghost ? 0 : Theme.radiusLg          // rounded-lg
            color: root._bubbleBg
            border.width: root.variant === MessageContent.Outline ? 1 : 0
            border.color: Theme.border

            Text {
                id: bubbleText
                visible: !root.typing
                x: root._padH
                y: root._padV
                // 自然宽 vs 80% 上限:未超限单行,超限则换行(高度随换行增长)。
                width: Math.min(implicitWidth, root.width * 0.8 - root._padH * 2)
                text: root.text
                color: root._bubbleFg
                font.pixelSize: Theme.textXs                  // text-xs
                lineHeight: Theme.lineRelaxed                 // /relaxed
                lineHeightMode: Text.ProportionalHeight
                wrapMode: Text.Wrap
                textFormat: Text.PlainText
            }

            // 打字机三点动画(基础视觉状态之一)。三个点交错闪烁。
            Row {
                id: typingRow
                visible: root.typing
                x: root._padH
                y: root._padV
                spacing: 4

                Rectangle {
                    width: 6; height: 6; radius: 3; color: Theme.mutedForeground; opacity: 0.3
                    SequentialAnimation on opacity {
                        running: typingRow.visible; loops: Animation.Infinite
                        PauseAnimation { duration: 0 }
                        NumberAnimation { to: 1.0; duration: 300 }
                        NumberAnimation { to: 0.3; duration: 300 }
                        PauseAnimation { duration: 480 }
                    }
                }
                Rectangle {
                    width: 6; height: 6; radius: 3; color: Theme.mutedForeground; opacity: 0.3
                    SequentialAnimation on opacity {
                        running: typingRow.visible; loops: Animation.Infinite
                        PauseAnimation { duration: 160 }
                        NumberAnimation { to: 1.0; duration: 300 }
                        NumberAnimation { to: 0.3; duration: 300 }
                        PauseAnimation { duration: 320 }
                    }
                }
                Rectangle {
                    width: 6; height: 6; radius: 3; color: Theme.mutedForeground; opacity: 0.3
                    SequentialAnimation on opacity {
                        running: typingRow.visible; loops: Animation.Infinite
                        PauseAnimation { duration: 320 }
                        NumberAnimation { to: 1.0; duration: 300 }
                        NumberAnimation { to: 0.3; duration: 300 }
                        PauseAnimation { duration: 160 }
                    }
                }
            }
        }

        // ==== 文件附件(气泡下方)====
        Rectangle {
            id: fileAttachment
            visible: root.fileName !== ""
            Layout.alignment: root._side
            implicitWidth: fileRow.implicitWidth + Theme.space3 * 2
            implicitHeight: fileRow.implicitHeight + Theme.space2_5 * 2
            radius: Theme.radiusLg
            color: Theme.card
            border.width: 1
            border.color: Theme.border

            RowLayout {
                id: fileRow
                anchors.centerIn: parent
                spacing: Theme.space2_5
                LucideIcon {
                    name: "file-text"
                    size: 20
                    color: Theme.mutedForeground
                }
                ColumnLayout {
                    spacing: 0
                    Text {
                        text: root.fileName
                        color: Theme.foreground
                        font.pixelSize: Theme.textXs
                        font.weight: Font.Medium
                    }
                    Text {
                        visible: root.fileMeta !== ""
                        text: root.fileMeta
                        color: Theme.mutedForeground
                        font.pixelSize: 10
                    }
                }
                IconButton {
                    iconName: "download"
                    variant: IconButton.Secondary
                    size: IconButton.Small
                }
            }
        }

        // ==== Footer(状态文本 + hover 操作)====
        MessageFooter {
            id: footerRow
            visible: root.footer !== "" || root.footerDestructive
                     || actionsInner.children.length > 0
            Layout.alignment: root._side
            text: root.footer
            destructive: root.footerDestructive

            MessageActions {
                id: actionsInner
                shown: !root.actionsOnHover || hov.hovered
            }
        }
    }
}
