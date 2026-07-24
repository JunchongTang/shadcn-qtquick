import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype InputGroupInput
    \inqmlmodule Shadcn
    \inherits TextField
    \brief A borderless single-line input for use inside an InputGroup
    (\c .cn-input-group-input), styled after shadcn/ui base-mira.

    InputGroupInput strips the standalone Input's border, background and focus
    ring (\c rounded-none \c border-0 \c bg-transparent \c ring-0); the shared
    rounded border and single focus ring come from the enclosing \l InputGroup.
    The \l _igControl / \l _igType flags let InputGroup identify and place it, and
    its padding is overridden by the group according to which addons are present.

    \sa InputGroup, InputGroupTextarea
*/
C.TextField {
    id: control

    /*! \qmlproperty bool InputGroupInput::_igControl \brief Marks this as an InputGroup control. \internal */
    readonly property bool _igControl: true
    /*! \qmlproperty string InputGroupInput::_igType \brief Control kind ("input") used for auto orientation. \internal */
    readonly property string _igType: "input"

    implicitHeight: 28                 // h-7 (matches the group height)
    leftPadding: Theme.space2          // px-2 (group overrides to pl-1.5 when an addon exists)
    rightPadding: Theme.space2
    topPadding: 0
    bottomPadding: 0
    font.pixelSize: Theme.textXs
    color: Theme.foreground
    placeholderTextColor: Theme.mutedForeground
    selectionColor: Theme.alpha(Theme.primary, 0.35)
    selectedTextColor: Theme.foreground
    verticalAlignment: TextInput.AlignVCenter

    // Transparent, borderless, no ring: the visual border/ring is drawn by InputGroup.
    background: Item {}
}
