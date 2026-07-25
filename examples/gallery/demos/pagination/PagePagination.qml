import QtQuick

PageScaffold {
    description: qsTr("Pagination with page navigation, next and previous links.")

    ExampleCard {
        title: qsTr("Pagination")
        source: "qrc:/demos/pagination/Demo.qml"
    }
    ExampleCard {
        title: qsTr("Simple")
        description: qsTr("A simple pagination with only page numbers.")
        source: "qrc:/demos/pagination/Simple.qml"
    }
    ExampleCard {
        title: qsTr("Icons Only")
        description: qsTr("Use just the previous and next buttons without page numbers. This is useful for data tables with a rows per page selector.")
        source: "qrc:/demos/pagination/IconsOnly.qml"
    }
}
