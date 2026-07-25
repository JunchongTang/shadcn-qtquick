import QtQuick

PageScaffold {
    description: qsTr("A set of layered sections of content—known as tab panels—displayed one at a time.")

    ExampleCard {
        title: qsTr("Tabs")
        source: "qrc:/demos/tabs/Basic.qml"
        previewMinHeight: 260
    }

    ExampleCard {
        title: qsTr("Line")
        description: qsTr("Use the line variant for an underlined tab style.")
        source: "qrc:/demos/tabs/Line.qml"
        previewMinHeight: 160
    }

    ExampleCard {
        title: qsTr("Vertical")
        description: qsTr("Stack the tabs vertically.")
        source: "qrc:/demos/tabs/Vertical.qml"
        previewMinHeight: 180
    }

    ExampleCard {
        title: qsTr("Disabled")
        description: qsTr("Disable individual tabs.")
        source: "qrc:/demos/tabs/Disabled.qml"
        previewMinHeight: 160
    }

    ExampleCard {
        title: qsTr("Icons")
        description: qsTr("Add icons to the tab triggers.")
        source: "qrc:/demos/tabs/Icons.qml"
        previewMinHeight: 160
    }
}
