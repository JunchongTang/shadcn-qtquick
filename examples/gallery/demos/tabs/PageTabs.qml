import QtQuick

PageScaffold {
    description: "A set of layered sections of content—known as tab panels—displayed one at a time."

    ExampleCard {
        title: "Tabs"
        source: "qrc:/demos/tabs/Basic.qml"
        previewMinHeight: 260
    }

    ExampleCard {
        title: "Line"
        description: "Use the line variant for an underlined tab style."
        source: "qrc:/demos/tabs/Line.qml"
        previewMinHeight: 160
    }

    ExampleCard {
        title: "Vertical"
        description: "Stack the tabs vertically."
        source: "qrc:/demos/tabs/Vertical.qml"
        previewMinHeight: 180
    }

    ExampleCard {
        title: "Disabled"
        description: "Disable individual tabs."
        source: "qrc:/demos/tabs/Disabled.qml"
        previewMinHeight: 160
    }

    ExampleCard {
        title: "Icons"
        description: "Add icons to the tab triggers."
        source: "qrc:/demos/tabs/Icons.qml"
        previewMinHeight: 160
    }
}
