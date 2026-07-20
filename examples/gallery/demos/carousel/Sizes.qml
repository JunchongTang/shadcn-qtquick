import QtQuick
import QtQuick.Layouts
import Shadcn

// 尺寸 —— basis=0.5(对标 basis-1/2):每张卡片占视口一半,同屏可见约两张。
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
