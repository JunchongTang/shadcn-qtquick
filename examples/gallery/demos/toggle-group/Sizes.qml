import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    spacing: 16

    ToggleGroup {
        size: ToggleGroup.Sm
        variant: ToggleGroup.Outline
        ToggleGroupItem { value: "top"; text: qsTr("Top"); checked: true }
        ToggleGroupItem { value: "bottom"; text: qsTr("Bottom") }
        ToggleGroupItem { value: "left"; text: qsTr("Left") }
        ToggleGroupItem { value: "right"; text: qsTr("Right") }
    }
    ToggleGroup {
        variant: ToggleGroup.Outline
        ToggleGroupItem { value: "top"; text: qsTr("Top"); checked: true }
        ToggleGroupItem { value: "bottom"; text: qsTr("Bottom") }
        ToggleGroupItem { value: "left"; text: qsTr("Left") }
        ToggleGroupItem { value: "right"; text: qsTr("Right") }
    }
}
