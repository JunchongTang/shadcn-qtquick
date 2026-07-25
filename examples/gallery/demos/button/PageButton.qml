import QtQuick

PageScaffold {
    description: qsTr("Displays a button or a component that looks like a button. Variants, sizes, icons and states.")

    ExampleCard {
        title: qsTr("Variants")
        description: qsTr("The six visual styles: default, secondary, outline, ghost, destructive and link.")
        source: "qrc:/demos/button/Variants.qml"
    }
    ExampleCard {
        title: qsTr("Sizes")
        description: qsTr("From compact xs to lg.")
        source: "qrc:/demos/button/Sizes.qml"
    }
    ExampleCard {
        title: qsTr("With icon")
        description: qsTr("Leading or trailing Lucide icons alongside the label.")
        source: "qrc:/demos/button/WithIcon.qml"
    }
    ExampleCard {
        title: qsTr("Icon only")
        description: qsTr("Square icon buttons in the icon size family.")
        source: "qrc:/demos/button/IconOnly.qml"
    }
    ExampleCard {
        title: qsTr("Disabled")
        source: "qrc:/demos/button/Disabled.qml"
    }
    ExampleCard {
        title: qsTr("Rounded")
        description: qsTr("Use the rounded property for a full pill radius.")
        source: "qrc:/demos/button/Rounded.qml"
    }
    ExampleCard {
        title: qsTr("Spinner")
        description: qsTr("Set loading to show a Spinner and disable the button while working.")
        source: "qrc:/demos/button/Spinner.qml"
    }
    ExampleCard {
        title: qsTr("Button Group")
        description: qsTr("Wrap adjacent buttons in a ButtonGroup so they join into a single unit.")
        source: "qrc:/demos/button/ButtonGroup.qml"
    }
    ExampleCard {
        title: qsTr("As Link")
        description: qsTr("Use the link variant, or a styled button, to make a link look like a button.")
        source: "qrc:/demos/button/AsLink.qml"
    }
}
