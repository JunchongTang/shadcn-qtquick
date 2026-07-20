import QtQuick
import Shadcn

ToggleGroup {
    variant: ToggleGroup.Outline

    ToggleGroupItem { value: "all"; text: "All"; checked: true }
    ToggleGroupItem { value: "missed"; text: "Missed" }
}
