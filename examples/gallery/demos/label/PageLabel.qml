import QtQuick

PageScaffold {
    description: qsTr("Renders an accessible label associated with controls.")

    ExampleCard {
        title: qsTr("Basic")
        description: qsTr("A label paired with a checkbox.")
        source: "qrc:/demos/label/Basic.qml"
    }
    ExampleCard {
        title: qsTr("In a form")
        description: qsTr("Use labels with inputs and checkboxes to build forms.")
        source: "qrc:/demos/label/InForm.qml"
    }
}
