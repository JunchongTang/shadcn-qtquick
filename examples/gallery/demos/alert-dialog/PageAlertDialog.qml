import QtQuick

PageScaffold {
    description: qsTr("A modal dialog that interrupts the user with important content and expects a response.")

    ExampleCard {
        title: qsTr("Basic")
        source: "qrc:/demos/alert-dialog/Basic.qml"
    }
    ExampleCard {
        title: qsTr("Small")
        source: "qrc:/demos/alert-dialog/Small.qml"
    }
    ExampleCard {
        title: qsTr("Media")
        source: "qrc:/demos/alert-dialog/Media.qml"
    }
    ExampleCard {
        title: qsTr("Small with Media")
        source: "qrc:/demos/alert-dialog/SmallWithMedia.qml"
    }
    ExampleCard {
        title: qsTr("Destructive")
        source: "qrc:/demos/alert-dialog/Destructive.qml"
    }
}
