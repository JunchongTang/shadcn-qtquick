import QtQuick
import Shadcn
import LucideIcons

// 前缀搜索图标 + 后缀结果计数(对标官方 hero:input-group-demo)。
InputGroup {
    width: 320

    InputGroupInput { placeholderText: "Search..." }

    InputGroupAddon {
        LucideIcon { name: "search"; size: 14; color: Theme.mutedForeground }
    }
    InputGroupAddon {
        align: InputGroupAddon.InlineEnd
        InputGroupText { text: "12 results" }
    }
}
