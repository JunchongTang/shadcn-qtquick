import QtQuick
import Shadcn
import LucideIcons

// 官方 breadcrumb-dropdown:中间项为下拉触发(Components + chevron-down),圆点分隔。
Breadcrumb {
    BreadcrumbItem {
        BreadcrumbLink { text: "Home" }
    }
    BreadcrumbSeparator { iconName: "dot" }
    BreadcrumbItem {
        id: dropdownItem
        // 下拉触发:文本 + chevron 同属一个可点区域(对标单个 DropdownMenuTrigger),
        // 统一 hover 高亮、点任意处均弹出菜单。
        Row {
            id: trigger
            spacing: Theme.space1
            property bool hovered: triggerHover.hovered

            Text {
                text: "Components"
                color: trigger.hovered ? Theme.foreground : Theme.mutedForeground
                font.pixelSize: Theme.textXs
                font.family: Theme.fontSans
                verticalAlignment: Text.AlignVCenter
                Behavior on color { ColorAnimation { duration: Theme.durBase } }
            }
            LucideIcon {
                name: "chevron-down"
                size: 14
                color: trigger.hovered ? Theme.foreground : Theme.mutedForeground
                anchors.verticalCenter: parent.verticalCenter
                Behavior on color { ColorAnimation { duration: Theme.durBase } }
            }

            HoverHandler { id: triggerHover; cursorShape: Qt.PointingHandCursor }
            TapHandler { onTapped: menu.popup(0, dropdownItem.height + 4) }
        }
        Menu {
            id: menu
            MenuItem { text: "Documentation" }
            MenuItem { text: "Themes" }
            MenuItem { text: "GitHub" }
        }
    }
    BreadcrumbSeparator { iconName: "dot" }
    BreadcrumbItem {
        BreadcrumbPage { text: "Breadcrumb" }
    }
}
