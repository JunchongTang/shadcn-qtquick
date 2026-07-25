import QtQuick

PageScaffold {
    description: qsTr("Autocomplete input with a list of suggestions — type to filter.")

    ExampleCard {
        title: qsTr("Basic")
        description: qsTr("A combobox with a list of frameworks. Type to filter.")
        source: "qrc:/demos/combobox/Basic.qml"
    }
    ExampleCard {
        title: qsTr("Multiple")
        description: qsTr("Use multiple for multi-select with removable chips.")
        source: "qrc:/demos/combobox/Multiple.qml"
    }
    ExampleCard {
        title: qsTr("Clear Button")
        description: qsTr("Use showClear to render a button that clears the value.")
        source: "qrc:/demos/combobox/Clear.qml"
    }
    ExampleCard {
        title: qsTr("Groups")
        description: qsTr("Group items with labels and separators.")
        source: "qrc:/demos/combobox/Groups.qml"
    }
    ExampleCard {
        title: qsTr("Custom Items")
        description: qsTr("Render rich two-line items with a title and description.")
        source: "qrc:/demos/combobox/Custom.qml"
    }
    ExampleCard {
        title: qsTr("Invalid")
        description: qsTr("Use invalid to mark the combobox invalid.")
        source: "qrc:/demos/combobox/Invalid.qml"
    }
    ExampleCard {
        title: qsTr("Disabled")
        description: qsTr("Use enabled: false to disable the combobox.")
        source: "qrc:/demos/combobox/Disabled.qml"
    }
    ExampleCard {
        title: qsTr("Input Group")
        description: qsTr("Add a leading icon inside the combobox input.")
        source: "qrc:/demos/combobox/InputGroup.qml"
    }
}
