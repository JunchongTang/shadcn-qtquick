import QtQuick

PageScaffold {
    description: qsTr("A two-state button that can be either on or off.")

    ExampleCard {
        title: qsTr("Toggle")
        source: "qrc:/demos/toggle/Demo.qml"
    }
    ExampleCard {
        title: qsTr("Outline")
        description: qsTr("Use variant Outline for an outline style.")
        source: "qrc:/demos/toggle/Outline.qml"
    }
    ExampleCard {
        title: qsTr("With Text")
        description: qsTr("Pair an icon with a text label.")
        source: "qrc:/demos/toggle/Text.qml"
    }
    ExampleCard {
        title: qsTr("Size")
        description: qsTr("Use the size property to change the size of the toggle.")
        source: "qrc:/demos/toggle/Sizes.qml"
    }
    ExampleCard {
        title: qsTr("Disabled")
        description: qsTr("Add the disabled state to prevent interaction.")
        source: "qrc:/demos/toggle/Disabled.qml"
    }
}
