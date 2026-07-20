import QtQuick

PageScaffold {
    description: "A responsive table component."

    ExampleCard {
        title: "Table"
        description: "A list of invoices with a caption and a totals footer."
        source: "qrc:/demos/table/Demo.qml"
        previewMinHeight: 380
    }
    ExampleCard {
        title: "Selection"
        description: "Select rows with a checkbox; selected rows are highlighted."
        source: "qrc:/demos/table/Selection.qml"
        previewMinHeight: 280
    }
    ExampleCard {
        title: "Actions"
        description: "Show per-row actions using a dropdown menu."
        source: "qrc:/demos/table/Actions.qml"
        previewMinHeight: 240
    }
}
