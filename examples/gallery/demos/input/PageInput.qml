import QtQuick

PageScaffold {
    description: "Displays a form input field or a component that looks like an input field."

    ExampleCard {
        title: "Basic"
        description: "A single-line text field."
        source: "qrc:/demos/input/Basic.qml"
    }
    ExampleCard {
        title: "With Label"
        description: "Pair the input with a label and a description (Field)."
        source: "qrc:/demos/input/WithLabel.qml"
    }
    ExampleCard {
        title: "Invalid"
        description: "Mark the input as invalid to surface validation errors."
        source: "qrc:/demos/input/Invalid.qml"
    }
    ExampleCard {
        title: "Required"
        description: "Indicate a required field with a destructive asterisk."
        source: "qrc:/demos/input/Required.qml"
    }
    ExampleCard {
        title: "Disabled"
        description: "Disable the whole field."
        source: "qrc:/demos/input/Disabled.qml"
    }
    ExampleCard {
        title: "Form"
        description: "A full form with multiple inputs, a select and actions."
        source: "qrc:/demos/input/Form.qml"
    }
}
