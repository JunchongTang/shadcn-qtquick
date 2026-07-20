import QtQuick

PageScaffold {
    description: "For sighted users to preview content available behind a link."

    ExampleCard {
        title: "Hover Card"
        description: "Hover over the trigger to preview a user profile card."
        source: "qrc:/demos/hover-card/Demo.qml"
        previewMinHeight: 240
    }

    ExampleCard {
        title: "Sides"
        description: "Use the side property on HoverCard to control placement relative to the trigger."
        source: "qrc:/demos/hover-card/Sides.qml"
        previewMinHeight: 260
    }
}
