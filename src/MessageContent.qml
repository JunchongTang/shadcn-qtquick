import QtQuick
import QtQuick.Layouts
import LucideIcons

/*!
    \qmltype MessageContent
    \inqmlmodule Shadcn
    \inherits Item
    \brief The vertical content column of a message: header, bubble, attachments and footer.

    MessageContent is the QML port of shadcn's base-mira \c .cn-message-content
    (\c {flex w-full min-w-0 flex-col gap-2}). It stacks, top to bottom: an optional
    \l MessageHeader, an optional image attachment, the bubble (driven by \l text
    and \l variant), an optional file attachment, and a \l MessageFooter carrying
    the status text and hover \l actions.

    It is self-contained: the bubble is drawn here directly rather than via \l Bubble.
    Common attachments (image cover, file card) are built in through the
    \l imageSource / \l fileName convenience properties. The rounded image cover uses
    \l RoundedImage so the corners are truly clipped (a plain \c clip would leave
    square corners).

    The root is an \l Item wrapping a named \c ColumnLayout: the structural parts live
    in that column, while a consumer's default children (the action buttons) are routed
    via the \l actions alias into the footer's \l MessageActions.

    \l align follows the ancestor \l Message automatically (via the \c isMessageRow
    parent-chain probe); set it explicitly when used stand-alone.

    Honest omissions (base tier): rich text / markdown, code blocks, bubble tails,
    reactions, the full attachment variant/action set, and BubbleGroup's fine-grained
    corner rounding.

    \sa Message, MessageHeader, MessageFooter, MessageActions, RoundedImage
*/
Item {
    id: root

    /*!
        \qmlproperty enumeration MessageContent::variant
        Bubble visual style (mirrors \c cn-bubble-variant-*).
        \value MessageContent.Default Primary background, primary-foreground text.
        \value MessageContent.Muted Muted background, default foreground.
        \value MessageContent.Outline Background fill with a 1px border.
        \value MessageContent.Destructive Translucent destructive background/foreground.
        \value MessageContent.Ghost No background/border/padding.
        \value MessageContent.Secondary Secondary background/foreground.
    */
    enum Variant { Default, Muted, Outline, Destructive, Ghost, Secondary }

    /*!
        In-column alignment side; inherited from the ancestor \l Message when present,
        otherwise \c Start (0). Values match \l {Message::align}: 0=Start (leading),
        1=End (trailing).
    */
    property int align: {
        var p = parent
        while (p) {
            if (p.isMessageRow === true)
                return p.align
            p = p.parent
        }
        return 0
    }

    /*! Sender / meta line shown above the bubble. \sa MessageHeader */
    property string header: ""
    /*! The bubble body text. */
    property string text: ""
    /*! The bubble variant. \sa MessageContent::variant */
    property int variant: MessageContent.Muted
    /*! When true, show the typing dot animation instead of \l text. */
    property bool typing: false
    /*! Footer status text (e.g. "Delivered"). \sa MessageFooter */
    property string footer: ""
    /*! When true the footer status text uses the destructive color. */
    property bool footerDestructive: false
    /*! When true the hover \l actions are only visible while the message is hovered. */
    property bool actionsOnHover: true
    /*! Image attachment shown above the bubble (empty = hidden). */
    property url imageSource
    /*! File attachment title shown below the bubble (empty = hidden). */
    property string fileName: ""
    /*! File attachment secondary line (size / meta). */
    property string fileMeta: ""

    /*! \qmlproperty list<QtObject> MessageContent::actions
        Default children become hover action buttons, routed into the footer's
        \l MessageActions. */
    default property alias actions: actionsInner.actions

    /*! \internal True when aligned to the trailing edge (align == End). */
    readonly property bool _end: align === 1
    /*! \internal Layout alignment flag for in-column children. */
    readonly property int _side: _end ? Qt.AlignRight : Qt.AlignLeft
    /*! \internal True for the ghost variant (no padding/background). */
    readonly property bool _ghost: variant === MessageContent.Ghost
    readonly property int _padH: _ghost ? 0 : Theme.space2_5   // px-2.5
    readonly property int _padV: _ghost ? 0 : Theme.space1_5   // py-1.5

    /*! \internal Bubble background color for the current \l variant. */
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
    /*! \internal Bubble text color for the current \l variant. */
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
            objectName: "messageHeader"
            text: root.header
            Layout.alignment: Qt.AlignLeft
        }

        // ==== Image attachment (above the bubble) ====
        Rectangle {
            id: imageAttachment
            objectName: "imageAttachment"
            visible: String(root.imageSource) !== ""
            Layout.alignment: root._side
            implicitWidth: Math.min(220, root.width * 0.8)
            implicitHeight: implicitWidth * 0.66
            radius: Theme.radiusLg
            color: Theme.muted
            // Clip to the rounded corners for real (plain clip would leave square corners).
            RoundedImage {
                anchors.fill: parent
                source: root.imageSource
                radius: imageAttachment.radius
            }
        }

        // ==== Bubble ====
        Rectangle {
            id: bubble
            objectName: "bubble"
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
                objectName: "bubbleText"
                visible: !root.typing
                x: root._padH
                y: root._padV
                // Natural width vs the 80% cap: single line when it fits, otherwise
                // wrap (height grows with the wrap).
                width: Math.min(implicitWidth, root.width * 0.8 - root._padH * 2)
                text: root.text
                color: root._bubbleFg
                font.pixelSize: Theme.textXs                  // text-xs
                lineHeight: Theme.lineRelaxed                 // /relaxed
                lineHeightMode: Text.ProportionalHeight
                wrapMode: Text.Wrap
                textFormat: Text.PlainText
            }

            // Typing three-dot animation (one of the base visual states); the dots blink out of phase.
            Row {
                id: typingRow
                objectName: "typingRow"
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

        // ==== File attachment (below the bubble) ====
        Rectangle {
            id: fileAttachment
            objectName: "fileAttachment"
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

        // ==== Footer (status text + hover actions) ====
        MessageFooter {
            id: footerRow
            objectName: "messageFooter"
            visible: root.footer !== "" || root.footerDestructive
                     || actionsInner.children.length > 0
            Layout.alignment: root._side
            text: root.footer
            destructive: root.footerDestructive

            MessageActions {
                id: actionsInner
                objectName: "messageActions"
                shown: !root.actionsOnHover || hov.hovered
            }
        }
    }
}
