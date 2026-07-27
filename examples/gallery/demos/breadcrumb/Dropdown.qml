import QtQuick
import Shadcn
import LucideIcons

// Official breadcrumb-dropdown: middle item is a dropdown trigger (Components + chevron-down), dot separators.
Breadcrumb {
    BreadcrumbItem {
        BreadcrumbLink { text: qsTr("Home") }
    }
    BreadcrumbSeparator { iconName: "dot" }
    BreadcrumbItem {
        id: dropdownItem
        // Dropdown trigger: text + chevron share one clickable area (mirrors a single DropdownMenuTrigger),
        // unified hover highlight, clicking anywhere pops the menu.
        Row {
            id: trigger
            spacing: Theme.space1
            property bool hovered: triggerHover.hovered

            Text {
                text: qsTr("Components")
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
            MenuItem { text: qsTr("Documentation") }
            MenuItem { text: qsTr("Themes") }
            MenuItem { text: qsTr("GitHub") }
        }
    }
    BreadcrumbSeparator { iconName: "dot" }
    BreadcrumbItem {
        BreadcrumbPage { text: qsTr("Breadcrumb") }
    }
}
