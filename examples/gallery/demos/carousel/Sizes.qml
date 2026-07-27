import QtQuick
import QtQuick.Layouts
import Shadcn

// Sizes —— basis=0.5 (mirrors basis-1/2): each card takes half the viewport, so about two are visible at once.
Item {
    id: root
    width: 420
    height: 210

    component NumberSlide: CarouselItem {
        property int n: 0
        basis: 0.5
        Card {
            anchors.fill: parent
            anchors.margins: 4
            Text {
                Layout.fillWidth: true
                Layout.fillHeight: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: n
                color: Theme.foreground
                font.pixelSize: 30
                font.weight: Font.DemiBold
            }
        }
    }

    Carousel {
        anchors.centerIn: parent
        width: 320
        height: 180

        NumberSlide { n: 1 }
        NumberSlide { n: 2 }
        NumberSlide { n: 3 }
        NumberSlide { n: 4 }
        NumberSlide { n: 5 }
    }
}
