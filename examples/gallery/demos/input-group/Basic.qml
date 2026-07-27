import QtQuick
import Shadcn
import LucideIcons

// Leading search icon + trailing result count (matches official hero:input-group-demo).
InputGroup {
    width: 320

    InputGroupInput { placeholderText: qsTr("Search...") }

    InputGroupAddon {
        LucideIcon { name: "search"; size: 14; color: Theme.mutedForeground }
    }
    InputGroupAddon {
        align: InputGroupAddon.InlineEnd
        InputGroupText { text: qsTr("12 results") }
    }
}
