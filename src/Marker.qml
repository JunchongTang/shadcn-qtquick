import QtQuick
import QtQuick.Layouts
import LucideIcons

// shadcn Marker(base-mira)—— 会话中的内联标记:状态/系统提示/带边框行/带标签分隔。
// 严格对齐 style-mira.css 的 .cn-marker / .cn-marker-variant-* / .cn-marker-icon / .cn-marker-content。
//
// 令牌对照:
//   .cn-marker           → gap-2(8) · text-xs/relaxed(12 / 1.625) · text-muted-foreground · min-h-4(16) · text-left
//                          svg size-3.5(14) · [a] hover:text-foreground · [a] underline underline-offset-3
//   .cn-marker-variant-separator → before/after h-px flex-1 bg-border · before mr-1(4) · after ml-1(4);内容 flex-none text-center
//   .cn-marker-variant-border    → border-b border-border · pb-2(8)
//   .cn-marker-icon      → size-3.5(14)
//
// 自包含:图标经 iconName(Lucide)或 spinner(加载态旋转)提供;内容经 text 提供。
// 交互(官方 render=<a>/<button>):interactive=true → hover 转 foreground + 可点击(clicked());
//   underline=true → 常驻下划线(链接语义)。
// shimmer:官方为 background-clip:text 的扫光,QML 无等价能力,此处以不透明度脉冲近似(见 _shimmerAnim),已标注。
Item {
    id: root

    enum Variant { Default, Separator, Border }

    property int variant: Marker.Default
    property string text: ""            // MarkerContent 文本
    property string iconName: ""        // MarkerIcon(Lucide 名),空 = 无图标
    property bool spinner: false        // 状态标记:以旋转 Spinner 代替静态图标(role="status")
    property bool shimmer: false        // 流式微光(不透明度脉冲近似)
    property bool interactive: false    // render=<a>/<button>:hover→foreground + 可点击
    property bool underline: false      // 链接语义:常驻下划线
    property bool stacked: false        // className="flex-col":图标在上、内容在下

    signal clicked()

    readonly property bool _isSeparator: variant === Marker.Separator
    readonly property bool _isBorder: variant === Marker.Border
    readonly property bool _hasIcon: iconName !== "" || spinner
    // svg size-3.5 = 14px(.cn-marker / .cn-marker-icon)
    readonly property int _iconSize: 14
    readonly property color _textColor: (interactive && _hover.hovered)
                                         ? Theme.foreground : Theme.mutedForeground

    Layout.fillWidth: true              // w-full(在 ColumnLayout 中铺满)
    implicitWidth: _body.implicitWidth
    // min-h-4(16);border 变体额外 pb-2(8) + border-b(1)
    implicitHeight: Math.max(16, _body.implicitHeight + (_isBorder ? Theme.space2 + 1 : 0))

    // 交互态:hover 变色 + 指针 + 点击。
    HoverHandler {
        id: _hover
        enabled: root.interactive
        cursorShape: Qt.PointingHandCursor
    }
    TapHandler {
        enabled: root.interactive
        onTapped: root.clicked()
    }

    // ==== 横向布局(default / border / separator)====
    RowLayout {
        id: _body
        visible: !root.stacked
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: Theme.space2            // gap-2

        // separator:左侧分隔线(before:h-px flex-1 bg-border · mr-1)
        Rectangle {
            visible: root._isSeparator
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            Layout.rightMargin: Theme.space1   // before:mr-1(4)
            color: Theme.border
        }

        // 图标槽(Lucide 或 Spinner);separator 时随内容居中
        LucideIcon {
            visible: root._hasIcon && !root.spinner
            Layout.alignment: Qt.AlignVCenter
            name: root.iconName
            size: root._iconSize
            color: root._textColor
        }
        Spinner {
            visible: root._hasIcon && root.spinner
            Layout.alignment: Qt.AlignVCenter
            size: root._iconSize
            color: root._textColor
        }

        // 内容:默认左对齐并可换行(min-w-0 wrap-break-word);separator 时 flex-none 居中
        Text {
            id: _contentH
            visible: root.text !== ""
            Layout.fillWidth: !root._isSeparator     // separator:flex-none(自然宽)
            Layout.alignment: Qt.AlignVCenter
            text: root.text
            color: root._textColor
            font.pixelSize: Theme.textXs             // text-xs(12)
            font.underline: root.underline           // [a]:underline
            lineHeight: Theme.lineRelaxed            // /relaxed(1.625)
            lineHeightMode: Text.ProportionalHeight
            wrapMode: Text.Wrap
            horizontalAlignment: root._isSeparator ? Text.AlignHCenter : Text.AlignLeft
            Behavior on color { ColorAnimation { duration: Theme.durBase } }

            SequentialAnimation on opacity {
                id: _shimmerAnim
                running: root.shimmer
                loops: Animation.Infinite
                // 近似 CSS shimmer 扫光:QML 无 background-clip:text,以不透明度脉冲近似流式微光。
                NumberAnimation { from: 1.0; to: 0.4; duration: 1000; easing.type: Easing.InOutSine }
                NumberAnimation { from: 0.4; to: 1.0; duration: 1000; easing.type: Easing.InOutSine }
            }
        }

        // separator:右侧分隔线(after:h-px flex-1 bg-border · ml-1)
        Rectangle {
            visible: root._isSeparator
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            Layout.leftMargin: Theme.space1    // after:ml-1(4)
            color: Theme.border
        }
    }

    // ==== 纵向布局(flex-col:图标在上、内容在下,居中)====
    ColumnLayout {
        id: _bodyStacked
        visible: root.stacked
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        spacing: Theme.space2

        LucideIcon {
            visible: root._hasIcon && !root.spinner
            Layout.alignment: Qt.AlignHCenter
            name: root.iconName
            size: root._iconSize
            color: root._textColor
        }
        Spinner {
            visible: root._hasIcon && root.spinner
            Layout.alignment: Qt.AlignHCenter
            size: root._iconSize
            color: root._textColor
        }
        Text {
            visible: root.text !== ""
            Layout.alignment: Qt.AlignHCenter
            text: root.text
            color: root._textColor
            font.pixelSize: Theme.textXs
            font.underline: root.underline
            lineHeight: Theme.lineRelaxed
            lineHeightMode: Text.ProportionalHeight
            horizontalAlignment: Text.AlignHCenter
            Behavior on color { ColorAnimation { duration: Theme.durBase } }
            SequentialAnimation on opacity {
                running: root.shimmer && root.stacked
                loops: Animation.Infinite
                NumberAnimation { from: 1.0; to: 0.4; duration: 1000; easing.type: Easing.InOutSine }
                NumberAnimation { from: 0.4; to: 1.0; duration: 1000; easing.type: Easing.InOutSine }
            }
        }
    }

    // ==== border 变体:底部 1px 边框(border-b border-border),内容与边框间 pb-2(8)====
    Rectangle {
        visible: root._isBorder
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: Theme.border
    }
}
