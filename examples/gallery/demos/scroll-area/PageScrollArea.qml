import QtQuick

PageScaffold {
    description: "Augments native scroll functionality for custom, cross-browser styling."

    ExampleCard {
        title: "Scroll Area"
        source: "qrc:/demos/scroll-area/Demo.qml"
        previewMinHeight: 360
    }
    ExampleCard {
        title: "Horizontal"
        description: "Scroll content horizontally when it overflows on the x-axis."
        source: "qrc:/demos/scroll-area/Horizontal.qml"
        previewMinHeight: 340
    }
}
