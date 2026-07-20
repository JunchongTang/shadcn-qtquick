import QtQuick
import QtQuick.Layouts
import Shadcn

ColumnLayout {
    spacing: 16

    ToggleGroup {
        size: ToggleGroup.Sm
        variant: ToggleGroup.Outline
        ToggleGroupItem { value: "top"; text: "Top"; checked: true }
        ToggleGroupItem { value: "bottom"; text: "Bottom" }
        ToggleGroupItem { value: "left"; text: "Left" }
        ToggleGroupItem { value: "right"; text: "Right" }
    }
    ToggleGroup {
        variant: ToggleGroup.Outline
        ToggleGroupItem { value: "top"; text: "Top"; checked: true }
        ToggleGroupItem { value: "bottom"; text: "Bottom" }
        ToggleGroupItem { value: "left"; text: "Left" }
        ToggleGroupItem { value: "right"; text: "Right" }
    }
}
