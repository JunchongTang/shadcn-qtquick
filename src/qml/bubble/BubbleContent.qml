import QtQuick
import QtQuick.Layouts

/*!
    \qmltype BubbleContent
    \inqmlmodule Shadcn
    \inherits Rectangle
    \brief The visual body of a \l Bubble.

    BubbleContent is the QML port of shadcn's \c .cn-bubble-content together with
    the seven \c .cn-bubble-variant-* rules: \c {rounded-lg border px-2.5 py-1.5
    text-xs/relaxed w-fit max-w-full overflow-hidden}. The background and
    foreground come from the parent \l Bubble's \l {Bubble::variant}{variant}.

    Provide plain text via \l text, or place rich content (a \c Text with
    \c textFormat: Text.MarkdownText, a Collapsible, etc.) as default children.
    Set \l interactive to true for link/button bubbles: it enables a hover color
    shift, a focus ring, a pointing-hand cursor and the \l clicked signal.

    \qml
    Bubble {
        variant: Bubble.Outline
        BubbleContent { interactive: true; text: "Reply"; onClicked: ... }
    }
    \endqml

    \sa Bubble
*/
Rectangle {
    id: content

    /*! Convenience plain-text content (shown when non-empty). */
    property string text: ""
    /*! Enables hover color shift, focus ring, pointing cursor and \l clicked. */
    property bool interactive: false
    /*! Emitted when an \l interactive content is tapped. */
    signal clicked()

    /*! Default slot for rich content (appended after the convenience Text). */
    default property alias contentItems: inner.data

    // ---- Context read from the parent Bubble (detected via maxWidthRatio) ----
    readonly property Item _bubble: (parent && parent.maxWidthRatio !== undefined) ? parent : null
    readonly property int _variant: _bubble ? _bubble.variant : Bubble.Default
    readonly property bool _ghost: _variant === Bubble.Ghost

    readonly property real _hpad: _ghost ? 0 : Theme.space2_5   // px-2.5
    readonly property real _vpad: _ghost ? 0 : Theme.space1_5   // py-1.5
    // The max-width base is the real conversation column. When the bubble lives in
    // a BubbleGroup (a fillWidth layout whose width is derived from its children),
    // reading the group width would form a binding loop (reads 0); walk up to the
    // group's parent (the explicitly sized column) instead.
    readonly property Item _column: {
        if (!_bubble || !_bubble.parent) return null
        var p = _bubble.parent
        return (p.isBubbleGroup === true && p.parent) ? p.parent : p
    }
    // Conversation column width (max-width base); ghost uses 100%, others 80%.
    readonly property real _containerW: _column ? _column.width : 0
    readonly property real _maxW: _containerW <= 0 ? 100000
                                                   : _containerW * (_ghost ? 1.0 : _bubble.maxWidthRatio)
    readonly property real _innerMaxW: Math.max(0, _maxW - 2 * _hpad)

    // ---- Foreground color (by variant) ----
    readonly property color _fg: {
        switch (_variant) {
        case Bubble.Default: return Theme.primaryForeground
        case Bubble.Secondary: return Theme.secondaryForeground
        case Bubble.Destructive: return Theme.destructive
        default: return Theme.foreground   // muted / tinted / outline / ghost
        }
    }

    // tinted: approximates oklch(from primary 0.93 calc(c*0.4) h) in HSL - keeps
    // the primary hue, lightens and desaturates. Light L~0.84 / dark L~0.12.
    readonly property color _tinted: Theme.dark
        ? Qt.hsla(Theme.primary.hslHue, Theme.primary.hslSaturation, 0.12, 1)
        : Qt.hsla(Theme.primary.hslHue, Theme.primary.hslSaturation * 0.90, 0.84, 1)
    readonly property color _tintedHover: Theme.dark
        ? Qt.hsla(Theme.primary.hslHue, Theme.primary.hslSaturation, 0.15, 1)
        : Qt.hsla(Theme.primary.hslHue, Theme.primary.hslSaturation * 0.74, 0.76, 1)

    // Linear-RGB approximation of color-mix(in oklch, base, over N%).
    function _mix(base, over, t) {
        return Qt.rgba(base.r * (1 - t) + over.r * t,
                       base.g * (1 - t) + over.g * t,
                       base.b * (1 - t) + over.b * t, 1)
    }
    // Content background (hover shift applies only when interactive).
    function _bgFor(hovered) {
        var h = hovered && interactive
        switch (_variant) {
        case Bubble.Default:     return h ? Theme.alpha(Theme.primary, 0.8) : Theme.primary
        case Bubble.Secondary:   return h ? _mix(Theme.secondary, Theme.foreground, 0.05) : Theme.secondary
        case Bubble.Muted:       return h ? _mix(Theme.muted, Theme.foreground, 0.05) : Theme.muted
        case Bubble.Tinted:      return h ? _tintedHover : _tinted
        case Bubble.Outline:     return h ? (Theme.dark ? Theme.alpha(Theme.input, Theme.input.a * (0.3)) : Theme.muted) : Theme.background
        case Bubble.Ghost:       return h ? (Theme.dark ? Theme.alpha(Theme.muted, 0.5) : Theme.muted) : Theme.alpha(Theme.muted, 0)
        case Bubble.Destructive: return Theme.alpha(Theme.destructive, Theme.dark ? (h ? 0.3 : 0.2) : (h ? 0.2 : 0.1))
        }
        return "transparent"
    }

    implicitWidth: inner.implicitWidth + 2 * _hpad
    implicitHeight: inner.implicitHeight + 2 * _vpad

    radius: _ghost ? 0 : Theme.radiusLg
    clip: true                                          // overflow-hidden
    color: _bgFor(hover.hovered)
    border.width: _variant === Bubble.Outline ? 1 : 0   // other variants: border-transparent
    border.color: Theme.border
    Behavior on color { ColorAnimation { duration: Theme.durBase } }   // [button,a]:transition-colors

    // Register as the parent Bubble's content on completion (drives its size).
    Component.onCompleted: if (_bubble) _bubble._contentRef = content

    ColumnLayout {
        id: inner
        x: content._hpad
        y: content._vpad
        spacing: Theme.space1   // gap-1

        // Convenience plain text (shown when text is non-empty).
        Text {
            visible: content.text !== ""
            text: content.text
            color: content._fg
            font.pixelSize: Theme.textXs
            lineHeight: Theme.lineRelaxed
            lineHeightMode: Text.ProportionalHeight
            wrapMode: Text.Wrap
            Layout.maximumWidth: content._innerMaxW
            horizontalAlignment: Text.AlignLeft   // [button]:text-left
        }
    }

    // Interactive state: hover / tap / pointing cursor.
    HoverHandler { id: hover; enabled: content.interactive; cursorShape: Qt.PointingHandCursor }
    TapHandler { enabled: content.interactive; onTapped: content.clicked() }

    // Focus ring ([button,a]:focus-visible:border-ring ring-2 ring-ring/30).
    activeFocusOnTab: interactive
    FocusRing { active: content.interactive && content.activeFocus; targetRadius: content.radius }
}
