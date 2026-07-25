import QtQuick

PageScaffold {
    description: "Use the Empty component to display an empty state."

    ExampleCard {
        title: "Empty"
        description: "A basic empty state with an icon, title, description and actions."
        source: "qrc:/demos/empty/Demo.qml"
        previewMinHeight: 280
    }
    ExampleCard {
        title: "Icon"
        description: "Use the icon variant of EmptyMedia to render a rounded muted icon tile."
        source: "qrc:/demos/empty/Icons.qml"
        previewMinHeight: 280
    }
    ExampleCard {
        title: "Outline"
        description: "Use the outline property to create a dashed-border empty state."
        source: "qrc:/demos/empty/Outline.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: "Background"
        description: "Add a muted background to the empty state via the surface property."
        source: "qrc:/demos/empty/Background.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: "Avatar"
        description: "Use EmptyMedia to display an avatar in the empty state."
        source: "qrc:/demos/empty/Avatar.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: "Avatar Group"
        description: "Use EmptyMedia to display an overlapping avatar group."
        source: "qrc:/demos/empty/AvatarGroup.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: "Input Group"
        description: "Add a search input group to EmptyContent. Approximated: no InputGroup component yet."
        source: "qrc:/demos/empty/InputGroup.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: "Spinner"
        description: "Combine the Spinner component with the icon media for a loading state."
        source: "qrc:/demos/empty/Spinner.qml"
        previewMinHeight: 240
    }
}
