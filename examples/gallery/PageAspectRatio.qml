import QtQuick

PageScaffold {
    description: "Displays content within a desired ratio."

    ExampleCard {
        title: "Aspect Ratio"
        description: "A 16:9 container (ratio={16/9}) whose content fills the ratio."
        source: "qrc:/demos/aspect-ratio/Demo.qml"
    }
    ExampleCard {
        title: "Square"
        description: "A square aspect ratio using ratio={1/1}."
        source: "qrc:/demos/aspect-ratio/Square.qml"
    }
    ExampleCard {
        title: "Portrait"
        description: "A portrait aspect ratio using ratio={9/16}."
        source: "qrc:/demos/aspect-ratio/Portrait.qml"
        previewMinHeight: 320
    }
}
