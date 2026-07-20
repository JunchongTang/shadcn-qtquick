import QtQuick
import Shadcn

// 基础导航菜单:两个带下拉的项(简介 / 组件网格)+ 一个带图标的项 + 一个纯链接项。
// 对齐官方 navigation-menu-demo:hover / 点击展开 popover 面板,面板内为链接网格。
NavigationMenu {
    id: nav

    // 带下拉:单列、带描述的链接(w-96)。
    NavigationMenuItem {
        text: "Getting started"
        contentWidth: 384
        NavigationMenuLink {
            text: "Introduction"
            description: "Re-usable components built with Tailwind CSS."
        }
        NavigationMenuLink {
            text: "Installation"
            description: "How to install dependencies and structure your app."
        }
        NavigationMenuLink {
            text: "Typography"
            description: "Styles for headings, paragraphs, lists...etc"
        }
    }

    // 带下拉:两列网格、带描述(w-[560])。
    NavigationMenuItem {
        text: "Components"
        columns: 2
        contentWidth: 560
        NavigationMenuLink {
            text: "Alert Dialog"
            description: "A modal dialog that interrupts the user with important content."
        }
        NavigationMenuLink {
            text: "Hover Card"
            description: "For sighted users to preview content available behind a link."
        }
        NavigationMenuLink {
            text: "Progress"
            description: "Displays an indicator showing the completion progress of a task."
        }
        NavigationMenuLink {
            text: "Tabs"
            description: "Layered sections of content displayed one at a time."
        }
    }

    // 带下拉:图标 + 文本的窄列表(w-[200])。
    NavigationMenuItem {
        text: "With Icon"
        contentWidth: 200
        NavigationMenuLink { text: "Backlog"; iconName: "circle-alert" }
        NavigationMenuLink { text: "To Do"; iconName: "circle-dashed" }
        NavigationMenuLink { text: "Done"; iconName: "circle-check" }
    }

    // 纯链接项(触发头样式,直接可点)。
    NavigationMenuItem {
        text: "Docs"
        asLink: true
        onTriggered: console.log("navigate: /docs")
    }
}
