import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import QtQuick.Controls.Basic as C
import QtQuick.Effects
import LucideIcons

/*!
    \qmltype AlertDialog
    \inqmlmodule Shadcn
    \inherits Dialog
    \brief An interrupting confirmation dialog styled after shadcn/ui base-mira.
    \image alert-dialog.png


    AlertDialog is a modal, centered confirmation prompt built on the Qt Quick
    Controls \c Dialog. Unlike \l Dialog it has no top-right close button and no
    muted footer bar: the header (optional \l mediaIconName, \c title and
    \l description) and the footer (a \c Cancel outline button plus an action
    button) are laid out together inside the padded content surface, matching the
    base-mira \c .cn-alert-dialog-* rules.

    The action button emits the inherited \c {Dialog::accepted()} signal and then
    closes; the cancel button just closes. Use \l size to switch between the
    wider left-aligned \c Default layout and the narrow centered \c Sm layout.

    The file name shadows the base type, so it is imported aliased (\c {as C})
    and the root is \c C.Dialog.

    \qml
    Button {
        text: "Delete"
        onClicked: dialog.open()
        AlertDialog {
            id: dialog
            size: AlertDialog.Sm
            mediaIconName: "trash-2"
            mediaDestructive: true
            title: "Delete chat?"
            description: "This will permanently delete this chat conversation."
            actionText: "Delete"
            actionVariant: Button.Destructive
            onAccepted: doDelete()
        }
    }
    \endqml

    \sa Dialog, Button
*/
C.Dialog {
    id: control

    /*!
        \qmlproperty enumeration AlertDialog::size
        The content layout preset.

        \value AlertDialog.Default Wider surface (max-w-sm, 384) with a
               left-aligned header and a trailing-aligned footer.
        \value AlertDialog.Sm Narrow surface (max-w-64, 256) with a centered
               header and a two-column (equal width) footer.

        The default is \c AlertDialog.Default.
    */
    // Default is 0 so it also matches Button.Default (0); keeping shared enum
    // members at value 0 avoids the enum-flattening resolution pitfall (#028).
    enum Size { Default, Sm }

    // title is inherited from the base Dialog and used as-is. The rest are new.

    /*!
        \qmlproperty string AlertDialog::description
        Optional muted sub-title shown under the title (text-xs, relaxed line
        height). Hidden when empty.
    */
    property string description: ""

    /*!
        \qmlproperty string AlertDialog::mediaIconName
        Optional Lucide icon name for the top/leading media badge. When empty no
        media badge is shown.
    */
    property string mediaIconName: ""

    /*!
        \qmlproperty bool AlertDialog::mediaDestructive
        Whether the media badge uses the destructive palette
        (bg-destructive/10 fill + destructive icon) instead of the muted default.
    */
    property bool mediaDestructive: false

    /*!
        \qmlproperty string AlertDialog::cancelText
        Label of the cancel (outline) button. Clicking it closes the dialog.
    */
    property string cancelText: qsTr("Cancel")

    /*!
        \qmlproperty string AlertDialog::actionText
        Label of the confirming action button.
    */
    property string actionText: qsTr("Continue")

    /*!
        \qmlproperty int AlertDialog::actionVariant
        Variant of the action button, taken from the \l Button variant enum
        (for example \c Button.Destructive). Defaults to \c Button.Default.
    */
    property int actionVariant: Button.Default

    // Backing property for the size preset documented on the Size enum above.
    property int size: AlertDialog.Default

    // Note: the action button emits the inherited Dialog::accepted() signal.
    // It is not redeclared here (redeclaring an inherited signal triggers a
    // qt.qml.invalidOverride "Duplicate signal name" warning).

    readonly property bool _sm: size === AlertDialog.Sm
    readonly property bool _hasMedia: mediaIconName !== ""
    // sm is centered; default is left-aligned (mirrors the base-mira
    // sm:group-data-[size=default] place-items-start rule).
    readonly property bool _centered: _sm

    modal: true
    anchors.centerIn: parent
    padding: Theme.space4                      // content p-4
    // Suppress the base Dialog's auto title/button bars (created because title is
    // non-empty); they would carry a square default fill and cover the corners.
    // The header and footer are folded into contentItem instead.
    header: null
    footer: null
    // Content grid width: default uses max-w-sm (384), sm uses max-w-64 (256).
    implicitWidth: _sm ? 256 : 384

    // Modal scrim: black/80 (mirrors cn-alert-dialog-overlay bg-black/80).
    QQC.Overlay.modal: Rectangle { color: Theme.alpha("#000000", 0.8) }

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

    // Header + footer are folded into contentItem under a shared p-4 with gap-3.
    contentItem: ColumnLayout {
        spacing: Theme.space3     // content gap-3

        // ==== Header: default + media (side by side, media spans 2 rows) ====
        RowLayout {
            visible: !control._centered && control._hasMedia
            Layout.fillWidth: true
            spacing: Theme.space4      // gap-x-4

            Rectangle {                // media (size-8, rounded-md)
                Layout.alignment: Qt.AlignTop
                implicitWidth: 32
                implicitHeight: 32
                radius: Theme.radiusMd
                color: control.mediaDestructive ? Theme.alpha(Theme.destructive, 0.1) : Theme.muted
                LucideIcon {
                    anchors.centerIn: parent
                    name: control.mediaIconName
                    size: 16           // svg size-4
                    color: control.mediaDestructive ? Theme.destructive : Theme.foreground
                }
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.space1  // gap-1
                Text {
                    Layout.fillWidth: true
                    text: control.title
                    color: Theme.foreground
                    font.pixelSize: Theme.textSm   // text-sm = 14
                    font.weight: Font.Medium
                    wrapMode: Text.Wrap
                }
                Text {
                    visible: control.description !== ""
                    Layout.fillWidth: true
                    text: control.description
                    color: Theme.mutedForeground
                    font.pixelSize: Theme.textXs    // text-xs = 12
                    lineHeight: Theme.lineRelaxed
                    lineHeightMode: Text.ProportionalHeight
                    wrapMode: Text.Wrap
                }
            }
        }

        // ==== Header: stacked (sm centered, or default without media) ====
        ColumnLayout {
            visible: control._centered || !control._hasMedia
            Layout.fillWidth: true
            spacing: Theme.space1      // gap-1

            Rectangle {                // media (centered layout only, mb-2)
                visible: control._hasMedia
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: Theme.space1   // + gap-1 = mb-2 (8)
                implicitWidth: 32
                implicitHeight: 32
                radius: Theme.radiusMd
                color: control.mediaDestructive ? Theme.alpha(Theme.destructive, 0.1) : Theme.muted
                LucideIcon {
                    anchors.centerIn: parent
                    name: control.mediaIconName
                    size: 16
                    color: control.mediaDestructive ? Theme.destructive : Theme.foreground
                }
            }
            Text {
                Layout.fillWidth: true
                text: control.title
                color: Theme.foreground
                font.pixelSize: Theme.textSm
                font.weight: Font.Medium
                wrapMode: Text.Wrap
                horizontalAlignment: control._centered ? Text.AlignHCenter : Text.AlignLeft
            }
            Text {
                visible: control.description !== ""
                Layout.fillWidth: true
                text: control.description
                color: Theme.mutedForeground
                font.pixelSize: Theme.textXs
                lineHeight: Theme.lineRelaxed
                lineHeightMode: Text.ProportionalHeight
                wrapMode: Text.Wrap
                horizontalAlignment: control._centered ? Text.AlignHCenter : Text.AlignLeft
            }
        }

        // ==== Footer: Cancel (outline) + Action. default right-aligned; sm two equal columns ====
        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.space2            // gap-2
            Item { visible: !control._sm; Layout.fillWidth: true }
            Button {
                objectName: "alertDialogCancel"
                text: control.cancelText
                variant: Button.Outline
                Layout.fillWidth: control._sm
                onClicked: control.close()
            }
            Button {
                objectName: "alertDialogAction"
                text: control.actionText
                variant: control.actionVariant
                Layout.fillWidth: control._sm
                onClicked: { control.accepted(); control.close() }
            }
        }
    }

    // Enter/exit: zoom only (scale 0.95->1); the surface stays opaque to avoid an
    // opening flash of the dark scrim showing through while it fades. The modal
    // scrim's own fade provides the appearance cue. Mirrors zoom-in-95.
    enter: Transition {
        NumberAnimation { property: "scale"; from: 0.95; to: 1; duration: Theme.durBase; easing.type: Easing.OutCubic }
    }
    exit: Transition {
        NumberAnimation { property: "scale"; from: 1; to: 0.95; duration: Theme.durFast; easing.type: Easing.InCubic }
    }
}
