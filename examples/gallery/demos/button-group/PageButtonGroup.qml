import QtQuick

PageScaffold {
    description: "A container that groups related buttons together with consistent styling."

    ExampleCard {
        title: "Button Group"
        description: "Group related buttons; the last icon button opens a dropdown menu."
        source: "qrc:/demos/button-group/Demo.qml"
    }
    ExampleCard {
        title: "Orientation"
        description: "Set the orientation property to lay the group out vertically."
        source: "qrc:/demos/button-group/Orientation.qml"
    }
    ExampleCard {
        title: "Size"
        description: "Control the size of the group using the size prop on individual buttons."
        source: "qrc:/demos/button-group/Sizes.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: "Nested"
        description: "Nest ButtonGroups to create groups with spacing (gap-2)."
        source: "qrc:/demos/button-group/Nested.qml"
    }
    ExampleCard {
        title: "Separator"
        description: "ButtonGroupSeparator visually divides buttons within a group."
        source: "qrc:/demos/button-group/Separator.qml"
    }
    ExampleCard {
        title: "Split"
        description: "A split button group: two buttons divided by a separator."
        source: "qrc:/demos/button-group/Split.qml"
    }
    ExampleCard {
        title: "Input"
        description: "Wrap an Input component with buttons."
        source: "qrc:/demos/button-group/Input.qml"
    }
    ExampleCard {
        title: "Select"
        description: "Pair a Select and Input with a trailing action button."
        source: "qrc:/demos/button-group/Select.qml"
    }
    ExampleCard {
        title: "Text"
        description: "Use ButtonGroupText to display text within a group."
        source: "qrc:/demos/button-group/Text.qml"
    }
    ExampleCard {
        title: "Dropdown Menu"
        description: "A split button group with a dropdown menu."
        source: "qrc:/demos/button-group/Dropdown.qml"
    }
    ExampleCard {
        title: "Popover"
        description: "Use a button group together with a Popover."
        source: "qrc:/demos/button-group/Popover.qml"
    }
}
