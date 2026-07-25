import QtQuick

PageScaffold {
    description: "Pagination with page navigation, next and previous links."

    ExampleCard {
        title: "Pagination"
        source: "qrc:/demos/pagination/Demo.qml"
    }
    ExampleCard {
        title: "Simple"
        description: "A simple pagination with only page numbers."
        source: "qrc:/demos/pagination/Simple.qml"
    }
    ExampleCard {
        title: "Icons Only"
        description: "Use just the previous and next buttons without page numbers. This is useful for data tables with a rows per page selector."
        source: "qrc:/demos/pagination/IconsOnly.qml"
    }
}
