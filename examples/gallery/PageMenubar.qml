import QtQuick

PageScaffold {
    description: "A visually persistent menu common in desktop applications that provides quick access to a consistent set of commands."

    ExampleCard {
        title: "Menubar"
        description: "A typical application menubar with groups, shortcuts, checkboxes, radios and nested submenus."
        source: "qrc:/demos/menubar/Demo.qml"
    }

    ExampleCard {
        title: "Checkbox"
        description: "Use checkbox items for toggleable options."
        source: "qrc:/demos/menubar/Checkbox.qml"
    }

    ExampleCard {
        title: "Radio"
        description: "Use radio items for single-select options within a menu."
        source: "qrc:/demos/menubar/Radio.qml"
    }

    ExampleCard {
        title: "Submenu"
        description: "Nest secondary actions with a sub-trigger and cascading sub-content."
        source: "qrc:/demos/menubar/Submenu.qml"
    }

    ExampleCard {
        title: "With Icons"
        description: "Combine icons with labels for quick scanning."
        source: "qrc:/demos/menubar/Icons.qml"
    }
}
