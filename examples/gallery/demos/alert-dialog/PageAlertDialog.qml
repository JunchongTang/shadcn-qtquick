import QtQuick

PageScaffold {
    description: "A modal dialog that interrupts the user with important content and expects a response."

    ExampleCard {
        title: "Basic"
        source: "qrc:/demos/alert-dialog/Basic.qml"
    }
    ExampleCard {
        title: "Small"
        source: "qrc:/demos/alert-dialog/Small.qml"
    }
    ExampleCard {
        title: "Media"
        source: "qrc:/demos/alert-dialog/Media.qml"
    }
    ExampleCard {
        title: "Small with Media"
        source: "qrc:/demos/alert-dialog/SmallWithMedia.qml"
    }
    ExampleCard {
        title: "Destructive"
        source: "qrc:/demos/alert-dialog/Destructive.qml"
    }
}
