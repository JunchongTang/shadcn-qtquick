import QtQuick
import Shadcn
import LucideIcons

// 基础 16:9 —— max-w-sm、bg-muted、rounded-lg;内含图片占位(object-cover + rounded-lg)。
AspectRatio {
    width: 384                  // max-w-sm
    ratio: 16 / 9
    radius: Theme.radiusLg
    color: Theme.muted

    // 图片占位(灰阶质感的色块 + image 图标)
    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusLg
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: Theme.alpha(Theme.foreground, 0.06) }
            GradientStop { position: 1.0; color: Theme.alpha(Theme.foreground, 0.14) }
        }
        LucideIcon {
            anchors.centerIn: parent
            name: "image"
            size: 32
            color: Theme.mutedForeground
        }
    }
}
