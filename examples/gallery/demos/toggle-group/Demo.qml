import QtQuick
import Shadcn

ToggleGroup {
    variant: ToggleGroup.Outline
    multiple: true

    ToggleGroupItem { value: "bold"; iconName: "bold" }
    ToggleGroupItem { value: "italic"; iconName: "italic" }
    ToggleGroupItem { value: "strikethrough"; iconName: "underline" }
}
