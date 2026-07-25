import QtQuick
import Shadcn

ToggleGroup {
    variant: ToggleGroup.Outline

    ToggleGroupItem { value: "all"; text: qsTr("All"); checked: true }
    ToggleGroupItem { value: "missed"; text: qsTr("Missed") }
}
