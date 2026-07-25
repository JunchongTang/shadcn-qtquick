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
            text: qsTr("Getting started")
            contentWidth: 384
            NavigationMenuLink { text: qsTr("Introduction"); description: qsTr("Re-usable components built with Tailwind CSS.") }
            NavigationMenuLink { text: qsTr("Installation"); description: qsTr("How to install dependencies and structure your app.") }
            NavigationMenuLink { text: qsTr("Typography"); description: qsTr("Styles for headings, paragraphs, lists...etc") }
        }
        NavigationMenuItem {
            text: qsTr("Components")
            columns: 2
            contentWidth: 500
            NavigationMenuLink { text: qsTr("Alert Dialog"); description: qsTr("A modal dialog that interrupts the user.") }
            NavigationMenuLink { text: qsTr("Hover Card"); description: qsTr("Preview content behind a link.") }
        }
        NavigationMenuItem { text: qsTr("Docs"); asLink: true }
    }

    Component.onCompleted: nav.requestOpen(firstItem)
}
