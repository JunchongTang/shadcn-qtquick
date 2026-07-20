import QtQuick

PageScaffold {
    description: "Displays a badge or a component that looks like a badge."

    ExampleCard {
        title: "Variants"
        description: "The four visual styles: default, secondary, outline and destructive."
        source: "qrc:/demos/badge/Variants.qml"
    }
    ExampleCard {
        title: "With icon"
        description: "Badges can carry a leading Lucide icon."
        source: "qrc:/demos/badge/WithIcon.qml"
    }
    ExampleCard {
        title: "With spinner"
        description: "Render a spinner inside a badge, as a leading or trailing element."
        source: "qrc:/demos/badge/WithSpinner.qml"
    }
    ExampleCard {
        title: "Link"
        description: "Use the link variant to render a badge that looks like a link."
        source: "qrc:/demos/badge/Link.qml"
    }
    ExampleCard {
        title: "Custom colors"
        description: "Customize a badge's colors by overriding bgColor and fgColor."
        source: "qrc:/demos/badge/CustomColors.qml"
    }
}
