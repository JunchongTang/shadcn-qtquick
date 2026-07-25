import QtQuick

PageScaffold {
    description: qsTr("A control that allows the user to toggle between checked and not checked.")

    ExampleCard {
        title: qsTr("Checkbox")
        source: "qrc:/demos/checkbox/Basic.qml"
    }
    ExampleCard {
        title: qsTr("Checked State")
        description: qsTr("Use the checked property to control the checked state.")
        source: "qrc:/demos/checkbox/CheckedState.qml"
    }
    ExampleCard {
        title: qsTr("Invalid State")
        description: qsTr("Use the invalid state to show validation errors.")
        source: "qrc:/demos/checkbox/InvalidState.qml"
    }
    ExampleCard {
        title: qsTr("Description")
        description: qsTr("Pair the checkbox with a label and a supporting description.")
        source: "qrc:/demos/checkbox/Description.qml"
    }
    ExampleCard {
        title: qsTr("Disabled")
        description: qsTr("Add the disabled state to prevent interaction.")
        source: "qrc:/demos/checkbox/Disabled.qml"
    }
    ExampleCard {
        title: qsTr("Group")
        description: qsTr("Use multiple checkboxes to create a checkbox list.")
        source: "qrc:/demos/checkbox/Group.qml"
    }
    ExampleCard {
        title: qsTr("Table")
        description: qsTr("Use checkboxes in a table for row selection with a select-all header.")
        source: "qrc:/demos/checkbox/Table.qml"
        previewMinHeight: 300
    }
}
