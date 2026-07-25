import QtQuick

PageScaffold {
    description: qsTr("An input where the user selects a value from within a given range.")

    ExampleCard {
        title: qsTr("Slider")
        source: "qrc:/demos/slider/Demo.qml"
    }
    ExampleCard {
        title: qsTr("Range")
        description: qsTr("Use two values for a range slider with two thumbs.")
        source: "qrc:/demos/slider/Range.qml"
    }
    ExampleCard {
        title: qsTr("Vertical")
        description: qsTr("Use orientation Qt.Vertical for a vertical slider.")
        source: "qrc:/demos/slider/Vertical.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: qsTr("Controlled")
        description: qsTr("Bind the value to display and drive it from outside the slider.")
        source: "qrc:/demos/slider/Controlled.qml"
    }
    ExampleCard {
        title: qsTr("Controlled (Range)")
        description: qsTr("The official controlled example binds a range; read both thumbs via first.value and second.value.")
        source: "qrc:/demos/slider/ControlledRange.qml"
    }
    ExampleCard {
        title: qsTr("Disabled")
        description: qsTr("Add the disabled state to prevent interaction.")
        source: "qrc:/demos/slider/Disabled.qml"
    }
}
