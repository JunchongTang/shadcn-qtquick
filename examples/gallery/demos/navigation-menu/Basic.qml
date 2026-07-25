import QtQuick
import Shadcn

// 基础导航菜单:两个带下拉的项(简介 / 组件网格)+ 一个带图标的项 + 一个纯链接项。
// 对齐官方 navigation-menu-demo:hover / 点击展开 popover 面板,面板内为链接网格。
NavigationMenu {
    id: nav

    // 带下拉:单列、带描述的链接(w-96)。
    NavigationMenuItem {
        text: qsTr("Getting started")
        contentWidth: 384
        NavigationMenuLink {
            text: qsTr("Introduction")
            description: qsTr("Re-usable components built with Tailwind CSS.")
        }
        NavigationMenuLink {
            text: qsTr("Installation")
            description: qsTr("How to install dependencies and structure your app.")
        }
        NavigationMenuLink {
            text: qsTr("Typography")
            description: qsTr("Styles for headings, paragraphs, lists...etc")
        }
    }

    // 带下拉:两列网格、带描述(w-[560])。
    NavigationMenuItem {
        text: qsTr("Components")
        columns: 2
        contentWidth: 560
        NavigationMenuLink {
            text: qsTr("Alert Dialog")
            description: qsTr("A modal dialog that interrupts the user with important content.")
        }
        NavigationMenuLink {
            text: qsTr("Hover Card")
            description: qsTr("For sighted users to preview content available behind a link.")
        }
        NavigationMenuLink {
            text: qsTr("Progress")
            description: qsTr("Displays an indicator showing the completion progress of a task.")
        }
        NavigationMenuLink {
            text: qsTr("Tabs")
            description: qsTr("Layered sections of content displayed one at a time.")
        }
    }

    // 带下拉:图标 + 文本的窄列表(w-[200])。
    NavigationMenuItem {
        text: qsTr("With Icon")
        contentWidth: 200
        NavigationMenuLink { text: qsTr("Backlog"); iconName: "circle-alert" }
        NavigationMenuLink { text: qsTr("To Do"); iconName: "circle-dashed" }
        NavigationMenuLink { text: qsTr("Done"); iconName: "circle-check" }
    }

    // 纯链接项(触发头样式,直接可点)。
    NavigationMenuItem {
        text: qsTr("Docs")
        asLink: true
        onTriggered: console.log("navigate: /docs")
    }
}
