import QtQuick
import QtQuick.Layouts

/*!
    \qmltype RadioGroup
    \inqmlmodule Shadcn
    \inherits ColumnLayout
    \brief A vertical, gap-3 container for \l RadioButton items.

    RadioGroup ports shadcn/ui's \c base-mira \c RadioGroup: a \c {grid gap-3}
    stack of options. Drop \l RadioButton children in directly; because they
    share a parent, Qt's \c autoExclusive makes them mutually exclusive with no
    extra wiring.

    Being a \l {QtQuick.Layouts::}{ColumnLayout}, children are laid out with
    \c Layout attached properties as usual. The reference group is full width
    (\c w-full); set \c {Layout.fillWidth: true} on the group to match.

    \qml
    RadioGroup {
        RadioButton { text: "Default" }
        RadioButton { text: "Comfortable"; checked: true }
        RadioButton { text: "Compact" }
    }
    \endqml

    \sa RadioButton
*/
ColumnLayout {
    spacing: Theme.space3   // gap-3
}
