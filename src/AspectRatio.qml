import QtQuick

// shadcn AspectRatio(base-mira)—— 以给定宽高比约束内容。对标官方 aspect-(--ratio)。
// ratio = 宽 / 高(默认 16/9;方形 1;竖屏 9/16)。高度由宽度按比例推导 —— 用法上给定
// 宽度(显式 width 或父级/Layout 决定),高度自动跟随。内容锚满容器(默认属性)。
//
// 圆角:radius 圆化容器背景并对内容做矩形裁剪(clip)。内容若为图片/色块,请自行设同值
// 圆角(对齐官方:AspectRatio 与其中 <img> 都带 rounded-lg),即可与背景无缝衔接。
Item {
    id: control

    property real ratio: 16 / 9           // 宽高比 = 宽 / 高
    property real radius: 0               // 圆角(圆化背景 + 裁剪内容)
    property color color: "transparent"  // 背景色(如 bg-muted)

    default property alias content: holder.data

    implicitWidth: 320
    implicitHeight: width / ratio         // 预览布局按实际宽度取高
    height: width / ratio                 // 高度随宽度按比例推导

    // 背景(bg-muted + rounded-*)
    Rectangle {
        anchors.fill: parent
        color: control.color
        radius: control.radius
    }

    // 内容区(锚满并裁剪)
    Item {
        id: holder
        anchors.fill: parent
        clip: control.radius > 0
    }
}
