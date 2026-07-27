import QtQuick
import Shadcn

// Line variant: no muted background; the active item is marked with a bottom 2px foreground underline.
Tabs {
    variant: Tabs.Line
    TabButton { text: qsTr("Overview") }
    TabButton { text: qsTr("Analytics") }
    TabButton { text: qsTr("Reports") }
}
