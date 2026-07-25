import QtQuick

PageScaffold {
    description: qsTr("Used to display textual user input from keyboard.")

    ExampleCard {
        title: qsTr("Kbd")
        description: qsTr("Group modifier keys with KbdGroup, or combine keys with a separator.")
        source: "qrc:/demos/kbd/Demo.qml"
    }
    ExampleCard {
        title: qsTr("Single")
        description: qsTr("Each Kbd renders one keyboard key: modifiers, Enter, Esc or arrows.")
        source: "qrc:/demos/kbd/Single.qml"
    }
    ExampleCard {
        title: qsTr("Group")
        description: qsTr("Use KbdGroup to group keyboard keys together, inline within text.")
        source: "qrc:/demos/kbd/Group.qml"
    }
    ExampleCard {
        title: qsTr("Button")
        description: qsTr("Use the Kbd component inside a Button to display a keyboard key.")
        source: "qrc:/demos/kbd/Button.qml"
    }
    ExampleCard {
        title: qsTr("Tooltip")
        description: qsTr("Use the Kbd component inside a Tooltip to display a keyboard shortcut.")
        source: "qrc:/demos/kbd/Tooltip.qml"
    }
}
