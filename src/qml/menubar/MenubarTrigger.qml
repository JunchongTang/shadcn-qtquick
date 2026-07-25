import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype MenubarTrigger
    \inqmlmodule Shadcn
    \inherits AbstractButton
    \brief A single trigger button in a \l Menubar (for example "File" or "Edit").

    MenubarTrigger renders shadcn's \c .cn-menubar-trigger: \c text-xs \c font-medium
    text with \c px-2 horizontal and small vertical padding, and a
    \c rounded-[calc(var(--radius-md)-2px)] (6px) background. The background is
    filled with \c muted while hovered or while its menu is open
    (\c hover:bg-muted / \c aria-expanded:bg-muted); otherwise it is transparent.
    No focus ring is drawn, matching the reference's \c outline-hidden.

    The unique type name avoids clashing with base control types such as
    \c MenuBarItem.

    \qml
    MenubarTrigger { text: "File" }
    \endqml
*/
C.AbstractButton {
    id: control

    /*!
        \qmlproperty bool MenubarTrigger::open
        Whether the associated menu is expanded (maps to \c aria-expanded). Drives
        the active/highlighted background together with hover.
    */
    property bool open: false

    // Highlighted while hovered or open (bg-muted; muted == accent in this theme).
    readonly property bool _active: control.hovered || control.open

    leftPadding: Theme.space2        // px-2
    rightPadding: Theme.space2
    topPadding: Theme.space1         // ~ py-[0.85] (3.4px rounded to 4)
    bottomPadding: Theme.space1
    font.pixelSize: Theme.textXs     // text-xs
    font.weight: Font.Medium         // font-medium
    hoverEnabled: true

    implicitWidth: label.implicitWidth + leftPadding + rightPadding
    implicitHeight: Math.round(Theme.textXs * Theme.lineRelaxed) + topPadding + bottomPadding

    contentItem: Text {
        id: label
        text: control.text
        font: control.font
        color: Theme.foreground
        horizontalAlignment: Text.AlignLeft     // flex items-center (left, vertically centred)
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        radius: Theme.radiusSm       // calc(radius-md - 2px) = 8 - 2 = 6
        color: control._active ? Theme.muted : Theme.alpha(Theme.muted, 0)
        Behavior on color { ColorAnimation { duration: Theme.durFast } }
    }
}
