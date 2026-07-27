import QtQuick
import Shadcn
import LucideIcons

// Portrait — ratio 9/16, max-w-[10rem] (160).
AspectRatio {
    width: 160
    ratio: 9 / 16
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
