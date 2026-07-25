import QtQuick

PageScaffold {
    description: qsTr("Displays a callout for user attention.")

    ExampleCard {
        title: qsTr("Basic")
        source: "qrc:/demos/alert/Basic.qml"
    }
    ExampleCard {
        title: qsTr("Destructive")
        description: qsTr("Use the destructive variant for errors and failures.")
        source: "qrc:/demos/alert/Destructive.qml"
    }
    ExampleCard {
        title: qsTr("Action")
        description: qsTr("Add a trailing action such as a button.")
        source: "qrc:/demos/alert/Action.qml"
    }
    ExampleCard {
        title: qsTr("Custom Colors")
        description: qsTr("Override the surface, stroke and text colors for custom palettes.")
        source: "qrc:/demos/alert/Colors.qml"
    }
}
