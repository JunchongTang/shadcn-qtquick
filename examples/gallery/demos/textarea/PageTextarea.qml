import QtQuick

PageScaffold {
    description: qsTr("Displays a form textarea or a component that looks like a textarea.")

    ExampleCard {
        title: qsTr("Basic")
        description: qsTr("A multi-line text field.")
        source: "qrc:/demos/textarea/Basic.qml"
    }
    ExampleCard {
        title: qsTr("With Label")
        description: qsTr("Pair the textarea with a label and a description (Field).")
        source: "qrc:/demos/textarea/WithLabel.qml"
    }
    ExampleCard {
        title: qsTr("Disabled")
        description: qsTr("Disable the whole field.")
        source: "qrc:/demos/textarea/Disabled.qml"
    }
    ExampleCard {
        title: qsTr("Invalid")
        description: qsTr("Mark the textarea as invalid to surface validation errors.")
        source: "qrc:/demos/textarea/Invalid.qml"
    }
    ExampleCard {
        title: qsTr("Button")
        description: qsTr("Pair with a button to create a message composer.")
        source: "qrc:/demos/textarea/Button.qml"
    }
}
