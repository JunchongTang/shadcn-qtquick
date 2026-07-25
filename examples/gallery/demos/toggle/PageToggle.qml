import QtQuick

PageScaffold {
    description: "A two-state button that can be either on or off."

    ExampleCard {
        title: "Toggle"
        source: "qrc:/demos/toggle/Demo.qml"
    }
    ExampleCard {
        title: "Outline"
        description: "Use variant Outline for an outline style."
        source: "qrc:/demos/toggle/Outline.qml"
    }
    ExampleCard {
        title: "With Text"
        description: "Pair an icon with a text label."
        source: "qrc:/demos/toggle/Text.qml"
    }
    ExampleCard {
        title: "Size"
        description: "Use the size property to change the size of the toggle."
        source: "qrc:/demos/toggle/Sizes.qml"
    }
    ExampleCard {
        title: "Disabled"
        description: "Add the disabled state to prevent interaction."
        source: "qrc:/demos/toggle/Disabled.qml"
    }
}
