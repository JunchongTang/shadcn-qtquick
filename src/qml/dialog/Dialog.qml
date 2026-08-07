import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import QtQuick.Controls.Basic as C
import QtQuick.Effects

/*!
    \qmltype Dialog
    \inqmlmodule Shadcn
    \inherits QtQuick.Controls.Dialog
    \brief A modal dialog with a header, body and an optional footer bar.
    \image dialog.png


    Dialog wraps the Qt Quick Controls \c Dialog with the shadcn (base-mira) look:
    a rounded popover surface over a blurred backdrop, a header holding the title,
    optional \l description and a close button, a body filled by the default
    content, and an optional footer bar separated by a divider and tinted with a
    muted background.

    The file name shadows the base type, so it is imported aliased (\c {as C}) and
    the root is \c C.Dialog.

    \qml
    Dialog {
        title: "Are you sure?"
        description: "This action cannot be undone."
        Text { text: "Body content goes here." }
        footerContent: RowLayout {
            Item { Layout.fillWidth: true }
            Button { text: "Cancel" }
            Button { text: "Confirm" }
        }
    }
    \endqml
*/
C.Dialog {
    id: control

    /*!
        \qmlproperty string Dialog::description
        Optional muted sub-title shown under the title in the header.
    */
    property string description: ""

    /*!
        \qmlproperty bool Dialog::showCloseButton
        Whether to show the top-right close button (the web XIcon). Defaults to \c true.
    */
    property bool showCloseButton: true

    /*!
        \qmlproperty bool Dialog::clipContent
        Whether the body clips its content. Defaults to \c true, which keeps overflowing
        content inside the content area instead of bleeding under the (semi-transparent)
        footer or past the rounded corners.

        Set to \c false when the body deliberately hosts something that must escape those
        bounds — a suggestion panel anchored to an input, for example, which is visually
        part of the input rather than of the body flow. Turning it off also raises the
        content above the footer in the stacking order: overflow that renders behind the
        footer would be pointless.

        \qml
        Dialog {
            clipContent: false          // the combo box below drops past the body
            MyComboLikeInput {}
        }
        \endqml
    */
    property bool clipContent: true

    /*!
        \qmlproperty list<QtObject> Dialog::footerContent
        Footer content slot, typically a single \c RowLayout of buttons. The
        component lays it out inside the padded, muted, divider-topped footer bar
        and stretches it to full width so trailing alignment works.
    */
    property alias footerContent: footerHost.data

    modal: true
    anchors.centerIn: parent
    implicitWidth: 360
    padding: Theme.space4                 // body padding p-4

    // Clip the body so overflowing content stays within the content area instead of
    // bleeding under the (semi-transparent) footer or past the rounded corners.
    // Opt out per-dialog via clipContent — see its docs for when that is the right call.
    //
    // Bindings rather than Component.onCompleted: contentItem is created by the base
    // type, and a one-shot assignment would not follow later changes to clipContent.
    Binding {
        target: control.contentItem
        property: "clip"
        value: control.clipContent
    }
    // Content above the footer when it is allowed to overflow — the footer is a sibling
    // of contentItem and paints after it, so without this the escaping content lands
    // behind the footer and the opt-out achieves nothing.
    Binding {
        target: control.contentItem
        property: "z"
        value: control.clipContent ? 0 : 1
    }

    // Modal backdrop: a blurred snapshot of the content behind plus a light scrim
    // (base-mira uses backdrop-blur rather than a plain black/80 dim).
    QQC.Overlay.modal: Item {
        id: backdrop

        // The application content to blur: the first window-content child that is
        // not the popup overlay (this backdrop's own parent). Sourcing the whole
        // content item would include the overlay and feed back into itself.
        readonly property Item content: {
            var ci = backdrop.Window.contentItem
            if (!ci)
                return null
            for (let i = 0; i < ci.children.length; ++i)
                if (ci.children[i] !== backdrop.parent)
                    return ci.children[i]
            return ci
        }

        ShaderEffectSource {
            id: backdropSource
            anchors.fill: parent
            sourceItem: backdrop.content
            live: true
            recursive: false
            hideSource: false
            visible: false            // consumed by the MultiEffect below
        }
        MultiEffect {
            anchors.fill: parent
            source: backdropSource
            blurEnabled: true
            blur: 1.0
            blurMax: 40
            autoPaddingEnabled: false
        }
        Rectangle { anchors.fill: parent; color: Theme.alpha("#000000", 0.25) }  // subtle scrim over blur
    }

    // Content surface: popover base + ring-1 ring-foreground/10 + rounded-xl + shadow.
    background: Rectangle {
        color: Theme.popover
        radius: Theme.radiusXl
        border.width: Theme.overlayRingWidth
        border.color: Theme.overlayRing
        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: true
            shadowEnabled: true
            shadowColor: Theme.shadowColor
            shadowBlur: Theme.shadowBlur
            shadowVerticalOffset: Theme.shadowOffset
        }
    }

    // Header: title + description + close button. The header sits outside the body
    // padding, so it carries its own space4 insets.
    header: Item {
        visible: control.title !== "" || control.description !== "" || control.showCloseButton
        implicitHeight: visible
            ? Math.max(headerCol.implicitHeight, control.showCloseButton ? 24 : 0) + Theme.space4
            : 0

        ColumnLayout {
            id: headerCol
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: Theme.space4
            anchors.rightMargin: control.showCloseButton ? Theme.space4 + 24 : Theme.space4
            anchors.topMargin: Theme.space4
            spacing: Theme.space1        // gap-1

            Text {
                visible: control.title !== ""
                text: control.title
                color: Theme.foreground
                font.pixelSize: Theme.textSm     // text-sm = 14
                font.weight: Font.Medium
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
            Text {
                visible: control.description !== ""
                text: control.description
                color: Theme.mutedForeground
                font.pixelSize: Theme.textXs
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
        }

        IconButton {
            id: closeBtn
            visible: control.showCloseButton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: Theme.space2
            anchors.rightMargin: Theme.space2
            iconName: "x"
            variant: IconButton.Ghost
            size: IconButton.Small
            onClicked: control.close()
        }
    }

    // Footer bar: a single muted fill that sits flush inside the dialog border so
    // the border reads as one piece; only a divider separates it from the body. The
    // fill is inset by the border width and its bottom corners match the interior
    // curve (radiusXl - border) so there is no visible seam. Content is padded (p-4)
    // and stretched to full width so a trailing RowLayout right-aligns its buttons.
    footer: Item {
        id: footer
        visible: footerHost.children.length > 0
        implicitHeight: footerHost.children.length > 0
                        ? footerHost.childrenRect.height + 2 * Theme.space4 : 0

        // Muted fill, inset inside the border, bottom corners hugging the interior.
        Rectangle {
            anchors.fill: parent
            anchors.leftMargin: Theme.overlayRingWidth
            anchors.rightMargin: Theme.overlayRingWidth
            anchors.bottomMargin: Theme.overlayRingWidth
            color: Theme.alpha(Theme.muted, 0.5)      // bg-muted/50
            topLeftRadius: 0
            topRightRadius: 0
            bottomLeftRadius: Theme.radiusXl - Theme.overlayRingWidth
            bottomRightRadius: Theme.radiusXl - Theme.overlayRingWidth
        }
        // Divider between body and footer (border-t only — no surrounding border).
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: Theme.overlayRingWidth
            anchors.rightMargin: Theme.overlayRingWidth
            height: 1
            color: Theme.border
        }

        Item {
            id: footerHost
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Theme.space4
            anchors.rightMargin: Theme.space4
            implicitHeight: childrenRect.height
        }
        Binding {
            target: footerHost.children.length > 0 ? footerHost.children[0] : null
            property: "width"
            value: footerHost.width
        }
    }

    // Enter/exit: zoom only (scale 0.95->1); the surface stays opaque to avoid an
    // opening flash of the dark scrim showing through. Mirrors zoom-in-95.
    enter: Transition {
        NumberAnimation { property: "scale"; from: 0.95; to: 1; duration: Theme.durBase; easing.type: Easing.OutCubic }
    }
    exit: Transition {
        NumberAnimation { property: "scale"; from: 1; to: 0.95; duration: Theme.durFast; easing.type: Easing.InCubic }
    }
}
