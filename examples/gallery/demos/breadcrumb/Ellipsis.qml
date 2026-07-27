import QtQuick
import Shadcn

// Official breadcrumb-ellipsis (Collapsed): use BreadcrumbEllipsis to represent collapsed middle levels.
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
