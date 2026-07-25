import QtQuick

PageScaffold {
    description: "Extends the Dialog component to display content that complements the main content of the screen."

    ExampleCard {
        title: "Sheet"
        source: "qrc:/demos/sheet/Basic.qml"
    }

    ExampleCard {
        title: "Side"
        description: "Use the side property to set the edge of the screen where the sheet appears: Top, Right, Bottom, or Left."
        source: "qrc:/demos/sheet/Sides.qml"
    }

    ExampleCard {
        title: "No Close Button"
        description: "Use showCloseButton: false to hide the close button in the top-right corner."
        source: "qrc:/demos/sheet/NoCloseButton.qml"
    }
}
