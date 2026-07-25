import QtQuick

PageScaffold {
    description: qsTr("Displays a badge or a component that looks like a badge.")

    ExampleCard {
        title: qsTr("Variants")
        description: qsTr("The four visual styles: default, secondary, outline and destructive.")
        source: "qrc:/demos/badge/Variants.qml"
    }
    ExampleCard {
        title: qsTr("With icon")
        description: qsTr("Badges can carry a leading Lucide icon.")
        source: "qrc:/demos/badge/WithIcon.qml"
    }
    ExampleCard {
        title: qsTr("With spinner")
        description: qsTr("Render a spinner inside a badge, as a leading or trailing element.")
        source: "qrc:/demos/badge/WithSpinner.qml"
    }
    ExampleCard {
        title: qsTr("Link")
        description: qsTr("Use the link variant to render a badge that looks like a link.")
        source: "qrc:/demos/badge/Link.qml"
    }
    ExampleCard {
        title: qsTr("Custom colors")
        description: qsTr("Customize a badge's colors by overriding bgColor and fgColor.")
        source: "qrc:/demos/badge/CustomColors.qml"
    }
}
