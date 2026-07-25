import QtQuick

PageScaffold {
    description: qsTr("A set of two-state buttons that can be toggled on or off.")

    ExampleCard {
        title: qsTr("Toggle Group")
        source: "qrc:/demos/toggle-group/Demo.qml"
    }
    ExampleCard {
        title: qsTr("Outline")
        description: qsTr("Use variant Outline for an outline style.")
        source: "qrc:/demos/toggle-group/Outline.qml"
    }
    ExampleCard {
        title: qsTr("Size")
        description: qsTr("Use the size property to change the size of the toggle group.")
        source: "qrc:/demos/toggle-group/Sizes.qml"
    }
    ExampleCard {
        title: qsTr("Spacing")
        description: qsTr("Use spacing to add spacing between toggle group items.")
        source: "qrc:/demos/toggle-group/Spacing.qml"
    }
    ExampleCard {
        title: qsTr("Vertical")
        description: qsTr("Use orientation Vertical for vertical toggle groups.")
        source: "qrc:/demos/toggle-group/Vertical.qml"
    }
    ExampleCard {
        title: qsTr("Disabled")
        description: qsTr("Add the disabled state to prevent interaction.")
        source: "qrc:/demos/toggle-group/Disabled.qml"
    }
}
