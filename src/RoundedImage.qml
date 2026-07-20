import QtQuick
import QtQuick.Effects

// 按圆角/圆形真正裁剪的图片。
// 说明:Image/Rectangle 的 clip 只按矩形边界裁剪,不会按 radius 裁出圆角;
// 故用离屏图层 + MultiEffect 圆角遮罩来实现真正的圆角(radius = 宽/2 即为圆形)。
Item {
    id: root

    property url source
    property real radius: 0
    property int fillMode: Image.PreserveAspectCrop
    readonly property alias status: img.status

    // 源图:离屏渲染,不直接显示。
    Image {
        id: img
        anchors.fill: parent
        source: root.source
        fillMode: root.fillMode
        smooth: true
        mipmap: true
        visible: false
        layer.enabled: true
    }

    // 圆角遮罩源:圆角内不透明、圆角外透明,仅作纹理不显示。
    Item {
        id: mask
        anchors.fill: parent
        layer.enabled: true
        visible: false
        Rectangle {
            anchors.fill: parent
            radius: root.radius
            antialiasing: true
        }
    }

    // 按遮罩输出圆角图片。
    MultiEffect {
        anchors.fill: img
        source: img
        maskEnabled: true
        maskSource: mask
        visible: img.status === Image.Ready
    }
}
