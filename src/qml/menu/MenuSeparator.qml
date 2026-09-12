import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype MenuSeparator
    \inqmlmodule Shadcn
    \inherits QtQuick.Controls.MenuSeparator
    \brief A 1px divider between \l Menu groups.

    MenuSeparator is the QML port of shadcn/ui's \c DropdownMenuSeparator
    (base-mira): a 1px rule filled \c bg-border with small vertical margins
    (\c my-1).

    The file name shadows the Controls base type, so the base is imported under
    the \c C alias and used as the root (\c C.MenuSeparator).
*/
C.MenuSeparator {
    id: control

    padding: 0
    topPadding: Theme.space1         // my-1
    bottomPadding: Theme.space1

    // Same reason as MenuItem: a hidden separator would otherwise leave its my-1
    // padding behind as a gap. Separators are conditional whenever the group they
    // divide is (e.g. the platform-specific "Quit" block).
    height: visible ? implicitHeight : 0

    contentItem: Rectangle {
        implicitHeight: 1            // h-px
        color: Theme.border                     // bg-border
    }
}
