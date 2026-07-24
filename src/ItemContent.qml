import QtQuick
import QtQuick.Layouts

/*!
    \qmltype ItemContent
    \inqmlmodule Shadcn
    \inherits ColumnLayout
    \brief Vertical content column of a \l ShadItem holding \l ItemTitle and
    \l ItemDescription.

    Stretches to fill the main row (flex-1) by default. The parent \l ShadItem
    sets \l contentFill to false on the second and later content columns
    (flex-none). Inner spacing is gap-1, tightened to gap-0.5 at size xs.

    \qmlproperty int ItemContent::hostSize
    Injected by the parent \l ShadItem (0 default / 1 sm / 2 xs); drives the
    inner spacing.

    \qmlproperty bool ItemContent::contentFill
    Whether this column stretches to fill the main row. The parent sets it to
    false for every content column after the first.

    \qmlproperty bool ItemContent::hasDescription
    True when a child \l ItemDescription is present; read by the parent to
    top-align sibling media.
*/
ColumnLayout {
    id: content

    readonly property string itemSlot: "item-content"
    property int hostSize: 0            // injected by the parent ShadItem (0/1/2)
    property bool contentFill: true     // flex-1; the second content is set false
    property bool hasDescription: false

    Layout.fillWidth: contentFill
    Layout.alignment: Qt.AlignVCenter
    spacing: hostSize === 2 ? 2 : 4     // gap-0.5 / gap-1

    Component.onCompleted: {
        for (var i = 0; i < children.length; i++) {
            var c = children[i]
            if (c && c.itemSlot === "item-description") {
                hasDescription = true
                break
            }
        }
    }
}
