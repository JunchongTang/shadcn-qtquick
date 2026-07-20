import QtQuick

PageScaffold {
    description: "A control that allows the user to toggle between checked and not checked."

    ExampleCard {
        title: "Checkbox"
        source: "qrc:/demos/checkbox/Basic.qml"
    }
    ExampleCard {
        title: "Checked State"
        description: "Use the checked property to control the checked state."
        source: "qrc:/demos/checkbox/CheckedState.qml"
    }
    ExampleCard {
        title: "Invalid State"
        description: "Use the invalid state to show validation errors."
        source: "qrc:/demos/checkbox/InvalidState.qml"
    }
    ExampleCard {
        title: "Description"
        description: "Pair the checkbox with a label and a supporting description."
        source: "qrc:/demos/checkbox/Description.qml"
    }
    ExampleCard {
        title: "Disabled"
        description: "Add the disabled state to prevent interaction."
        source: "qrc:/demos/checkbox/Disabled.qml"
    }
    ExampleCard {
        title: "Group"
        description: "Use multiple checkboxes to create a checkbox list."
        source: "qrc:/demos/checkbox/Group.qml"
    }
    ExampleCard {
        title: "Table"
        description: "Use checkboxes in a table for row selection with a select-all header."
        source: "qrc:/demos/checkbox/Table.qml"
        previewMinHeight: 300
    }
}
