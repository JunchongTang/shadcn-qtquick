import QtQuick

PageScaffold {
    description: qsTr("Displays a card with header, content, and footer.")

    ExampleCard {
        title: qsTr("Card")
        description: qsTr("A card with header (title + description), content and footer.")
        source: "qrc:/demos/card/ProjectCard.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: qsTr("Small")
        description: qsTr("The compact card size (data-[size=sm]).")
        source: "qrc:/demos/card/NotificationsCard.qml"
    }
    ExampleCard {
        title: qsTr("Spacing")
        description: qsTr("Control section spacing and inset via cardSpacing (--card-spacing).")
        source: "qrc:/demos/card/Spacing.qml"
        previewMinHeight: 460
    }
    ExampleCard {
        title: qsTr("Edge to Edge")
        description: qsTr("Content that goes edge to edge while staying aligned with the card inset.")
        source: "qrc:/demos/card/EdgeToEdge.qml"
        previewMinHeight: 360
    }
    ExampleCard {
        title: qsTr("Image")
        description: qsTr("A card with a full-bleed image before the header.")
        source: "qrc:/demos/card/Image.qml"
        previewMinHeight: 380
    }
}
