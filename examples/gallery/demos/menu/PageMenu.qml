import QtQuick

PageScaffold {
    description: qsTr("Displays a menu to the user — triggered by a button.")

    ExampleCard {
        title: qsTr("Dropdown Menu")
        source: "qrc:/demos/menu/Basic.qml"
    }

    ExampleCard {
        title: qsTr("Checkboxes")
        description: qsTr("Use checkbox items for toggles; state shown by a trailing check.")
        source: "qrc:/demos/menu/Checkboxes.qml"
    }

    ExampleCard {
        title: qsTr("Radio Group")
        description: qsTr("Mutually exclusive options within a menu.")
        source: "qrc:/demos/menu/RadioGroup.qml"
    }

    ExampleCard {
        title: qsTr("Submenu")
        description: qsTr("Nest secondary actions with a sub-trigger and cascading sub-content.")
        source: "qrc:/demos/menu/Submenu.qml"
    }

    ExampleCard {
        title: qsTr("Shortcuts")
        description: qsTr("Show keyboard hints aligned to the trailing edge.")
        source: "qrc:/demos/menu/Shortcuts.qml"
    }

    ExampleCard {
        title: qsTr("Icons")
        description: qsTr("Combine icons with labels for quick scanning.")
        source: "qrc:/demos/menu/Icons.qml"
    }

    ExampleCard {
        title: qsTr("Destructive")
        description: qsTr("Use the destructive variant for irreversible actions.")
        source: "qrc:/demos/menu/Destructive.qml"
    }

    ExampleCard {
        title: qsTr("Avatar")
        description: qsTr("An account switcher dropdown triggered by an avatar.")
        source: "qrc:/demos/menu/Avatar.qml"
    }

    ExampleCard {
        title: qsTr("Complex")
        description: qsTr("Groups, icons, shortcuts, checkboxes, radios and nested submenus combined.")
        source: "qrc:/demos/menu/Complex.qml"
    }
}
