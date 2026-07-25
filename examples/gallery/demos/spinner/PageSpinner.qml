import QtQuick

PageScaffold {
    description: qsTr("An indicator that can be used to show a loading state.")

    ExampleCard {
        title: qsTr("Spinner")
        description: qsTr("The default spinner: a Loader2 icon spinning at a constant speed.")
        source: "qrc:/demos/spinner/Basic.qml"
    }
    ExampleCard {
        title: qsTr("Size")
        description: qsTr("Use the size property to change the size of the spinner.")
        source: "qrc:/demos/spinner/Sizes.qml"
    }
    ExampleCard {
        title: qsTr("Color")
        description: qsTr("Override the color property to recolor the spinner.")
        source: "qrc:/demos/spinner/Color.qml"
    }
    ExampleCard {
        title: qsTr("Button")
        description: qsTr("Add a spinner to a button to indicate a loading state.")
        source: "qrc:/demos/spinner/Button.qml"
    }
    ExampleCard {
        title: qsTr("With text")
        description: qsTr("Pair a spinner with a title inside a muted item to show progress.")
        source: "qrc:/demos/spinner/Demo.qml"
        previewMinHeight: 200
    }
    ExampleCard {
        title: qsTr("Badge")
        description: qsTr("Add a spinner to a badge to indicate a loading state.")
        source: "qrc:/demos/spinner/Badge.qml"
    }
    ExampleCard {
        title: qsTr("Empty")
        description: qsTr("Use a spinner as the media of an empty state while loading.")
        source: "qrc:/demos/spinner/Empty.qml"
        previewMinHeight: 240
    }
}
