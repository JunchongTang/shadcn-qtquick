import QtQuick
import QtQuick.Layouts
import LucideIcons

/*!
    \qmltype Marker
    \inqmlmodule Shadcn
    \inherits Item
    \brief An inline conversation marker, styled after shadcn's base-mira marker.

    Marker renders shadcn's \c .cn-marker: a compact inline note used inside a
    conversation thread for status updates, system notes, bordered rows and
    labeled separators. It is laid out as a horizontal row of an optional icon
    plus content, at 12px relaxed text (\c text-xs/relaxed) in the muted
    foreground color, with a 16px minimum height (\c min-h-4).

    The icon slot is supplied either by a Lucide icon name (\l iconName) or by
    an animated \l Spinner (\l spinner, for streaming/in-progress markers).
    Content is supplied through \l text. Both are painted at 14px (\c size-3.5).

    Three layouts are selected by \l variant, mapping to shadcn's
    \c .cn-marker-variant-* rules. Setting \l stacked mirrors the \c flex-col
    className, stacking the icon above centered content.

    Interactive markers mirror shadcn's polymorphic \c render prop: set
    \l interactive to make the row hoverable (text shifts to the foreground
    color) and clickable (\l clicked), and \l underline for link semantics.

    The shimmer streaming effect (\l shimmer) approximates shadcn's
    \c background-clip:text sweep, which has no QML equivalent, with an
    opacity pulse instead.

    \qml
    Marker { text: "A default marker for inline notes." }
    Marker { variant: Marker.Separator; text: "Today" }
    Marker { variant: Marker.Border; iconName: "git-branch"; text: "Switched branch" }
    Marker { spinner: true; text: "Compacting conversation" }
    \endqml
*/
Item {
    id: root

    /*!
        \qmlproperty enumeration Marker::variant
        The marker layout. Values map to shadcn's \c .cn-marker-variant-* rules.
        \value Marker.Default An inline marker for status, notes and actions.
        \value Marker.Separator A centered label with divider lines on each side.
        \value Marker.Border A default marker with a 1px bottom border under the row.
    */
    enum Variant { Default, Separator, Border }

    property int variant: Marker.Default

    /*! \qmlproperty string Marker::text
        The marker content text (shadcn's \c MarkerContent). */
    property string text: ""

    /*! \qmlproperty string Marker::iconName
        Lucide icon name for the decorative icon slot; empty means no icon. */
    property string iconName: ""

    /*! \qmlproperty bool Marker::spinner
        When true, the icon slot shows an animated Spinner instead of a static
        icon, for streaming or in-progress markers (\c role="status"). */
    property bool spinner: false

    /*! \qmlproperty bool Marker::shimmer
        When true, the content text pulses (an approximation of shadcn's
        \c shimmer streaming-text sweep). */
    property bool shimmer: false

    /*! \qmlproperty bool Marker::interactive
        When true, the marker behaves as a link/button: it hovers to the
        foreground color, shows a pointing cursor and emits \l clicked. */
    property bool interactive: false

    /*! \qmlproperty bool Marker::underline
        When true, the content text is underlined (link semantics). */
    property bool underline: false

    /*! \qmlproperty bool Marker::stacked
        When true, the icon is stacked above centered content (\c flex-col). */
    property bool stacked: false

    /*! \qmlsignal Marker::clicked()
        Emitted when an \l interactive marker is tapped. */
    signal clicked()

    readonly property bool _isSeparator: variant === Marker.Separator
    readonly property bool _isBorder: variant === Marker.Border
    readonly property bool _hasIcon: iconName !== "" || spinner
    // svg size-3.5 = 14px (.cn-marker / .cn-marker-icon)
    readonly property int _iconSize: 14
    readonly property color _textColor: (interactive && _hover.hovered)
                                         ? Theme.foreground : Theme.mutedForeground

    Layout.fillWidth: true              // w-full (fills its ColumnLayout parent)
    // Sizing follows the active layout. min-h-4 (16); the border variant adds
    // pb-2 (8) + border-b (1) below the row.
    implicitWidth: root.stacked ? _bodyStacked.implicitWidth : _body.implicitWidth
    implicitHeight: root.stacked
                    ? Math.max(16, _bodyStacked.implicitHeight)
                    : Math.max(16, _body.implicitHeight + (_isBorder ? Theme.space2 + 1 : 0))

    // Interactive state: hover recolor + pointer + click.
    HoverHandler {
        id: _hover
        enabled: root.interactive
        cursorShape: Qt.PointingHandCursor
    }
    TapHandler {
        enabled: root.interactive
        onTapped: root.clicked()
    }

    // ==== Horizontal layout (default / border / separator) ====
    RowLayout {
        id: _body
        visible: !root.stacked
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: Theme.space2            // gap-2

        // separator: leading divider (before: h-px flex-1 bg-border, mr-1)
        Rectangle {
            visible: root._isSeparator
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            Layout.rightMargin: Theme.space1   // before:mr-1 (4)
            color: Theme.border
        }

        // Icon slot (Lucide or Spinner); centers with content in separator mode.
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

        // Content: left-aligned and wrapping by default (min-w-0 wrap-break-word);
        // flex-none and centered in separator mode.
        Text {
            id: _contentH
            visible: root.text !== ""
            Layout.fillWidth: !root._isSeparator     // separator: flex-none (natural width)
            Layout.alignment: Qt.AlignVCenter
            text: root.text
            color: root._textColor
            font.pixelSize: Theme.textXs             // text-xs (12)
            font.underline: root.underline
            lineHeight: Theme.lineRelaxed            // /relaxed (1.625)
            lineHeightMode: Text.ProportionalHeight
            wrapMode: Text.Wrap
            horizontalAlignment: root._isSeparator ? Text.AlignHCenter : Text.AlignLeft
            Behavior on color { ColorAnimation { duration: Theme.durBase } }

            // Approximates the CSS shimmer sweep (no QML background-clip:text)
            // with an opacity pulse. Only runs for the visible (row) layout.
            SequentialAnimation on opacity {
                running: root.shimmer && !root.stacked
                loops: Animation.Infinite
                NumberAnimation { from: 1.0; to: 0.4; duration: 1000; easing.type: Easing.InOutSine }
                NumberAnimation { from: 0.4; to: 1.0; duration: 1000; easing.type: Easing.InOutSine }
            }
        }

        // separator: trailing divider (after: h-px flex-1 bg-border, ml-1)
        Rectangle {
            visible: root._isSeparator
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            Layout.leftMargin: Theme.space1    // after:ml-1 (4)
            color: Theme.border
        }
    }

    // ==== Vertical layout (flex-col: icon above centered content) ====
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

    // ==== border variant: 1px bottom border (border-b border-border),
    // separated from the row by pb-2 (8). ====
    Rectangle {
        visible: root._isBorder
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: Theme.border
    }
}
