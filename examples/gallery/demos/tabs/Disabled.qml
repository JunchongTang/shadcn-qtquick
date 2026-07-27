import QtQuick
import Shadcn

// Disabled item: enabled=false -> dimmed (opacity 0.5) and not clickable/selectable.
Tabs {
    TabButton { text: qsTr("Home") }
    TabButton { text: qsTr("Disabled"); enabled: false }
}
