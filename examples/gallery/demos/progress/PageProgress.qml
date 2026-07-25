import QtQuick

PageScaffold {
    description: qsTr("Displays an indicator showing the completion progress of a task.")

    ExampleCard {
        title: qsTr("Progress")
        source: "qrc:/demos/progress/Demo.qml"
    }
    ExampleCard {
        title: qsTr("Label")
        description: qsTr("Pair the bar with a label and a percentage value.")
        source: "qrc:/demos/progress/Label.qml"
    }
}
