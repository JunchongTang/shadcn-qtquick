import QtQuick

PageScaffold {
    description: qsTr("A visually persistent menu common in desktop applications that provides quick access to a consistent set of commands.")

    ExampleCard {
        title: qsTr("Menubar")
        description: qsTr("A typical application menubar with groups, shortcuts, checkboxes, radios and nested submenus.")
        source: "qrc:/demos/menubar/Demo.qml"
    }

    ExampleCard {
        title: qsTr("Checkbox")
        description: qsTr("Use checkbox items for toggleable options.")
        source: "qrc:/demos/menubar/Checkbox.qml"
    }

    ExampleCard {
        title: qsTr("Radio")
        description: qsTr("Use radio items for single-select options within a menu.")
        source: "qrc:/demos/menubar/Radio.qml"
    }

    ExampleCard {
        title: qsTr("Submenu")
        description: qsTr("Nest secondary actions with a sub-trigger and cascading sub-content.")
        source: "qrc:/demos/menubar/Submenu.qml"
    }

    ExampleCard {
        title: qsTr("With Icons")
        description: qsTr("Combine icons with labels for quick scanning.")
        source: "qrc:/demos/menubar/Icons.qml"
    }
}
