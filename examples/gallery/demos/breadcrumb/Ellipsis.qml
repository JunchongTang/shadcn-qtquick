import QtQuick
import Shadcn

// 官方 breadcrumb-ellipsis(Collapsed):用 BreadcrumbEllipsis 表示折叠的中间层级。
Breadcrumb {
    BreadcrumbItem {
        BreadcrumbLink { text: qsTr("Home") }
    }
    BreadcrumbSeparator {}
    BreadcrumbItem {
        BreadcrumbEllipsis {}
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
