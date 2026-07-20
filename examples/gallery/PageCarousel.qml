import QtQuick

PageScaffold {
    description: "A carousel with motion and swipe built using ListView."

    ExampleCard {
        title: "Carousel"
        source: "qrc:/demos/carousel/Basic.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: "Sizes"
        description: "Use the basis property on CarouselItem to set the size of the items."
        source: "qrc:/demos/carousel/Sizes.qml"
        previewMinHeight: 260
    }
    ExampleCard {
        title: "Spacing"
        description: "Use the spacing property on Carousel to set the gap between items."
        source: "qrc:/demos/carousel/Spacing.qml"
        previewMinHeight: 240
    }
    ExampleCard {
        title: "Orientation"
        description: "Set orientation to Carousel.Vertical to scroll the carousel vertically."
        source: "qrc:/demos/carousel/Vertical.qml"
        previewMinHeight: 380
    }
}
