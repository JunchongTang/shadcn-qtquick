import QtQuick

PageScaffold {
    description: qsTr("Accessible resizable panel groups and layouts with keyboard support.")

    ExampleCard {
        title: qsTr("Horizontal")
        description: qsTr("Drag the 1px handle to change how space is split between the two panels.")
        source: "qrc:/demos/resizable/Horizontal.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: qsTr("Vertical")
        description: qsTr("Use orientation Qt.Vertical for top/bottom resizing.")
        source: "qrc:/demos/resizable/Vertical.qml"
        previewMinHeight: 280
    }
    ExampleCard {
        title: qsTr("With Handle")
        description: qsTr("Set withHandle to show a visible grip in the center of each handle.")
        source: "qrc:/demos/resizable/WithHandle.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: qsTr("Nested")
        description: qsTr("Nest a Resizable inside a panel to build more complex layouts.")
        source: "qrc:/demos/resizable/Nested.qml"
        previewMinHeight: 280
    }
}
