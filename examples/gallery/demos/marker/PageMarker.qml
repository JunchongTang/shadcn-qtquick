import QtQuick

PageScaffold {
    description: qsTr("Displays an inline status, system note, bordered row, or labeled separator in a conversation.")

    ExampleCard {
        title: qsTr("Marker")
        description: qsTr("Inline conversation markers such as status updates, system notes, bordered rows, and labeled separators.")
        source: "qrc:/demos/marker/Demo.qml"
        previewMinHeight: 300
    }
    ExampleCard {
        title: qsTr("Variants")
        description: qsTr("Use variant to switch between an inline marker, bordered row, and labeled separator.")
        source: "qrc:/demos/marker/Variants.qml"
    }
    ExampleCard {
        title: qsTr("Status")
        description: qsTr("Set role=\"status\" and include a Spinner for streaming or in-progress markers so updates are announced.")
        source: "qrc:/demos/marker/Status.qml"
    }
    ExampleCard {
        title: qsTr("Shimmer")
        description: qsTr("Add the shimmer utility to MarkerContent for an animated streaming-text effect (approximated with an opacity pulse).")
        source: "qrc:/demos/marker/Shimmer.qml"
    }
    ExampleCard {
        title: qsTr("Separator")
        description: qsTr("Use the separator variant for labeled dividers, such as dates or section breaks, in a conversation.")
        source: "qrc:/demos/marker/Separator.qml"
    }
    ExampleCard {
        title: qsTr("Border")
        description: qsTr("Use the border variant for status rows that keep the default alignment while separating the next row.")
        source: "qrc:/demos/marker/Border.qml"
    }
    ExampleCard {
        title: qsTr("With Icon")
        description: qsTr("Use MarkerIcon to render an icon alongside the content. Use flex-col to stack the icon above the content.")
        source: "qrc:/demos/marker/WithIcon.qml"
        previewMinHeight: 280
    }
    ExampleCard {
        title: qsTr("Links and Buttons")
        description: qsTr("Turn a marker into a link or button with the render prop on Marker.")
        source: "qrc:/demos/marker/LinksAndButtons.qml"
    }
}
