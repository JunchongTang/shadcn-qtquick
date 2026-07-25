import QtQuick

PageScaffold {
    description: qsTr("Augments native scroll functionality for custom, cross-browser styling.")

    ExampleCard {
        title: qsTr("Scroll Area")
        source: "qrc:/demos/scroll-area/Demo.qml"
        previewMinHeight: 360
    }
    ExampleCard {
        title: qsTr("Horizontal")
        description: qsTr("Scroll content horizontally when it overflows on the x-axis.")
        source: "qrc:/demos/scroll-area/Horizontal.qml"
        previewMinHeight: 340
    }
}
