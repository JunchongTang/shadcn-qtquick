import QtQuick

PageScaffold {
    description: qsTr("Use the Empty component to display an empty state.")

    ExampleCard {
        title: qsTr("Empty")
        description: qsTr("A basic empty state with an icon, title, description and actions.")
        source: "qrc:/demos/empty/Demo.qml"
        previewMinHeight: 280
    }
    ExampleCard {
        title: qsTr("Icon")
        description: qsTr("Use the icon variant of EmptyMedia to render a rounded muted icon tile.")
        source: "qrc:/demos/empty/Icons.qml"
        previewMinHeight: 280
    }
    ExampleCard {
        title: qsTr("Outline")
        description: qsTr("Use the outline property to create a dashed-border empty state.")
        source: "qrc:/demos/empty/Outline.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: qsTr("Background")
        description: qsTr("Add a muted background to the empty state via the surface property.")
        source: "qrc:/demos/empty/Background.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: qsTr("Avatar")
        description: qsTr("Use EmptyMedia to display an avatar in the empty state.")
        source: "qrc:/demos/empty/Avatar.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: qsTr("Avatar Group")
        description: qsTr("Use EmptyMedia to display an overlapping avatar group.")
        source: "qrc:/demos/empty/AvatarGroup.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: qsTr("Input Group")
        description: qsTr("Add a search input group to EmptyContent. Approximated: no InputGroup component yet.")
        source: "qrc:/demos/empty/InputGroup.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: qsTr("Spinner")
        description: qsTr("Combine the Spinner component with the icon media for a loading state.")
        source: "qrc:/demos/empty/Spinner.qml"
        previewMinHeight: 240
    }
}
