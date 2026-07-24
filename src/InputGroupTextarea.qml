import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype InputGroupTextarea
    \inqmlmodule Shadcn
    \inherits TextArea
    \brief A borderless multi-line input for use inside an InputGroup
    (\c .cn-input-group-textarea), styled after shadcn/ui base-mira.

    Like \l InputGroupInput it drops its own border, background and ring and takes
    \c py-2 vertical padding; the shared border and single focus ring come from
    the enclosing \l InputGroup. Its \l _igType of \c "textarea" makes the group
    switch to vertical layout automatically.

    \sa InputGroup, InputGroupInput
*/
C.TextArea {
    id: control

    /*! \qmlproperty bool InputGroupTextarea::_igControl \brief Marks this as an InputGroup control. \internal */
    readonly property bool _igControl: true
    /*! \qmlproperty string InputGroupTextarea::_igType \brief Control kind ("textarea"); switches the group to vertical. \internal */
    readonly property string _igType: "textarea"

    implicitHeight: 64                 // min-h-16
    leftPadding: Theme.space2          // px-2 (group overrides when an addon exists)
    rightPadding: Theme.space2
    topPadding: Theme.space2           // py-2
    bottomPadding: Theme.space2
    font.pixelSize: Theme.textXs
    color: Theme.foreground
    placeholderTextColor: Theme.mutedForeground
    selectionColor: Theme.alpha(Theme.primary, 0.35)
    selectedTextColor: Theme.foreground
    wrapMode: TextEdit.Wrap

    background: Item {}
}
