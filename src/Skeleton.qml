import QtQuick

// shadcn Skeleton(base-mira) —— bg-muted rounded-md + 呼吸动画(animate-pulse)。
Rectangle {
    color: Theme.muted
    radius: Theme.radiusMd

    SequentialAnimation on opacity {
        loops: Animation.Infinite
        running: visible
        NumberAnimation { from: 1.0; to: 0.4; duration: 800; easing.type: Easing.InOutSine }
        NumberAnimation { from: 0.4; to: 1.0; duration: 800; easing.type: Easing.InOutSine }
    }
}
