import QtQuick

/*!
    \qmltype Kbd
    \inqmlmodule Shadcn
    \inherits Rectangle
    \brief A keyboard key cap, styled after shadcn's base-mira \c .cn-kbd.

    Kbd renders a single key hint such as \c Ctrl, \c ⌘K or an arrow glyph.
    It is a muted-filled cap: 20px tall (\c h-5), at least 20px wide
    (\c min-w-5) but growing to fit its label (\c w-fit) with 4px horizontal
    padding (\c px-1), 2px corners (\c rounded-xs) and 10px medium
    muted-foreground text (\c text-[0.625rem]).

    Group several caps with \l KbdGroup to render shortcuts like
    \c Ctrl \c Shift \c P.

    \qml
    Kbd { text: "Ctrl" }
    Kbd { text: "⌘K" }
    \endqml

    \note The reference component also accepts inline icons and a
    tooltip-content color variant; this port is text-only.
*/
Rectangle {
    id: control

    /*!
        \qmlproperty string Kbd::text
        The key label shown on the cap.
    */
    property alias text: label.text

    implicitHeight: 20                                   // h-5
    implicitWidth: Math.max(20, label.implicitWidth + 8) // min-w-5, px-1 (4px each side)
    radius: 2                                            // rounded-xs (0.125rem)
    color: Theme.muted

    Text {
        id: label
        anchors.centerIn: parent
        color: Theme.mutedForeground
        font.pixelSize: 10                              // text-[0.625rem]
        font.weight: Font.Medium
        font.family: Theme.fontSans
    }
}
