import QtQuick

PageScaffold {
    description: qsTr("A carousel with motion and swipe built using ListView.")

    ExampleCard {
        title: qsTr("Carousel")
        source: "qrc:/demos/carousel/Basic.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: qsTr("Sizes")
        description: qsTr("Use the basis property on CarouselItem to set the size of the items.")
        source: "qrc:/demos/carousel/Sizes.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: qsTr("Spacing")
        description: qsTr("Use the spacing property on Carousel to set the gap between items.")
        source: "qrc:/demos/carousel/Spacing.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: qsTr("Orientation")
        description: qsTr("Set orientation to Carousel.Vertical to scroll the carousel vertically.")
        source: "qrc:/demos/carousel/Vertical.qml"
        previewMinHeight: 380
    }
}
