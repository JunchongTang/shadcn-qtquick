import QtQuick

PageScaffold {
    description: "Displays a menu of actions triggered by a right click."

    ExampleCard {
        title: "Context Menu"
        description: "Groups, shortcuts, a submenu, checkboxes and radios combined."
        source: "qrc:/demos/context-menu/Demo.qml"
    }

    ExampleCard {
        title: "Basic"
        description: "A simple context menu with a few actions."
        source: "qrc:/demos/context-menu/Basic.qml"
    }

    ExampleCard {
        title: "Submenu"
        description: "Nest secondary actions with a cascading sub-menu."
        source: "qrc:/demos/context-menu/Submenu.qml"
    }

    ExampleCard {
        title: "Shortcuts"
        description: "Show keyboard hints aligned to the trailing edge."
        source: "qrc:/demos/context-menu/Shortcuts.qml"
    }

    ExampleCard {
        title: "Groups"
        description: "Group related actions and separate them with dividers."
        source: "qrc:/demos/context-menu/Groups.qml"
    }

    ExampleCard {
        title: "Icons"
        description: "Combine icons with labels for quick scanning."
        source: "qrc:/demos/context-menu/Icons.qml"
    }

    ExampleCard {
        title: "Checkboxes"
        description: "Use checkbox items for toggles."
        source: "qrc:/demos/context-menu/Checkboxes.qml"
    }

    ExampleCard {
        title: "Radio"
        description: "Use radio items for exclusive choices."
        source: "qrc:/demos/context-menu/Radio.qml"
    }

    ExampleCard {
        title: "Destructive"
        description: "Use the destructive variant to style a menu item as destructive."
        source: "qrc:/demos/context-menu/Destructive.qml"
    }
}
