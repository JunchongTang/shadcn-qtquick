import QtQuick
import QtQuick.Controls.Basic as C
import LucideIcons

/*!
    \qmltype AttachmentAction
    \inqmlmodule Shadcn
    \inherits Button
    \brief An icon action button inside an \l AttachmentActions row.

    AttachmentAction mirrors the web \c Button with \c size=icon-xs and
    \c variant=ghost: a 20x20 rounded-sm hit area that paints a muted background
    on hover and renders a 14px Lucide icon (\l iconName). Place these inside an
    \l AttachmentActions row for remove/retry/copy actions.

    \sa AttachmentActions, Attachment
*/
C.Button {
    id: control

    /*! \qmlproperty string AttachmentAction::iconName \brief Lucide icon name (kebab-case) to render at 14px. */
    property string iconName: ""
    /*! \qmlproperty string AttachmentAction::label \brief Accessibility label (mirrors aria-label). */
    property string label: ""

    /*! \qmlproperty string AttachmentAction::attachSlot \readonly \brief Slot marker used by \l Attachment routing. */
    readonly property string attachSlot: "attachment-action"

    implicitWidth: 20                  // icon-xs
    implicitHeight: 20
    padding: 0
    hoverEnabled: true
    opacity: enabled ? 1.0 : 0.5

    contentItem: Item {
        LucideIcon {
            anchors.centerIn: parent
            name: control.iconName
            size: 14
            color: control.hovered ? Theme.foreground : Theme.mutedForeground
        }
    }

    background: Rectangle {
        radius: Theme.radiusSm
        color: control.hovered ? Theme.muted : Theme.alpha(Theme.muted, 0)
        Behavior on color { ColorAnimation { duration: Theme.durFast } }

        // 1px focus ring (ring-1 ring-ring/30).
        Rectangle {
            anchors.fill: parent
            anchors.margins: -1
            radius: parent.radius + 1
            color: "transparent"
            border.width: 1
            border.color: Theme.alpha(Theme.ring, Theme.ringOpacity)
            visible: control.activeFocus
        }
    }
}
