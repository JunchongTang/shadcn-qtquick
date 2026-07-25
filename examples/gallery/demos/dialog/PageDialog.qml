import QtQuick

PageScaffold {
    description: qsTr("A window overlaid on either the primary window or another dialog window.")

    ExampleCard {
        title: qsTr("Dialog")
        source: "qrc:/demos/dialog/Basic.qml"
    }

    ExampleCard {
        title: qsTr("Custom Close Button")
        description: qsTr("Replace the default close control with your own button.")
        source: "qrc:/demos/dialog/CustomCloseButton.qml"
    }

    ExampleCard {
        title: qsTr("No Close Button")
        description: qsTr("Use showCloseButton: false to hide the close button.")
        source: "qrc:/demos/dialog/NoCloseButton.qml"
    }

    ExampleCard {
        title: qsTr("Sticky Footer")
        description: qsTr("Keep actions visible while the content scrolls.")
        source: "qrc:/demos/dialog/StickyFooter.qml"
    }

    ExampleCard {
        title: qsTr("Scrollable Content")
        description: qsTr("Long content can scroll while the header stays in view.")
        source: "qrc:/demos/dialog/ScrollableContent.qml"
    }
}
