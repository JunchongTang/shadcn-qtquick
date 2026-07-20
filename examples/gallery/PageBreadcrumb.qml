import QtQuick

PageScaffold {
    description: "Displays the path to the current resource using a hierarchy of links."

    ExampleCard {
        title: "Breadcrumb"
        source: "qrc:/demos/breadcrumb/Demo.qml"
    }
    ExampleCard {
        title: "Basic"
        source: "qrc:/demos/breadcrumb/Basic.qml"
    }
    ExampleCard {
        title: "Custom Separator"
        source: "qrc:/demos/breadcrumb/CustomSeparator.qml"
    }
    ExampleCard {
        title: "Dropdown"
        source: "qrc:/demos/breadcrumb/Dropdown.qml"
    }
    ExampleCard {
        title: "Collapsed"
        source: "qrc:/demos/breadcrumb/Ellipsis.qml"
    }
    ExampleCard {
        title: "Dynamic (model-driven)"
        description: "Breadcrumb generated from a path array via Repeater. Click a level to jump back, or navigate deeper — the model drives the trail."
        source: "qrc:/demos/breadcrumb/Dynamic.qml"
    }
}
