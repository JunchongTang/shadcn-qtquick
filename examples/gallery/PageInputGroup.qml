import QtQuick

PageScaffold {
    description: "Add addons, buttons, and helper content to inputs — all sharing one bordered, focus-ringed group."

    ExampleCard {
        title: "Basic"
        description: "A prefix icon and a suffix result count in a single group."
        source: "qrc:/demos/input-group/Basic.qml"
    }
    ExampleCard {
        title: "Inline Start"
        description: "Position an addon at the start of the input (the default alignment)."
        source: "qrc:/demos/input-group/InlineStart.qml"
    }
    ExampleCard {
        title: "Inline End"
        description: "Position an addon at the end of the input."
        source: "qrc:/demos/input-group/InlineEnd.qml"
    }
    ExampleCard {
        title: "Block Start"
        description: "Position an addon above the input or textarea (vertical layout)."
        source: "qrc:/demos/input-group/BlockStart.qml"
    }
    ExampleCard {
        title: "Block End"
        description: "Position an addon below the input or textarea (vertical layout)."
        source: "qrc:/demos/input-group/BlockEnd.qml"
    }
    ExampleCard {
        title: "Icon"
        description: "Prefix and suffix icons in various combinations."
        source: "qrc:/demos/input-group/Icon.qml"
    }
    ExampleCard {
        title: "Text"
        description: "Text addons for currencies, protocols and domains."
        source: "qrc:/demos/input-group/Text.qml"
    }
    ExampleCard {
        title: "Button"
        description: "Icon and text buttons embedded inside addons."
        source: "qrc:/demos/input-group/Button.qml"
    }
    ExampleCard {
        title: "Kbd"
        description: "Surface a keyboard shortcut hint alongside the input."
        source: "qrc:/demos/input-group/Kbd.qml"
    }
    ExampleCard {
        title: "Spinner"
        description: "Show a loading spinner as an addon while work is in progress."
        source: "qrc:/demos/input-group/Spinner.qml"
    }
    ExampleCard {
        title: "Textarea"
        description: "A code editor shell with a header toolbar and a footer status bar."
        source: "qrc:/demos/input-group/Textarea.qml"
    }
}
