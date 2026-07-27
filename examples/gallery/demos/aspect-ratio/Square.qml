import QtQuick
import Shadcn
import LucideIcons

// Square — ratio 1/1, max-w-[12rem] (192).
AspectRatio {
    width: 192
    ratio: 1 / 1
    radius: Theme.radiusLg
    color: Theme.muted

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
            size: 28
            color: Theme.mutedForeground
        }
    }
}
