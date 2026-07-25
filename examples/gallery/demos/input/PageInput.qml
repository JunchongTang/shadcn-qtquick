import QtQuick

PageScaffold {
    description: qsTr("Displays a form input field or a component that looks like an input field.")

    ExampleCard {
        title: qsTr("Basic")
        description: qsTr("A single-line text field.")
        source: "qrc:/demos/input/Basic.qml"
    }
    ExampleCard {
        title: qsTr("With Label")
        description: qsTr("Pair the input with a label and a description (Field).")
        source: "qrc:/demos/input/WithLabel.qml"
    }
    ExampleCard {
        title: qsTr("Invalid")
        description: qsTr("Mark the input as invalid to surface validation errors.")
        source: "qrc:/demos/input/Invalid.qml"
    }
    ExampleCard {
        title: qsTr("Required")
        description: qsTr("Indicate a required field with a destructive asterisk.")
        source: "qrc:/demos/input/Required.qml"
    }
    ExampleCard {
        title: qsTr("Disabled")
        description: qsTr("Disable the whole field.")
        source: "qrc:/demos/input/Disabled.qml"
    }
    ExampleCard {
        title: qsTr("Form")
        description: qsTr("A full form with multiple inputs, a select and actions.")
        source: "qrc:/demos/input/Form.qml"
    }
}
