import QtQuick
import Shadcn

// Trigger with icon: iconName is the leading Lucide icon (size-3.5 = 14), gap-1.5 from the text.
Tabs {
    TabButton { iconName: "app-window"; text: qsTr("Preview") }
    TabButton { iconName: "code"; text: qsTr("Code") }
}
