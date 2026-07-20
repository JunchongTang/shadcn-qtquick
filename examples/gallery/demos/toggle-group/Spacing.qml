import QtQuick
import Shadcn

ToggleGroup {
    size: ToggleGroup.Sm
    variant: ToggleGroup.Outline
    spacing: 2

    ToggleGroupItem { value: "top"; text: "Top"; checked: true }
    ToggleGroupItem { value: "bottom"; text: "Bottom" }
    ToggleGroupItem { value: "left"; text: "Left" }
    ToggleGroupItem { value: "right"; text: "Right" }
}
