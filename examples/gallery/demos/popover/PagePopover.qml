import QtQuick

PageScaffold {
    description: qsTr("Displays rich content in a portal, triggered by a button.")

    ExampleCard {
        title: qsTr("Popover")
        source: "qrc:/demos/popover/Demo.qml"
    }

    ExampleCard {
        title: qsTr("Basic")
        description: qsTr("A simple popover with a header, title, and description.")
        source: "qrc:/demos/popover/Basic.qml"
    }

    ExampleCard {
        title: qsTr("Align")
        description: qsTr("Use the align property on Popover to control the horizontal alignment.")
        source: "qrc:/demos/popover/Alignments.qml"
    }

    ExampleCard {
        title: qsTr("With Form")
        description: qsTr("A popover with form fields inside.")
        source: "qrc:/demos/popover/Form.qml"
    }
}
