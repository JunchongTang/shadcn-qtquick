import QtQuick
import Shadcn

ToggleGroup {
    multiple: true
    orientation: ToggleGroup.Vertical
    spacing: 1

    ToggleGroupItem { value: "bold"; iconName: "bold"; checked: true }
    ToggleGroupItem { value: "italic"; iconName: "italic"; checked: true }
    ToggleGroupItem { value: "underline"; iconName: "underline" }
}
