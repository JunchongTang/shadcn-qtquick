import QtQuick
import QtQuick.Layouts
import Shadcn

// Align Item With Trigger: switch toggles alignItemWithTrigger.
// true → popup shifts up so the current item (Banana) covers the trigger; false → opens flush below the trigger.
// Note: simplified implementation, no scroll/viewport clamping; suits cases with few fully-visible items.
ColumnLayout {
    width: 260
    spacing: 12

    RowLayout {
        Layout.fillWidth: true
        spacing: 12
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            Label { text: qsTr("Align Item") }
            Text {
                text: qsTr("Toggle to align the item with the trigger.")
                color: Theme.mutedForeground
                font.pixelSize: Theme.textXs
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
        }
        Switch {
            id: alignSwitch
            checked: true
        }
    }

    Select {
        Layout.fillWidth: true
        alignItemWithTrigger: alignSwitch.checked
        currentIndex: 1     // Banana
        model: [qsTr("Apple"), qsTr("Banana"), qsTr("Blueberry"), qsTr("Grapes"), qsTr("Pineapple")]
    }
}
