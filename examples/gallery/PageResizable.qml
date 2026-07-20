import QtQuick

PageScaffold {
    description: "Accessible resizable panel groups and layouts with keyboard support."

    ExampleCard {
        title: "Horizontal"
        description: "Drag the 1px handle to change how space is split between the two panels."
        source: "qrc:/demos/resizable/Horizontal.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: "Vertical"
        description: "Use orientation Qt.Vertical for top/bottom resizing."
        source: "qrc:/demos/resizable/Vertical.qml"
        previewMinHeight: 280
    }
    ExampleCard {
        title: "With Handle"
        description: "Set withHandle to show a visible grip in the center of each handle."
        source: "qrc:/demos/resizable/WithHandle.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: "Nested"
        description: "Nest a Resizable inside a panel to build more complex layouts."
        source: "qrc:/demos/resizable/Nested.qml"
        previewMinHeight: 280
    }
}
