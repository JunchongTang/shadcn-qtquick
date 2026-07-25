import QtQuick

PageScaffold {
    description: qsTr("Fast, composable, unstyled command menu for search and quick actions.")

    ExampleCard {
        title: qsTr("Command")
        description: qsTr("An inline command menu with grouped, filterable items, icons and shortcuts.")
        source: "qrc:/demos/command/Demo.qml"
    }
    ExampleCard {
        title: qsTr("Basic")
        description: qsTr("A simple command menu hosted in a dialog.")
        source: "qrc:/demos/command/Basic.qml"
    }
    ExampleCard {
        title: qsTr("Shortcuts")
        description: qsTr("Show keyboard hints aligned to the trailing edge of each item.")
        source: "qrc:/demos/command/Shortcuts.qml"
    }
    ExampleCard {
        title: qsTr("Groups")
        description: qsTr("A command menu with groups, icons and separators.")
        source: "qrc:/demos/command/Groups.qml"
    }
    ExampleCard {
        title: qsTr("Scrollable")
        description: qsTr("Scrollable command menu with many grouped items.")
        source: "qrc:/demos/command/Scrollable.qml"
    }
    ExampleCard {
        title: qsTr("Dialog")
        description: qsTr("Toggle the command palette with the ⌘K keyboard shortcut.")
        source: "qrc:/demos/command/CommandDialog.qml"
    }
}
