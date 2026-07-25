import QtQuick

PageScaffold {
    description: "An input where the user selects a value from within a given range."

    ExampleCard {
        title: "Slider"
        source: "qrc:/demos/slider/Demo.qml"
    }
    ExampleCard {
        title: "Range"
        description: "Use two values for a range slider with two thumbs."
        source: "qrc:/demos/slider/Range.qml"
    }
    ExampleCard {
        title: "Vertical"
        description: "Use orientation Qt.Vertical for a vertical slider."
        source: "qrc:/demos/slider/Vertical.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: "Controlled"
        description: "Bind the value to display and drive it from outside the slider."
        source: "qrc:/demos/slider/Controlled.qml"
    }
    ExampleCard {
        title: "Controlled (Range)"
        description: "The official controlled example binds a range; read both thumbs via first.value and second.value."
        source: "qrc:/demos/slider/ControlledRange.qml"
    }
    ExampleCard {
        title: "Disabled"
        description: "Add the disabled state to prevent interaction."
        source: "qrc:/demos/slider/Disabled.qml"
    }
}
