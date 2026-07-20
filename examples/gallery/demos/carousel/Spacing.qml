import QtQuick
import QtQuick.Layouts
import Shadcn

// 间距 —— basis≈1/3 三张同屏,spacing 控制条目间隔(对标 CarouselContent -ml / CarouselItem pl)。
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
        spacing: 8   // 对标 pl-2:更紧凑的条目间隔

        NumberSlide { n: 1 }
        NumberSlide { n: 2 }
        NumberSlide { n: 3 }
        NumberSlide { n: 4 }
        NumberSlide { n: 5 }
    }
}
