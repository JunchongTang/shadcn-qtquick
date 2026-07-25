import QtQuick
import Shadcn

// 官方 breadcrumb-separator:用圆点(dot)作自定义分隔符。
Breadcrumb {
    BreadcrumbItem {
        BreadcrumbLink { text: qsTr("Home") }
    }
    BreadcrumbSeparator { iconName: "dot" }
    BreadcrumbItem {
        BreadcrumbLink { text: qsTr("Components") }
    }
    BreadcrumbSeparator { iconName: "dot" }
    BreadcrumbItem {
        BreadcrumbPage { text: qsTr("Breadcrumb") }
    }
}
