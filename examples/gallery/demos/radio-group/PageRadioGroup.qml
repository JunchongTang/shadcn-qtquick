import QtQuick

PageScaffold {
    description: "A set of checkable buttons—known as radio buttons—where no more than one can be checked at a time."

    ExampleCard {
        title: "Radio Group"
        source: "qrc:/demos/radio-group/Demo.qml"
    }
    ExampleCard {
        title: "Description"
        description: "Pair each option with a supporting description."
        source: "qrc:/demos/radio-group/Description.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: "Choice Card"
        description: "Card-style selection where the whole card is clickable."
        source: "qrc:/demos/radio-group/ChoiceCard.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: "Fieldset"
        description: "Group options under a legend and description."
        source: "qrc:/demos/radio-group/Fieldset.qml"
        previewMinHeight: 220
    }
    ExampleCard {
        title: "Disabled"
        source: "qrc:/demos/radio-group/Disabled.qml"
    }
    ExampleCard {
        title: "Invalid"
        description: "Use the invalid state to indicate a validation error."
        source: "qrc:/demos/radio-group/Invalid.qml"
        previewMinHeight: 220
    }
}
