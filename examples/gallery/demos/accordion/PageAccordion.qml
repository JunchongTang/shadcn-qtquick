import QtQuick

PageScaffold {
    description: qsTr("A vertically stacked set of interactive headings that each reveal a section of content.")

    ExampleCard {
        title: qsTr("Accordion")
        source: "qrc:/demos/accordion/Basic.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: qsTr("Multiple")
        description: qsTr("Allow more than one item to be open at a time.")
        source: "qrc:/demos/accordion/Multiple.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: qsTr("Disabled")
        description: qsTr("Disable individual items to prevent interaction.")
        source: "qrc:/demos/accordion/Disabled.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: qsTr("Borders")
        description: qsTr("Bordered container with dividers between items.")
        source: "qrc:/demos/accordion/Borders.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: qsTr("Card")
        description: qsTr("Embed the accordion inside a card without its own border.")
        source: "qrc:/demos/accordion/Card.qml"
        previewMinHeight: 300
    }
}
