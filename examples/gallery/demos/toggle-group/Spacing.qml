import QtQuick
import Shadcn

ToggleGroup {
    size: ToggleGroup.Sm
    variant: ToggleGroup.Outline
    spacing: 2

    ToggleGroupItem { value: "top"; text: qsTr("Top"); checked: true }
    ToggleGroupItem { value: "bottom"; text: qsTr("Bottom") }
    ToggleGroupItem { value: "left"; text: qsTr("Left") }
    ToggleGroupItem { value: "right"; text: qsTr("Right") }
}
