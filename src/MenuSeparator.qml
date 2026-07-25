import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype MenuSeparator
    \inqmlmodule Shadcn
    \inherits QtQuick.Controls.MenuSeparator
    \brief A 1px divider between \l Menu groups.

    MenuSeparator is the QML port of shadcn/ui's \c DropdownMenuSeparator
    (base-mira): a 1px rule tinted \c {bg-border/50} with small vertical margins
    (\c my-1).

    The file name shadows the Controls base type, so the base is imported under
    the \c C alias and used as the root (\c C.MenuSeparator).
*/
C.MenuSeparator {
    id: control

    padding: 0
    topPadding: Theme.space1         // my-1
    bottomPadding: Theme.space1

    contentItem: Rectangle {
        implicitHeight: 1            // h-px
        color: Theme.alpha(Theme.border, 0.5)  // bg-border/50
    }
}
