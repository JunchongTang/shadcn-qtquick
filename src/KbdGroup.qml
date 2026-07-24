import QtQuick
import QtQuick.Layouts

/*!
    \qmltype KbdGroup
    \inqmlmodule Shadcn
    \inherits RowLayout
    \brief A horizontal group of \l Kbd caps, styled after shadcn's \c .cn-kbd-group.

    KbdGroup lays its children out in a row, vertically centred (the RowLayout
    default), with a 4px gap between them (\c gap-1). Use it to compose a
    multi-key shortcut from individual \l Kbd caps and separators.

    \qml
    KbdGroup {
        Kbd { text: "Ctrl" }
        Kbd { text: "Shift" }
        Kbd { text: "P" }
    }
    \endqml
*/
RowLayout {
    spacing: Theme.space1   // gap-1
}
