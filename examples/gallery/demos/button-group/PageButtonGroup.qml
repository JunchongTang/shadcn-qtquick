import QtQuick

PageScaffold {
    description: qsTr("A container that groups related buttons together with consistent styling.")

    ExampleCard {
        title: qsTr("Button Group")
        description: qsTr("Group related buttons; the last icon button opens a dropdown menu.")
        source: "qrc:/demos/button-group/Demo.qml"
    }
    ExampleCard {
        title: qsTr("Orientation")
        description: qsTr("Set the orientation property to lay the group out vertically.")
        source: "qrc:/demos/button-group/Orientation.qml"
    }
    ExampleCard {
        title: qsTr("Size")
        description: qsTr("Control the size of the group using the size prop on individual buttons.")
        source: "qrc:/demos/button-group/Sizes.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: qsTr("Nested")
        description: qsTr("Nest ButtonGroups to create groups with spacing (gap-2).")
        source: "qrc:/demos/button-group/Nested.qml"
    }
    ExampleCard {
        title: qsTr("Separator")
        description: qsTr("ButtonGroupSeparator visually divides buttons within a group.")
        source: "qrc:/demos/button-group/Separator.qml"
    }
    ExampleCard {
        title: qsTr("Split")
        description: qsTr("A split button group: two buttons divided by a separator.")
        source: "qrc:/demos/button-group/Split.qml"
    }
    ExampleCard {
        title: qsTr("Input")
        description: qsTr("Wrap an Input component with buttons.")
        source: "qrc:/demos/button-group/Input.qml"
    }
    ExampleCard {
        title: qsTr("Select")
        description: qsTr("Pair a Select and Input with a trailing action button.")
        source: "qrc:/demos/button-group/Select.qml"
    }
    ExampleCard {
        title: qsTr("Text")
        description: qsTr("Use ButtonGroupText to display text within a group.")
        source: "qrc:/demos/button-group/Text.qml"
    }
    ExampleCard {
        title: qsTr("Dropdown Menu")
        description: qsTr("A split button group with a dropdown menu.")
        source: "qrc:/demos/button-group/Dropdown.qml"
    }
    ExampleCard {
        title: qsTr("Popover")
        description: qsTr("Use a button group together with a Popover.")
        source: "qrc:/demos/button-group/Popover.qml"
    }
}
