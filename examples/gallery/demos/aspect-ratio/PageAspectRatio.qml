import QtQuick

PageScaffold {
    description: qsTr("Displays content within a desired ratio.")

    ExampleCard {
        title: qsTr("Aspect Ratio")
        description: qsTr("A 16:9 container (ratio={16/9}) whose content fills the ratio.")
        source: "qrc:/demos/aspect-ratio/Demo.qml"
    }
    ExampleCard {
        title: qsTr("Square")
        description: qsTr("A square aspect ratio using ratio={1/1}.")
        source: "qrc:/demos/aspect-ratio/Square.qml"
    }
    ExampleCard {
        title: qsTr("Portrait")
        description: qsTr("A portrait aspect ratio using ratio={9/16}.")
        source: "qrc:/demos/aspect-ratio/Portrait.qml"
        previewMinHeight: 320
    }
}
