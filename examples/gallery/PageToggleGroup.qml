import QtQuick

PageScaffold {
    description: "A set of two-state buttons that can be toggled on or off."

    ExampleCard {
        title: "Toggle Group"
        source: "qrc:/demos/toggle-group/Demo.qml"
    }
    ExampleCard {
        title: "Outline"
        description: "Use variant Outline for an outline style."
        source: "qrc:/demos/toggle-group/Outline.qml"
    }
    ExampleCard {
        title: "Size"
        description: "Use the size property to change the size of the toggle group."
        source: "qrc:/demos/toggle-group/Sizes.qml"
    }
    ExampleCard {
        title: "Spacing"
        description: "Use spacing to add spacing between toggle group items."
        source: "qrc:/demos/toggle-group/Spacing.qml"
    }
    ExampleCard {
        title: "Vertical"
        description: "Use orientation Vertical for vertical toggle groups."
        source: "qrc:/demos/toggle-group/Vertical.qml"
    }
    ExampleCard {
        title: "Disabled"
        description: "Add the disabled state to prevent interaction."
        source: "qrc:/demos/toggle-group/Disabled.qml"
    }
}
