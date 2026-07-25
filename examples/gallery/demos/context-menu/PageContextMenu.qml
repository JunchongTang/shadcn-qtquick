import QtQuick

PageScaffold {
    description: qsTr("Displays a menu of actions triggered by a right click.")

    ExampleCard {
        title: qsTr("Context Menu")
        description: qsTr("Groups, shortcuts, a submenu, checkboxes and radios combined.")
        source: "qrc:/demos/context-menu/Demo.qml"
    }

    ExampleCard {
        title: qsTr("Basic")
        description: qsTr("A simple context menu with a few actions.")
        source: "qrc:/demos/context-menu/Basic.qml"
    }

    ExampleCard {
        title: qsTr("Submenu")
        description: qsTr("Nest secondary actions with a cascading sub-menu.")
        source: "qrc:/demos/context-menu/Submenu.qml"
    }

    ExampleCard {
        title: qsTr("Shortcuts")
        description: qsTr("Show keyboard hints aligned to the trailing edge.")
        source: "qrc:/demos/context-menu/Shortcuts.qml"
    }

    ExampleCard {
        title: qsTr("Groups")
        description: qsTr("Group related actions and separate them with dividers.")
        source: "qrc:/demos/context-menu/Groups.qml"
    }

    ExampleCard {
        title: qsTr("Icons")
        description: qsTr("Combine icons with labels for quick scanning.")
        source: "qrc:/demos/context-menu/Icons.qml"
    }

    ExampleCard {
        title: qsTr("Checkboxes")
        description: qsTr("Use checkbox items for toggles.")
        source: "qrc:/demos/context-menu/Checkboxes.qml"
    }

    ExampleCard {
        title: qsTr("Radio")
        description: qsTr("Use radio items for exclusive choices.")
        source: "qrc:/demos/context-menu/Radio.qml"
    }

    ExampleCard {
        title: qsTr("Destructive")
        description: qsTr("Use the destructive variant to style a menu item as destructive.")
        source: "qrc:/demos/context-menu/Destructive.qml"
    }
}
