import QtQuick
import QtQuick.Layouts
import Shadcn

// Show the three-part ItemHeader / ItemContent / ItemFooter layout (header and footer each span a full row, justified).
ColumnLayout {
    width: 420

    ShadItem {
        Layout.fillWidth: true
        variant: ShadItem.Outline

        // ItemTitle/ItemDescription carry Layout.fillWidth → naturally push the right-hand element to the row end (justify-between).
        ItemHeader {
            ItemTitle { text: qsTr("Starter Plan") }
            Badge { text: qsTr("Popular") }
        }
        ItemContent {
            ItemDescription {
                text: qsTr("Everything you need to launch a small project and grow.")
            }
        }
        ItemFooter {
            ItemDescription { text: qsTr("$9 / month"); maximumLineCount: 1 }
            Button { text: qsTr("Upgrade"); size: Button.Sm }
        }
    }
}
