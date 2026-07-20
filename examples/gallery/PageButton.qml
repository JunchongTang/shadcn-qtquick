import QtQuick

PageScaffold {
    description: "Displays a button or a component that looks like a button. Variants, sizes, icons and states."

    ExampleCard {
        title: "Variants"
        description: "The six visual styles: default, secondary, outline, ghost, destructive and link."
        source: "qrc:/demos/button/Variants.qml"
    }
    ExampleCard {
        title: "Sizes"
        description: "From compact xs to lg."
        source: "qrc:/demos/button/Sizes.qml"
    }
    ExampleCard {
        title: "With icon"
        description: "Leading or trailing Lucide icons alongside the label."
        source: "qrc:/demos/button/WithIcon.qml"
    }
    ExampleCard {
        title: "Icon only"
        description: "Square icon buttons in the icon size family."
        source: "qrc:/demos/button/IconOnly.qml"
    }
    ExampleCard {
        title: "Disabled"
        source: "qrc:/demos/button/Disabled.qml"
    }
    ExampleCard {
        title: "Rounded"
        description: "Use the rounded property for a full pill radius."
        source: "qrc:/demos/button/Rounded.qml"
    }
    ExampleCard {
        title: "Spinner"
        description: "Set loading to show a Spinner and disable the button while working."
        source: "qrc:/demos/button/Spinner.qml"
    }
    ExampleCard {
        title: "Button Group"
        description: "Wrap adjacent buttons in a ButtonGroup so they join into a single unit."
        source: "qrc:/demos/button/ButtonGroup.qml"
    }
    ExampleCard {
        title: "As Link"
        description: "Use the link variant, or a styled button, to make a link look like a button."
        source: "qrc:/demos/button/AsLink.qml"
    }
}
