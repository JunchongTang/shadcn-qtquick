import QtQuick

PageScaffold {
    description: "Displays rich content in a portal, triggered by a button."

    ExampleCard {
        title: "Popover"
        source: "qrc:/demos/popover/Demo.qml"
    }

    ExampleCard {
        title: "Basic"
        description: "A simple popover with a header, title, and description."
        source: "qrc:/demos/popover/Basic.qml"
    }

    ExampleCard {
        title: "Align"
        description: "Use the align property on Popover to control the horizontal alignment."
        source: "qrc:/demos/popover/Alignments.qml"
    }

    ExampleCard {
        title: "With Form"
        description: "A popover with form fields inside."
        source: "qrc:/demos/popover/Form.qml"
    }
}
