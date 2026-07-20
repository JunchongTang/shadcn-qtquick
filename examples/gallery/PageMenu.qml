import QtQuick

PageScaffold {
    description: "Displays a menu to the user — triggered by a button."

    ExampleCard {
        title: "Dropdown Menu"
        source: "qrc:/demos/menu/Basic.qml"
    }

    ExampleCard {
        title: "Checkboxes"
        description: "Use checkbox items for toggles; state shown by a trailing check."
        source: "qrc:/demos/menu/Checkboxes.qml"
    }

    ExampleCard {
        title: "Radio Group"
        description: "Mutually exclusive options within a menu."
        source: "qrc:/demos/menu/RadioGroup.qml"
    }

    ExampleCard {
        title: "Submenu"
        description: "Nest secondary actions with a sub-trigger and cascading sub-content."
        source: "qrc:/demos/menu/Submenu.qml"
    }

    ExampleCard {
        title: "Shortcuts"
        description: "Show keyboard hints aligned to the trailing edge."
        source: "qrc:/demos/menu/Shortcuts.qml"
    }

    ExampleCard {
        title: "Icons"
        description: "Combine icons with labels for quick scanning."
        source: "qrc:/demos/menu/Icons.qml"
    }

    ExampleCard {
        title: "Destructive"
        description: "Use the destructive variant for irreversible actions."
        source: "qrc:/demos/menu/Destructive.qml"
    }

    ExampleCard {
        title: "Avatar"
        description: "An account switcher dropdown triggered by an avatar."
        source: "qrc:/demos/menu/Avatar.qml"
    }

    ExampleCard {
        title: "Complex"
        description: "Groups, icons, shortcuts, checkboxes, radios and nested submenus combined."
        source: "qrc:/demos/menu/Complex.qml"
    }
}
