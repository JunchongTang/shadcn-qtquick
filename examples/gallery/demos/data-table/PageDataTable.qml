import QtQuick

PageScaffold {
    description: qsTr("Powerful table and datagrids built by composing the Table, Checkbox, Input, dropdown menu, Badge and Pagination components — filtering, sorting, column visibility, row selection, row actions and pagination.")

    ExampleCard {
        title: qsTr("Data Table")
        description: qsTr("A full interactive payments table: filter emails, toggle columns, sort by email, select rows, per-row actions and pagination.")
        source: "qrc:/demos/data-table/Demo.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Basic")
        description: qsTr("A basic table with formatted cells: capitalized status, lowercase email and a right-aligned currency amount.")
        source: "qrc:/demos/data-table/Basic.qml"
        previewMinHeight: 320
    }
    ExampleCard {
        title: qsTr("Row Selection")
        description: qsTr("Select rows with a header select-all checkbox and per-row checkboxes; selected rows are highlighted, with a selection count below.")
        source: "qrc:/demos/data-table/RowSelection.qml"
        previewMinHeight: 360
    }
    ExampleCard {
        title: qsTr("Sorting")
        description: qsTr("Make a column sortable by using a ghost button in its header; the trailing arrow reflects ascending or descending order.")
        source: "qrc:/demos/data-table/Sorting.qml"
        previewMinHeight: 320
    }
    ExampleCard {
        title: qsTr("Pagination")
        description: qsTr("Paginate rows into fixed-size pages using the Pagination component with a row range indicator.")
        source: "qrc:/demos/data-table/WithPagination.qml"
        previewMinHeight: 340
    }
}
