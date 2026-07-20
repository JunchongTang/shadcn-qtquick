import QtQuick

PageScaffold {
    description: "Used to display textual user input from keyboard."

    ExampleCard {
        title: "Kbd"
        description: "Group modifier keys with KbdGroup, or combine keys with a separator."
        source: "qrc:/demos/kbd/Demo.qml"
    }
    ExampleCard {
        title: "Single"
        description: "Each Kbd renders one keyboard key: modifiers, Enter, Esc or arrows."
        source: "qrc:/demos/kbd/Single.qml"
    }
    ExampleCard {
        title: "Group"
        description: "Use KbdGroup to group keyboard keys together, inline within text."
        source: "qrc:/demos/kbd/Group.qml"
    }
    ExampleCard {
        title: "Button"
        description: "Use the Kbd component inside a Button to display a keyboard key."
        source: "qrc:/demos/kbd/Button.qml"
    }
    ExampleCard {
        title: "Tooltip"
        description: "Use the Kbd component inside a Tooltip to display a keyboard shortcut."
        source: "qrc:/demos/kbd/Tooltip.qml"
    }
}
