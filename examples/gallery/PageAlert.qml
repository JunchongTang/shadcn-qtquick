import QtQuick

PageScaffold {
    description: "Displays a callout for user attention."

    ExampleCard {
        title: "Basic"
        source: "qrc:/demos/alert/Basic.qml"
    }
    ExampleCard {
        title: "Destructive"
        description: "Use the destructive variant for errors and failures."
        source: "qrc:/demos/alert/Destructive.qml"
    }
    ExampleCard {
        title: "Action"
        description: "Add a trailing action such as a button."
        source: "qrc:/demos/alert/Action.qml"
    }
    ExampleCard {
        title: "Custom Colors"
        description: "Override the surface, stroke and text colors for custom palettes."
        source: "qrc:/demos/alert/Colors.qml"
    }
}
