import QtQuick

PageScaffold {
    description: qsTr("A collection of links for navigating websites.")

    ExampleCard {
        title: qsTr("Navigation Menu")
        description: qsTr("Hover or click a trigger to reveal its dropdown panel of links; plain items are directly clickable.")
        source: "qrc:/demos/navigation-menu/Basic.qml"
        previewMinHeight: 320
    }
}
