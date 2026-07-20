import QtQuick

PageScaffold {
    description: "Use to show a placeholder while content is loading."

    ExampleCard {
        title: "Skeleton"
        source: "qrc:/demos/skeleton/Demo.qml"
    }
    ExampleCard {
        title: "Avatar"
        source: "qrc:/demos/skeleton/Avatar.qml"
    }
    ExampleCard {
        title: "Card"
        source: "qrc:/demos/skeleton/Card.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: "Text"
        source: "qrc:/demos/skeleton/Text.qml"
    }
    ExampleCard {
        title: "Form"
        source: "qrc:/demos/skeleton/Form.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: "Table"
        source: "qrc:/demos/skeleton/Table.qml"
    }
}
