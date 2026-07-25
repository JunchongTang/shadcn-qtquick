import QtQuick

PageScaffold {
    description: qsTr("A popup that displays information related to an element when the element receives keyboard focus or the mouse hovers over it.")

    ExampleCard {
        title: qsTr("Tooltip")
        source: "qrc:/demos/tooltip/Basic.qml"
    }

    ExampleCard {
        title: qsTr("Side")
        source: "qrc:/demos/tooltip/Side.qml"
    }

    ExampleCard {
        title: qsTr("With Keyboard Shortcut")
        source: "qrc:/demos/tooltip/KeyboardShortcut.qml"
    }

    ExampleCard {
        title: qsTr("Disabled Button")
        source: "qrc:/demos/tooltip/DisabledButton.qml"
    }
}
