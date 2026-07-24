import QtQuick
import QtQuick.Layouts

/*!
    \qmltype BubbleGroup
    \inqmlmodule Shadcn
    \inherits ColumnLayout
    \brief Groups a run of same-author \l Bubble items with tighter spacing.

    BubbleGroup is the QML port of shadcn's \c .cn-bubble-group
    (\c {flex flex-col gap-2}). It only tightens the vertical spacing between a run
    of same-author bubbles; base-mira does \e not merge corner radii, so each
    bubble stays \c rounded-lg. Set \l {Bubble::align}{align} on each child
    \l Bubble (the group does not carry it).

    \qml
    BubbleGroup {
        Bubble { align: Bubble.End; BubbleContent { text: "A" } }
        Bubble { align: Bubble.End; BubbleContent { text: "B" } }
    }
    \endqml

    \sa Bubble
*/
ColumnLayout {
    id: group
    spacing: Theme.space2   // gap-2

    /*!
        \qmlproperty bool BubbleGroup::isBubbleGroup
        \readonly
        Marker read by \l BubbleContent so it can walk the max-width base up to the
        real conversation column. The group is a fillWidth layout whose width is
        derived from its children, so reading it directly would form a binding loop.
    */
    readonly property bool isBubbleGroup: true

    // The group fills the outer column width; each child Bubble self-aligns.
    Layout.fillWidth: true
}
