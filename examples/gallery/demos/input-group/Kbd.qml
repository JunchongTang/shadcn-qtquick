import QtQuick
import Shadcn
import LucideIcons

// 前缀搜索图标 + 后缀快捷键提示(Kbd)。
InputGroup {
    width: 320

    InputGroupInput { placeholderText: "Search..." }

    InputGroupAddon {
        LucideIcon { name: "search"; size: 14; color: Theme.mutedForeground }
    }
    InputGroupAddon {
        align: InputGroupAddon.InlineEnd
        Kbd { text: "⌘K" }
    }
}
