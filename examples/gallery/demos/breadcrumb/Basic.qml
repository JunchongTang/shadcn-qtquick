import QtQuick
import Shadcn

// 官方 breadcrumb-basic:Home / Components 链接 + 当前页 Breadcrumb。
Breadcrumb {
    BreadcrumbItem {
        BreadcrumbLink { text: "Home" }
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
