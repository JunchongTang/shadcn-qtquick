import QtQuick

PageScaffold {
    description: "A window overlaid on either the primary window or another dialog window."

    ExampleCard {
        title: "Dialog"
        source: "qrc:/demos/dialog/Basic.qml"
    }

    ExampleCard {
        title: "Custom Close Button"
        description: "Replace the default close control with your own button."
        source: "qrc:/demos/dialog/CustomCloseButton.qml"
    }

    ExampleCard {
        title: "No Close Button"
        description: "Use showCloseButton: false to hide the close button."
        source: "qrc:/demos/dialog/NoCloseButton.qml"
    }

    ExampleCard {
        title: "Sticky Footer"
        description: "Keep actions visible while the content scrolls."
        source: "qrc:/demos/dialog/StickyFooter.qml"
    }

    ExampleCard {
        title: "Scrollable Content"
        description: "Long content can scroll while the header stays in view."
        source: "qrc:/demos/dialog/ScrollableContent.qml"
    }
}
