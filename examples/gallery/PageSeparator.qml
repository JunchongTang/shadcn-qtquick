import QtQuick

PageScaffold {
    description: "Visually or semantically separates content."

    ExampleCard {
        title: "Separator"
        source: "qrc:/demos/separator/Basic.qml"
    }

    ExampleCard {
        title: "Vertical"
        description: "Use a vertical orientation for a vertical separator."
        source: "qrc:/demos/separator/Vertical.qml"
    }

    ExampleCard {
        title: "Menu"
        description: "Vertical separators between menu items with descriptions."
        source: "qrc:/demos/separator/Menu.qml"
    }

    ExampleCard {
        title: "List"
        description: "Horizontal separators between list items."
        source: "qrc:/demos/separator/List.qml"
    }
}
