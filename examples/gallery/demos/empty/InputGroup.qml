import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// 官方 empty-input-group:EmptyContent 内放输入组(搜索框 + 前置图标 + 快捷键)。
Empty {
    EmptyHeader {
        EmptyTitle { text: "404 - Not Found" }
        EmptyDescription {
            text: "The page you're looking for doesn't exist. Try searching for what you need below."
        }
    }

    EmptyContent {
        InputGroup {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 260    // sm:w-3/4 近似

            InputGroupInput { placeholderText: "Try searching for pages..." }
            InputGroupAddon {
                LucideIcon { name: "search"; size: 14; color: Theme.mutedForeground }
            }
            InputGroupAddon {
                align: InputGroupAddon.InlineEnd
                Kbd { text: "/" }
            }
        }

        EmptyDescription { text: "Need help? Contact support" }
    }
}
