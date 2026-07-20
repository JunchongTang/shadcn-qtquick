import QtQuick
import Shadcn

// 官方 breadcrumb-demo:Home / 省略号下拉 / Components / Breadcrumb。
Breadcrumb {
    BreadcrumbItem {
        BreadcrumbLink { text: "Home" }
    }
    BreadcrumbSeparator {}
    BreadcrumbItem {
        IconButton {
            id: trigger
            size: IconButton.Small
            variant: IconButton.Ghost
            iconName: "ellipsis"
            onClicked: menu.popup(0, trigger.height + 4)

            Menu {
                id: menu
                MenuItem { text: "Documentation" }
                MenuItem { text: "Themes" }
                MenuItem { text: "GitHub" }
            }
        }
    }
    BreadcrumbSeparator {}
    BreadcrumbItem {
        BreadcrumbLink { text: "Components" }
    }
    BreadcrumbSeparator {}
    BreadcrumbItem {
        BreadcrumbPage { text: "Breadcrumb" }
    }
}
