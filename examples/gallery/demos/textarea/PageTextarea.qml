import QtQuick

PageScaffold {
    description: "Displays a form textarea or a component that looks like a textarea."

    ExampleCard {
        title: "Basic"
        description: "A multi-line text field."
        source: "qrc:/demos/textarea/Basic.qml"
    }
    ExampleCard {
        title: "With Label"
        description: "Pair the textarea with a label and a description (Field)."
        source: "qrc:/demos/textarea/WithLabel.qml"
    }
    ExampleCard {
        title: "Disabled"
        description: "Disable the whole field."
        source: "qrc:/demos/textarea/Disabled.qml"
    }
    ExampleCard {
        title: "Invalid"
        description: "Mark the textarea as invalid to surface validation errors."
        source: "qrc:/demos/textarea/Invalid.qml"
    }
    ExampleCard {
        title: "Button"
        description: "Pair with a button to create a message composer."
        source: "qrc:/demos/textarea/Button.qml"
    }
}
