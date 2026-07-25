import QtQuick
import Shadcn

// 官方 breadcrumb-demo:Home / 省略号下拉 / Components / Breadcrumb。
Breadcrumb {
    BreadcrumbItem {
        BreadcrumbLink { text: qsTr("Home") }
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
                MenuItem { text: qsTr("Documentation") }
                MenuItem { text: qsTr("Themes") }
                MenuItem { text: qsTr("GitHub") }
            }
        }
    }
    BreadcrumbSeparator {}
    BreadcrumbItem {
        BreadcrumbLink { text: qsTr("Components") }
    }
    BreadcrumbSeparator {}
    BreadcrumbItem {
        BreadcrumbPage { text: qsTr("Breadcrumb") }
    }
}
