import QtQuick

PageScaffold {
    description: qsTr("A responsive table component.")

    ExampleCard {
        title: qsTr("Table")
        description: qsTr("A list of invoices with a caption and a totals footer.")
        source: "qrc:/demos/table/Demo.qml"
        previewMinHeight: 380
    }
    ExampleCard {
        title: qsTr("Selection")
        description: qsTr("Select rows with a checkbox; selected rows are highlighted.")
        source: "qrc:/demos/table/Selection.qml"
        previewMinHeight: 280
    }
    ExampleCard {
        title: qsTr("Actions")
        description: qsTr("Show per-row actions using a dropdown menu.")
        source: "qrc:/demos/table/Actions.qml"
        previewMinHeight: 240
    }
}
