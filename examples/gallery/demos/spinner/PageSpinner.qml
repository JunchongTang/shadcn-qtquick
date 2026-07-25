import QtQuick

PageScaffold {
    description: "An indicator that can be used to show a loading state."

    ExampleCard {
        title: "Spinner"
        description: "The default spinner: a Loader2 icon spinning at a constant speed."
        source: "qrc:/demos/spinner/Basic.qml"
    }
    ExampleCard {
        title: "Size"
        description: "Use the size property to change the size of the spinner."
        source: "qrc:/demos/spinner/Sizes.qml"
    }
    ExampleCard {
        title: "Color"
        description: "Override the color property to recolor the spinner."
        source: "qrc:/demos/spinner/Color.qml"
    }
    ExampleCard {
        title: "Button"
        description: "Add a spinner to a button to indicate a loading state."
        source: "qrc:/demos/spinner/Button.qml"
    }
    ExampleCard {
        title: "With text"
        description: "Pair a spinner with a title inside a muted item to show progress."
        source: "qrc:/demos/spinner/Demo.qml"
        previewMinHeight: 200
    }
    ExampleCard {
        title: "Badge"
        description: "Add a spinner to a badge to indicate a loading state."
        source: "qrc:/demos/spinner/Badge.qml"
    }
    ExampleCard {
        title: "Empty"
        description: "Use a spinner as the media of an empty state while loading."
        source: "qrc:/demos/spinner/Empty.qml"
        previewMinHeight: 240
    }
}
