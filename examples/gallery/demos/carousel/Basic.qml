import QtQuick
import QtQuick.Layouts
import Shadcn

// 基础 —— 5 张数字卡片,每张占满视口(basis-full)。左右圆形按钮翻页,亦可拖拽。
Item {
    id: root
    width: 300
    height: 210

    // 一张数字卡片(数字居中,近似 aspect-square)。
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
