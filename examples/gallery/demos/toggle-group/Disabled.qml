import QtQuick
import Shadcn

ToggleGroup {
    enabled: false
    multiple: true

    ToggleGroupItem { value: "bold"; iconName: "bold" }
    ToggleGroupItem { value: "italic"; iconName: "italic" }
    ToggleGroupItem { value: "strikethrough"; iconName: "underline" }
}
