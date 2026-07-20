import QtQuick

// shadcn Avatar(base-mira) —— rounded-full 头像,图片加载失败/未设时显示 fallback 首字母。
// 圆形裁剪由 RoundedImage(MultiEffect 遮罩)实现:Rectangle 的 clip 只裁矩形边界、不裁圆形。
Rectangle {
    id: control

    enum Size { Default, Sm, Lg }
    property int size: Avatar.Default
    property url source
    property string fallback: ""

    readonly property real _d: size === Avatar.Sm ? 24 : size === Avatar.Lg ? 40 : 32
    implicitWidth: _d
    implicitHeight: _d
    radius: _d / 2
    color: Theme.muted

    // fallback 首字母(图片就绪前/失败时显示,位于 muted 圆底之上)
    Text {
        anchors.centerIn: parent
        visible: img.status !== Image.Ready
        text: control.fallback
        color: Theme.mutedForeground
        font.pixelSize: Math.round(control._d * 0.4)
        font.weight: Font.Medium
    }

    // 圆形头像(radius = 半径 → 正圆)
    RoundedImage {
        id: img
        anchors.fill: parent
        source: control.source
        radius: control.radius
    }
}
