import QtQuick

PageScaffold {
    description: "Fast, composable, unstyled command menu for search and quick actions."

    ExampleCard {
        title: "Command"
        description: "An inline command menu with grouped, filterable items, icons and shortcuts."
        source: "qrc:/demos/command/Demo.qml"
    }
    ExampleCard {
        title: "Basic"
        description: "A simple command menu hosted in a dialog."
        source: "qrc:/demos/command/Basic.qml"
    }
    ExampleCard {
        title: "Shortcuts"
        description: "Show keyboard hints aligned to the trailing edge of each item."
        source: "qrc:/demos/command/Shortcuts.qml"
    }
    ExampleCard {
        title: "Groups"
        description: "A command menu with groups, icons and separators."
        source: "qrc:/demos/command/Groups.qml"
    }
    ExampleCard {
        title: "Scrollable"
        description: "Scrollable command menu with many grouped items."
        source: "qrc:/demos/command/Scrollable.qml"
    }
    ExampleCard {
        title: "Dialog"
        description: "Toggle the command palette with the ⌘K keyboard shortcut."
        source: "qrc:/demos/command/CommandDialog.qml"
    }
}
