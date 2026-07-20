import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// 前缀/后缀图标的多种组合。
ColumnLayout {
    width: 320
    spacing: 20

    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: "Search..." }
        InputGroupAddon {
            LucideIcon { name: "search"; size: 14; color: Theme.mutedForeground }
        }
    }

    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: "Enter your email" }
        InputGroupAddon {
            LucideIcon { name: "mail"; size: 14; color: Theme.mutedForeground }
        }
    }

    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: "Card number" }
        InputGroupAddon {
            LucideIcon { name: "credit-card"; size: 14; color: Theme.mutedForeground }
        }
        InputGroupAddon {
            align: InputGroupAddon.InlineEnd
            LucideIcon { name: "check"; size: 14; color: Theme.mutedForeground }
        }
    }

    InputGroup {
        Layout.fillWidth: true
        InputGroupInput { placeholderText: "Card number" }
        InputGroupAddon {
            align: InputGroupAddon.InlineEnd
            LucideIcon { name: "star"; size: 14; color: Theme.mutedForeground }
            LucideIcon { name: "info"; size: 14; color: Theme.mutedForeground }
        }
    }
}
