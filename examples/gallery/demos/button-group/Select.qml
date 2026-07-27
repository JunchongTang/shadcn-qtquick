import QtQuick
import Shadcn

// Official button-group-select: Select + Input form one group, then grouped with the "send" icon button (gap-2).
Row {
    spacing: 8

    ButtonGroup {
        Select {
            width: 64
            model: ["$", "€", "£"]
            currentIndex: 0
            font.family: Theme.fontMono
        }
        Input {
            width: 140
            placeholderText: "10.00"
        }
    }
    ButtonGroup {
        Button { variant: Button.Outline; size: Button.Icon; iconName: "arrow-right" }
    }
}
