import QtQuick

PageScaffold {
    description: "Autocomplete input with a list of suggestions — type to filter."

    ExampleCard {
        title: "Basic"
        description: "A combobox with a list of frameworks. Type to filter."
        source: "qrc:/demos/combobox/Basic.qml"
    }
    ExampleCard {
        title: "Multiple"
        description: "Use multiple for multi-select with removable chips."
        source: "qrc:/demos/combobox/Multiple.qml"
    }
    ExampleCard {
        title: "Clear Button"
        description: "Use showClear to render a button that clears the value."
        source: "qrc:/demos/combobox/Clear.qml"
    }
    ExampleCard {
        title: "Groups"
        description: "Group items with labels and separators."
        source: "qrc:/demos/combobox/Groups.qml"
    }
    ExampleCard {
        title: "Custom Items"
        description: "Render rich two-line items with a title and description."
        source: "qrc:/demos/combobox/Custom.qml"
    }
    ExampleCard {
        title: "Invalid"
        description: "Use invalid to mark the combobox invalid."
        source: "qrc:/demos/combobox/Invalid.qml"
    }
    ExampleCard {
        title: "Disabled"
        description: "Use enabled: false to disable the combobox."
        source: "qrc:/demos/combobox/Disabled.qml"
    }
    ExampleCard {
        title: "Input Group"
        description: "Add a leading icon inside the combobox input."
        source: "qrc:/demos/combobox/InputGroup.qml"
    }
}
