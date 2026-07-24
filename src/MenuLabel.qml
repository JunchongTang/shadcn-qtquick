import QtQuick

/*!
    \qmltype MenuLabel
    \inqmlmodule Shadcn
    \inherits Item
    \brief A non-interactive muted heading inside a \l Menu.

    MenuLabel is the QML port of shadcn/ui's \c DropdownMenuLabel (base-mira): a
    small muted caption (\c {px-2 py-1.5 text-xs text-muted-foreground}) that
    titles a group of items. It is a plain \l Item rather than a MenuItem, so it
    is not focusable and keyboard navigation skips over it.

    \qmlproperty string MenuLabel::text
    The caption text.

    \qmlproperty bool MenuLabel::inset
    When \c true the text is indented to align with items that have a leading
    icon (\c {data-inset:pl-7.5}).
*/
Item {
    id: control

    property string text: ""
    property bool inset: false       // data-inset: pl-7.5

    implicitWidth: label.x + label.implicitWidth + Theme.space2
    implicitHeight: label.implicitHeight + Theme.space1_5 * 2   // py-1.5

    Text {
        id: label
        x: control.inset ? 30 : Theme.space2                    // pl-7.5 (30px) or px-2
        y: Theme.space1_5
        text: control.text
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
    }
}
