import QtQuick

PageScaffold {
    description: qsTr("A control that allows the user to toggle between checked and not checked.")

    ExampleCard {
        title: qsTr("Switch")
        source: "qrc:/demos/switch/Demo.qml"
    }
    ExampleCard {
        title: qsTr("Description")
        description: qsTr("Pair the switch with a label and a supporting description.")
        source: "qrc:/demos/switch/Description.qml"
    }
    ExampleCard {
        title: qsTr("Choice Card")
        description: qsTr("Card-style selection where the whole card is clickable to toggle.")
        source: "qrc:/demos/switch/ChoiceCard.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: qsTr("Disabled")
        description: qsTr("Add the disabled state to prevent interaction.")
        source: "qrc:/demos/switch/Disabled.qml"
    }
    ExampleCard {
        title: qsTr("Invalid")
        description: qsTr("Use the invalid state to indicate a validation error.")
        source: "qrc:/demos/switch/Invalid.qml"
    }
    ExampleCard {
        title: qsTr("Size")
        description: qsTr("Use the size property to change the size of the switch.")
        source: "qrc:/demos/switch/Sizes.qml"
    }
}
