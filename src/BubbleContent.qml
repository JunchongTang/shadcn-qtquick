import QtQuick
import QtQuick.Layouts

// shadcn BubbleContent(base-mira)—— 气泡内容面。对标 .cn-bubble-content + 七种 .cn-bubble-variant-*:
//   rounded-lg · border(仅 outline 可见)· px-2.5 py-1.5 · text-xs/relaxed · w-fit max-w-full · overflow-hidden。
//   底色/前景由父 Bubble 的 variant 决定(mira 里 .cn-bubble-variant-* 作用于 *:data-[slot=bubble-content])。
//
// 内容:
//   · text —— 便捷纯文本气泡(最常见)。
//   · 默认子项 —— 富内容(如 textFormat: Text.MarkdownText 的 Text、Collapsible 等)。
//
// 交互(对标 render={<button/>} 的链接/按钮气泡):
//   · interactive: true 时启用 hover 变色 + 焦点环 + 手型光标,点击发 clicked()。
Rectangle {
    id: content

    property string text: ""
    property bool interactive: false
    signal clicked()

    // 富内容默认槽(追加在便捷 Text 之后)。
    default property alias contentItems: inner.data

    // ---- 从父 Bubble 读取上下文(以 maxWidthRatio 判定父类型)----
    readonly property Item _bubble: (parent && parent.maxWidthRatio !== undefined) ? parent : null
    readonly property int _variant: _bubble ? _bubble.variant : Bubble.Default
    readonly property bool _ghost: _variant === Bubble.Ghost

    readonly property real _hpad: _ghost ? 0 : Theme.space2_5   // px-2.5
    readonly property real _vpad: _ghost ? 0 : Theme.space1_5   // py-1.5
    // max-width 基准 = 真正的"会话列"。若气泡被套在 BubbleGroup 里,组自身是 fillWidth 布局、
    // 其宽度由子项隐式宽反推,直接读会与子项形成绑定环(读到 0);故上溯到组的父项(会话列,显式定宽)。
    readonly property Item _column: {
        if (!_bubble || !_bubble.parent) return null
        var p = _bubble.parent
        return (p.isBubbleGroup === true && p.parent) ? p.parent : p
    }
    // 会话列宽度(max-width 基准);ghost 用 100%,其余 80%。
    readonly property real _containerW: _column ? _column.width : 0
    readonly property real _maxW: _containerW <= 0 ? 100000
                                                   : _containerW * (_ghost ? 1.0 : _bubble.maxWidthRatio)
    readonly property real _innerMaxW: Math.max(0, _maxW - 2 * _hpad)

    // ---- 前景色(按变体)----
    readonly property color _fg: {
        switch (_variant) {
        case Bubble.Default: return Theme.primaryForeground
        case Bubble.Secondary: return Theme.secondaryForeground
        case Bubble.Destructive: return Theme.destructive
        default: return Theme.foreground   // muted / tinted / outline / ghost
        }
    }

    // tinted:oklch(from primary 0.93 c*0.4 h)近似——保留 primary 色相,提亮并降饱和。
    // 明:S≈primary.S*0.9 L≈0.84;暗:S≈primary.S L≈0.12(hover 略深)。
    readonly property color _tinted: Theme.dark
        ? Qt.hsla(Theme.primary.hslHue, Theme.primary.hslSaturation, 0.12, 1)
        : Qt.hsla(Theme.primary.hslHue, Theme.primary.hslSaturation * 0.90, 0.84, 1)
    readonly property color _tintedHover: Theme.dark
        ? Qt.hsla(Theme.primary.hslHue, Theme.primary.hslSaturation, 0.15, 1)
        : Qt.hsla(Theme.primary.hslHue, Theme.primary.hslSaturation * 0.74, 0.76, 1)

    // color-mix(in oklch, base, foreground N%) 的线性近似。
    function _mix(base, over, t) {
        return Qt.rgba(base.r * (1 - t) + over.r * t,
                       base.g * (1 - t) + over.g * t,
                       base.b * (1 - t) + over.b * t, 1)
    }
    // 内容面底色(hovered 仅在 interactive 时生效)。
    function _bgFor(hovered) {
        var h = hovered && interactive
        switch (_variant) {
        case Bubble.Default:     return h ? Theme.alpha(Theme.primary, 0.8) : Theme.primary
        case Bubble.Secondary:   return h ? _mix(Theme.secondary, Theme.foreground, 0.05) : Theme.secondary
        case Bubble.Muted:       return h ? _mix(Theme.muted, Theme.foreground, 0.05) : Theme.muted
        case Bubble.Tinted:      return h ? _tintedHover : _tinted
        case Bubble.Outline:     return h ? (Theme.dark ? Theme.alpha(Theme.input, 0.3) : Theme.muted) : Theme.background
        case Bubble.Ghost:       return h ? (Theme.dark ? Theme.alpha(Theme.muted, 0.5) : Theme.muted) : Theme.alpha(Theme.muted, 0)
        case Bubble.Destructive: return Theme.alpha(Theme.destructive, Theme.dark ? (h ? 0.3 : 0.2) : (h ? 0.2 : 0.1))
        }
        return "transparent"
    }

    implicitWidth: inner.implicitWidth + 2 * _hpad
    implicitHeight: inner.implicitHeight + 2 * _vpad

    radius: _ghost ? 0 : Theme.radiusLg
    clip: true                                          // overflow-hidden:内容永不溢出背景
    color: _bgFor(hover.hovered)
    border.width: _variant === Bubble.Outline ? 1 : 0   // 其余变体 border-transparent
    border.color: Theme.border
    Behavior on color { ColorAnimation { duration: Theme.durBase } }   // [button,a]:transition-colors

    // 完成时把自己注册为父 Bubble 的内容面(驱动容器尺寸)。
    Component.onCompleted: if (_bubble) _bubble._contentRef = content

    ColumnLayout {
        id: inner
        x: content._hpad
        y: content._vpad
        spacing: Theme.space1   // gap-1

        // 便捷纯文本(text 非空时显示)。
        Text {
            visible: content.text !== ""
            text: content.text
            color: content._fg
            font.pixelSize: Theme.textXs
            lineHeight: Theme.lineRelaxed
            lineHeightMode: Text.ProportionalHeight
            wrapMode: Text.Wrap
            Layout.maximumWidth: content._innerMaxW
            // button 类气泡文本左对齐([button]:text-left)。
            horizontalAlignment: Text.AlignLeft
        }
    }

    // 交互态:hover / 点击 / 手型。
    HoverHandler { id: hover; enabled: content.interactive; cursorShape: Qt.PointingHandCursor }
    TapHandler { enabled: content.interactive; onTapped: content.clicked() }

    // 焦点环([button,a]:focus-visible:border-ring ring-2 ring-ring/30)。
    activeFocusOnTab: interactive
    FocusRing { active: content.interactive && content.activeFocus; targetRadius: content.radius }
}
