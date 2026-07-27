import QtQuick
import QtQuick.Layouts
import Shadcn

// Official spinner-demo (with text): Spinner as media icon + title + trailing amount, inside a muted list item.
// Note: official uses Item / ItemMedia / ItemContent components (not primitives of this library); approximated here with a muted rounded container.
Rectangle {
    id: item
    implicitWidth: 320                         // max-w-xs
    implicitHeight: row.implicitHeight + 2 * Theme.space4
    radius: 16                                 // [--radius:1rem]
    color: Theme.muted                         // Item variant="muted"

    RowLayout {
        id: row
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: Theme.space4
        anchors.rightMargin: Theme.space4
        spacing: Theme.space3

        Spinner { size: 16 }                   // ItemMedia
        Text {
            Layout.fillWidth: true
            text: qsTr("Processing payment...")
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.family: Theme.fontSans
            elide: Text.ElideRight             // line-clamp-1
        }
        Text {
            text: "$100.00"                    // tabular-nums
            color: Theme.foreground
            font.pixelSize: Theme.textSm
            font.family: Theme.fontMono
        }
    }
}
