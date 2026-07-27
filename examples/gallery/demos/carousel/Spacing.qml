import QtQuick
import QtQuick.Layouts
import Shadcn

// Spacing —— basis≈1/3 shows three at once; spacing controls the item gap (mirrors CarouselContent -ml / CarouselItem pl).
Item {
    id: root
    width: 440
    height: 200

    component NumberSlide: CarouselItem {
        property int n: 0
        basis: 1 / 3
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
                font.pixelSize: 24
                font.weight: Font.DemiBold
            }
        }
    }

    Carousel {
        anchors.centerIn: parent
        width: 340
        height: 150
        spacing: 8   // mirrors pl-2: tighter item gap

        NumberSlide { n: 1 }
        NumberSlide { n: 2 }
        NumberSlide { n: 3 }
        NumberSlide { n: 4 }
        NumberSlide { n: 5 }
    }
}
