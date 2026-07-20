import QtQuick
import QtQuick.Layouts

// shadcn Card(base-mira) —— ring-1 ring-foreground/10 + rounded-lg + bg-card。
// 布局:py 与区块 px 都等于 --card-spacing(default 16 / sm 12),区块间距同值 →
// 等价于对内容列施加统一内边距 + 等距垂直间隔。子项用 CardHeader/CardContent/CardFooter,
// 也可直接放任意内容。full-bleed 图片等边缘特例后续再补。
Item {
    id: control

    enum Size { Default, Small }
    property int size: Card.Default

    // --card-spacing: default → spacing(4)=16;sm → spacing(3)=12。
    // 可写:赋值即覆盖(对标官方任意 [--card-spacing:--spacing(n)]);不赋值时随 size 派生。
    property real cardSpacing: size === Card.Small ? Theme.space3 : Theme.space4

    default property alias content: col.data

    implicitWidth: col.implicitWidth + cardSpacing * 2
    implicitHeight: col.implicitHeight + cardSpacing * 2

    Rectangle {
        anchors.fill: parent
        color: Theme.card
        radius: Theme.radiusLg
        // mira 用 1px 前景色描边(ring-1 ring-foreground/10)而非普通 border。
        border.width: Theme.overlayRingWidth
        border.color: Theme.overlayRing
    }

    ColumnLayout {
        id: col
        anchors.fill: parent
        anchors.margins: control.cardSpacing
        spacing: control.cardSpacing
    }
}
