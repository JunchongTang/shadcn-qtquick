import QtQuick

PageScaffold {
    description: qsTr("An interactive component which expands/collapses a panel.")

    ExampleCard {
        title: qsTr("Collapsible")
        source: "qrc:/demos/collapsible/Demo.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: qsTr("Basic")
        source: "qrc:/demos/collapsible/Basic.qml"
    }
    ExampleCard {
        title: qsTr("Settings Panel")
        description: qsTr("Use a trigger button to reveal additional settings.")
        source: "qrc:/demos/collapsible/Settings.qml"
    }
    ExampleCard {
        title: qsTr("File Tree")
        description: qsTr("Use nested collapsibles to build a file tree.")
        source: "qrc:/demos/collapsible/FileTree.qml"
        previewMinHeight: 460
    }
}
