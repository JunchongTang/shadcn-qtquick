import QtQuick

PageScaffold {
    description: "A control that allows the user to toggle between checked and not checked."

    ExampleCard {
        title: "Switch"
        source: "qrc:/demos/switch/Demo.qml"
    }
    ExampleCard {
        title: "Description"
        description: "Pair the switch with a label and a supporting description."
        source: "qrc:/demos/switch/Description.qml"
    }
    ExampleCard {
        title: "Choice Card"
        description: "Card-style selection where the whole card is clickable to toggle."
        source: "qrc:/demos/switch/ChoiceCard.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: "Disabled"
        description: "Add the disabled state to prevent interaction."
        source: "qrc:/demos/switch/Disabled.qml"
    }
    ExampleCard {
        title: "Invalid"
        description: "Use the invalid state to indicate a validation error."
        source: "qrc:/demos/switch/Invalid.qml"
    }
    ExampleCard {
        title: "Size"
        description: "Use the size property to change the size of the switch."
        source: "qrc:/demos/switch/Sizes.qml"
    }
}
