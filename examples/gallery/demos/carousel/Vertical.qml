import QtQuick
import QtQuick.Layouts
import Shadcn

// Vertical —— orientation=Vertical, basis=0.5: two cards stacked on screen, nav buttons above/below (chevrons pointing up/down).
Item {
    id: root
    width: 260
    height: 360

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
        orientation: Carousel.Vertical
        width: 200
        height: 270

        NumberSlide { n: 1 }
        NumberSlide { n: 2 }
        NumberSlide { n: 3 }
        NumberSlide { n: 4 }
        NumberSlide { n: 5 }
    }
}
