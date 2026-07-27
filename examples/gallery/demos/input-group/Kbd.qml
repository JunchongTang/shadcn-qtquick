import QtQuick
import Shadcn
import LucideIcons

// Leading search icon + trailing shortcut hint (Kbd).
InputGroup {
    width: 320

    InputGroupInput { placeholderText: qsTr("Search...") }

    InputGroupAddon {
        LucideIcon { name: "search"; size: 14; color: Theme.mutedForeground }
    }
    InputGroupAddon {
        align: InputGroupAddon.InlineEnd
        Kbd { text: qsTr("⌘K") }
    }
}
