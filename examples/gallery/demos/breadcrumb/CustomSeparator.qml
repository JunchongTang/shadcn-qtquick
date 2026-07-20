import QtQuick
import Shadcn

// 官方 breadcrumb-separator:用圆点(dot)作自定义分隔符。
Breadcrumb {
    BreadcrumbItem {
        BreadcrumbLink { text: "Home" }
    }
    BreadcrumbSeparator { iconName: "dot" }
    BreadcrumbItem {
        BreadcrumbLink { text: "Components" }
    }
    BreadcrumbSeparator { iconName: "dot" }
    BreadcrumbItem {
        BreadcrumbPage { text: "Breadcrumb" }
    }
}
