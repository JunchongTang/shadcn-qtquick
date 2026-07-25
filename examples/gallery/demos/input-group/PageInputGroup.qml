import QtQuick

PageScaffold {
    description: qsTr("Add addons, buttons, and helper content to inputs — all sharing one bordered, focus-ringed group.")

    ExampleCard {
        title: qsTr("Basic")
        description: qsTr("A prefix icon and a suffix result count in a single group.")
        source: "qrc:/demos/input-group/Basic.qml"
    }
    ExampleCard {
        title: qsTr("Inline Start")
        description: qsTr("Position an addon at the start of the input (the default alignment).")
        source: "qrc:/demos/input-group/InlineStart.qml"
    }
    ExampleCard {
        title: qsTr("Inline End")
        description: qsTr("Position an addon at the end of the input.")
        source: "qrc:/demos/input-group/InlineEnd.qml"
    }
    ExampleCard {
        title: qsTr("Block Start")
        description: qsTr("Position an addon above the input or textarea (vertical layout).")
        source: "qrc:/demos/input-group/BlockStart.qml"
    }
    ExampleCard {
        title: qsTr("Block End")
        description: qsTr("Position an addon below the input or textarea (vertical layout).")
        source: "qrc:/demos/input-group/BlockEnd.qml"
    }
    ExampleCard {
        title: qsTr("Icon")
        description: qsTr("Prefix and suffix icons in various combinations.")
        source: "qrc:/demos/input-group/Icon.qml"
    }
    ExampleCard {
        title: qsTr("Text")
        description: qsTr("Text addons for currencies, protocols and domains.")
        source: "qrc:/demos/input-group/Text.qml"
    }
    ExampleCard {
        title: qsTr("Button")
        description: qsTr("Icon and text buttons embedded inside addons.")
        source: "qrc:/demos/input-group/Button.qml"
    }
    ExampleCard {
        title: qsTr("Kbd")
        description: qsTr("Surface a keyboard shortcut hint alongside the input.")
        source: "qrc:/demos/input-group/Kbd.qml"
    }
    ExampleCard {
        title: qsTr("Spinner")
        description: qsTr("Show a loading spinner as an addon while work is in progress.")
        source: "qrc:/demos/input-group/Spinner.qml"
    }
    ExampleCard {
        title: qsTr("Textarea")
        description: qsTr("A code editor shell with a header toolbar and a footer status bar.")
        source: "qrc:/demos/input-group/Textarea.qml"
    }
}
