import QtQuick

PageScaffold {
    description: qsTr("Displays the path to the current resource using a hierarchy of links.")

    ExampleCard {
        title: qsTr("Breadcrumb")
        source: "qrc:/demos/breadcrumb/Demo.qml"
    }
    ExampleCard {
        title: qsTr("Basic")
        source: "qrc:/demos/breadcrumb/Basic.qml"
    }
    ExampleCard {
        title: qsTr("Custom Separator")
        source: "qrc:/demos/breadcrumb/CustomSeparator.qml"
    }
    ExampleCard {
        title: qsTr("Dropdown")
        source: "qrc:/demos/breadcrumb/Dropdown.qml"
    }
    ExampleCard {
        title: qsTr("Collapsed")
        source: "qrc:/demos/breadcrumb/Ellipsis.qml"
    }
    ExampleCard {
        title: qsTr("Dynamic (model-driven)")
        description: qsTr("Breadcrumb generated from a path array via Repeater. Click a level to jump back, or navigate deeper — the model drives the trail.")
        source: "qrc:/demos/breadcrumb/Dynamic.qml"
    }
}
