import QtQuick

PageScaffold {
    description: "Displays a card with header, content, and footer."

    ExampleCard {
        title: "Card"
        description: "A card with header (title + description), content and footer."
        source: "qrc:/demos/card/ProjectCard.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: "Small"
        description: "The compact card size (data-[size=sm])."
        source: "qrc:/demos/card/NotificationsCard.qml"
    }
    ExampleCard {
        title: "Spacing"
        description: "Control section spacing and inset via cardSpacing (--card-spacing)."
        source: "qrc:/demos/card/Spacing.qml"
        previewMinHeight: 460
    }
    ExampleCard {
        title: "Edge to Edge"
        description: "Content that goes edge to edge while staying aligned with the card inset."
        source: "qrc:/demos/card/EdgeToEdge.qml"
        previewMinHeight: 360
    }
    ExampleCard {
        title: "Image"
        description: "A card with a full-bleed image before the header."
        source: "qrc:/demos/card/Image.qml"
        previewMinHeight: 380
    }
}
