import QtQuick

PageScaffold {
    description: qsTr("A composable, themeable and customizable sidebar component.")

    ExampleCard {
        title: qsTr("Sidebar")
        description: qsTr("An application sidebar with a header, grouped menus (icon + label) and a footer, shown beside a simplified inset area.")
        source: "qrc:/demos/sidebar/AppSidebar.qml"
        previewMinHeight: 500
    }

    ExampleCard {
        title: qsTr("Collapsible (icon)")
        description: qsTr("A sidebar that collapses to an icon rail. Toggle with the trigger in the top bar or by clicking the rail on the sidebar's edge; collapsed items show labels on hover.")
        source: "qrc:/demos/sidebar/Collapsible.qml"
        previewMinHeight: 500
    }
}
