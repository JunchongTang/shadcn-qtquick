import QtQuick

PageScaffold {
    description: "An interactive component which expands/collapses a panel."

    ExampleCard {
        title: "Collapsible"
        source: "qrc:/demos/collapsible/Demo.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: "Basic"
        source: "qrc:/demos/collapsible/Basic.qml"
    }
    ExampleCard {
        title: "Settings Panel"
        description: "Use a trigger button to reveal additional settings."
        source: "qrc:/demos/collapsible/Settings.qml"
    }
    ExampleCard {
        title: "File Tree"
        description: "Use nested collapsibles to build a file tree."
        source: "qrc:/demos/collapsible/FileTree.qml"
        previewMinHeight: 460
    }
}
