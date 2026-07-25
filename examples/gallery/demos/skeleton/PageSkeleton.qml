import QtQuick

PageScaffold {
    description: qsTr("Use to show a placeholder while content is loading.")

    ExampleCard {
        title: qsTr("Skeleton")
        source: "qrc:/demos/skeleton/Demo.qml"
    }
    ExampleCard {
        title: qsTr("Avatar")
        source: "qrc:/demos/skeleton/Avatar.qml"
    }
    ExampleCard {
        title: qsTr("Card")
        source: "qrc:/demos/skeleton/Card.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: qsTr("Text")
        source: "qrc:/demos/skeleton/Text.qml"
    }
    ExampleCard {
        title: qsTr("Form")
        source: "qrc:/demos/skeleton/Form.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: qsTr("Table")
        source: "qrc:/demos/skeleton/Table.qml"
    }
}
