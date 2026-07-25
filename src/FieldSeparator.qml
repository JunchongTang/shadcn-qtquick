import QtQuick
import QtQuick.Layouts

/*!
    \qmltype FieldSeparator
    \inqmlmodule Shadcn
    \inherits Item
    \brief A section divider inside a \l FieldGroup (relative, h-5, -my-2).

    Draws a single centred horizontal rule. When \l text is set, a
    background-coloured chip is overlaid at the centre to give the "text breaks
    the line" effect (bg-background, px-2, muted-foreground, text-xs).
*/
Item {
    id: sep

    /*!
        \qmlproperty string FieldSeparator::text
        Optional label shown at the centre of the divider. Empty means a plain rule.
    */
    property string text: ""

    Layout.fillWidth: true
    implicitHeight: 20                // h-5
    Layout.topMargin: -Theme.space2   // -my-2
    Layout.bottomMargin: -Theme.space2

    // Full-width rule at the vertical centre (top-1/2).
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 1
        color: Theme.border
    }

    // Centred chip: paints over the rule with the background colour so the text
    // appears to break the line.
    Rectangle {
        anchors.centerIn: parent
        visible: sep.text !== ""
        width: chip.implicitWidth + Theme.space2 * 2   // px-2
        height: parent.height
        color: Theme.background

        Text {
            id: chip
            anchors.centerIn: parent
            text: sep.text
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
        }
    }
}
