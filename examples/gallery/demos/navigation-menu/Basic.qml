import QtQuick
import Shadcn

// Basic navigation menu: two dropdown items (intro / component grid) + one item with icons + one plain link item.
// Matches Official navigation-menu-demo: hover / click expands a popover panel with a grid of links.
NavigationMenu {
    id: nav

    // Dropdown: single column, links with descriptions (w-96).
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

    // Dropdown: two-column grid with descriptions (w-[560]).
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

    // Dropdown: narrow list of icon + text (w-[200]).
    NavigationMenuItem {
        text: qsTr("With Icon")
        contentWidth: 200
        NavigationMenuLink { text: qsTr("Backlog"); iconName: "circle-alert" }
        NavigationMenuLink { text: qsTr("To Do"); iconName: "circle-dashed" }
        NavigationMenuLink { text: qsTr("Done"); iconName: "circle-check" }
    }

    // Plain link item (trigger-header style, directly clickable).
    NavigationMenuItem {
        text: qsTr("Docs")
        asLink: true
        onTriggered: console.log("navigate: /docs")
    }
}
