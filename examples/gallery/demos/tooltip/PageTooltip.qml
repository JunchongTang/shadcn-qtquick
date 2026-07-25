import QtQuick

PageScaffold {
    description: "A popup that displays information related to an element when the element receives keyboard focus or the mouse hovers over it."

    ExampleCard {
        title: "Tooltip"
        source: "qrc:/demos/tooltip/Basic.qml"
    }

    ExampleCard {
        title: "Side"
        source: "qrc:/demos/tooltip/Side.qml"
    }

    ExampleCard {
        title: "With Keyboard Shortcut"
        source: "qrc:/demos/tooltip/KeyboardShortcut.qml"
    }

    ExampleCard {
        title: "Disabled Button"
        source: "qrc:/demos/tooltip/DisabledButton.qml"
    }
}
