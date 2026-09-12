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
    filled with \l highlight while hovered or while its menu is open
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

    /*!
        \qmlproperty color MenubarTrigger::highlight
        Fill drawn behind the label while the menu is open (\c aria-expanded:bg-muted).
        Defaults to \l Theme::muted.

        It is a hook because \c muted is an absolute neutral -- it has to stay legible
        on every surface, which makes it heavier than the overlay tints an application
        may use elsewhere for the same "this is the active one" meaning. A menu bar
        sitting among other toolbar buttons looks wrong when it is the one thing not
        on that scale.
    */
    property color highlight: Theme.muted

    /*!
        \qmlproperty color MenubarTrigger::hoverHighlight
        Fill drawn while the pointer is over the trigger but the menu is closed.
        Defaults to \l highlight, which is what the reference does -- it uses one
        colour for both. Set it apart when the palette distinguishes "pointing at"
        from "open".
    */
    property color hoverHighlight: control.highlight

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
        // Transparent is taken from the highlight itself so the ramp fades out rather
        // than crossing to some other hue on the way.
        color: control.open ? control.highlight
             : control.hovered ? control.hoverHighlight
             : Theme.alpha(control.highlight, 0)
        Behavior on color { enabled: Theme.animateColors; ColorAnimation { duration: Theme.durFast } }
    }
}
