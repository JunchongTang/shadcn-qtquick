import QtQuick
import QtQuick.Layouts

/*!
    \qmltype CardContent
    \inqmlmodule Shadcn
    \inherits ColumnLayout
    \brief Body region of a Card (cn-card-content).

    Horizontal insets are supplied by the enclosing Card. Content items stack
    vertically with a small gap.
*/
ColumnLayout {
    id: content

    /*! \qmlproperty bool CardContent::edgeToEdge
        When true the content spans to the card's left/right edges
        (official -mx-(--card-spacing)): negative margins cancel the Card's
        uniform horizontal inset. Inner items may re-add their own px. */
    property bool edgeToEdge: false

    // Card's uniform inset equals its content column's anchors.margins
    // (== cardSpacing); the parent of this item is that column.
    readonly property real _inset: (parent && parent.anchors) ? parent.anchors.margins : 0

    Layout.fillWidth: true
    Layout.leftMargin: edgeToEdge ? -_inset : 0
    Layout.rightMargin: edgeToEdge ? -_inset : 0
    spacing: Theme.space2
}
