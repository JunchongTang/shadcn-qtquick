import QtQuick

PageScaffold {
    description: qsTr("Visually or semantically separates content.")

    ExampleCard {
        title: qsTr("Separator")
        source: "qrc:/demos/separator/Basic.qml"
    }

    ExampleCard {
        title: qsTr("Vertical")
        description: qsTr("Use a vertical orientation for a vertical separator.")
        source: "qrc:/demos/separator/Vertical.qml"
    }

    ExampleCard {
        title: qsTr("Menu")
        description: qsTr("Vertical separators between menu items with descriptions.")
        source: "qrc:/demos/separator/Menu.qml"
    }

    ExampleCard {
        title: qsTr("List")
        description: qsTr("Horizontal separators between list items.")
        source: "qrc:/demos/separator/List.qml"
    }
}
