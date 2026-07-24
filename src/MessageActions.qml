import QtQuick
import QtQuick.Layouts

/*!
    \qmltype MessageActions
    \inqmlmodule Shadcn
    \inherits RowLayout
    \brief A hover-reveal group of icon buttons placed inside a message footer.

    MessageActions holds a row of icon buttons (copy / like / retry ...) that live
    in a \l MessageFooter. Its default children are the buttons themselves,
    typically \c {IconButton { size: IconButton.Small; variant: IconButton.Ghost }}.

    \l shown drives visibility: by default the group fades with the message hover
    state. When hidden it still occupies space (opacity only) so the layout does not
    jump.

    \sa MessageFooter, MessageContent
*/
RowLayout {
    id: root

    /*! When true the group is fully visible; when false it fades out (still occupies space). */
    property bool shown: true

    /*! \qmlproperty list<QtObject> MessageActions::actions
        Default children of the group, i.e. the action buttons. */
    default property alias actions: root.data

    spacing: 0
    opacity: shown ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: Theme.durFast } }
}
