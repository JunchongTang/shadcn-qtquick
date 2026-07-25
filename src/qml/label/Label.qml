import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype Label
    \inqmlmodule Shadcn
    \inherits QtQuick.Controls.Label
    \brief A form label, styled after shadcn's base-mira label.
    \image label.png


    Label renders shadcn's \c .cn-label: 12px medium text (\c text-xs,
    \c font-medium) in the \l {Theme::foreground}{foreground} color, vertically
    centered (\c items-center). When \c enabled is false the whole label dims to
    50% opacity, mirroring the \c group-data-[disabled]:opacity-50 /
    \c peer-disabled:opacity-50 rules that fade a label when its field or paired
    control is disabled.

    \qml
    Label { text: "Username" }
    Label { text: "Disabled"; enabled: false }
    \endqml
*/

// The file name Label collides with the base type QtQuick.Controls.Basic.Label,
// so the base is imported aliased (as C) and the root is C.Label to avoid a
// self-referential type-resolution loop.
C.Label {
    id: control

    color: Theme.foreground
    font.pixelSize: Theme.textXs        // text-xs
    font.weight: Font.Medium            // font-medium
    // Dim when disabled (group-data-[disabled]/peer-disabled opacity-50).
    opacity: enabled ? 1.0 : 0.5
    verticalAlignment: Text.AlignVCenter // items-center
}
