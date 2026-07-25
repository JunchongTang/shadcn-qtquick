import QtQuick
import Shadcn

Rectangle {
    color: Theme.background
    implicitWidth: 560
    implicitHeight: 380

    NavigationMenu {
        id: nav
        x: 24
        y: 24

        NavigationMenuItem {
            id: firstItem
            text: "Getting started"
            contentWidth: 384
            NavigationMenuLink { text: "Introduction"; description: "Re-usable components built with Tailwind CSS." }
            NavigationMenuLink { text: "Installation"; description: "How to install dependencies and structure your app." }
            NavigationMenuLink { text: "Typography"; description: "Styles for headings, paragraphs, lists...etc" }
        }
        NavigationMenuItem {
            text: "Components"
            columns: 2
            contentWidth: 500
            NavigationMenuLink { text: "Alert Dialog"; description: "A modal dialog that interrupts the user." }
            NavigationMenuLink { text: "Hover Card"; description: "Preview content behind a link." }
        }
        NavigationMenuItem { text: "Docs"; asLink: true }
    }

    Component.onCompleted: nav.requestOpen(firstItem)
}
