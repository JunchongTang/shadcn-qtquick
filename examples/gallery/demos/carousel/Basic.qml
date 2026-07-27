import QtQuick
import QtQuick.Layouts
import Shadcn

// Basic —— 5 number cards, each filling the viewport (basis-full). Round prev/next buttons page through them; dragging also works.
Item {
    id: root
    width: 300
    height: 210

    // A single number card (number centered, roughly aspect-square).
    component NumberSlide: CarouselItem {
        property int n: 0
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
                font.pixelSize: 40
                font.weight: Font.DemiBold
            }
        }
    }

    Carousel {
        anchors.centerIn: parent
        width: 200
        height: 200

        NumberSlide { n: 1 }
        NumberSlide { n: 2 }
        NumberSlide { n: 3 }
        NumberSlide { n: 4 }
        NumberSlide { n: 5 }
    }
}
