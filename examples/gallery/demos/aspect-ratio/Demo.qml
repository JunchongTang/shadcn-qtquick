import QtQuick
import Shadcn
import LucideIcons

// Basic 16:9 — max-w-sm, bg-muted, rounded-lg; contains an image placeholder (object-cover + rounded-lg).
AspectRatio {
    width: 384                  // max-w-sm
    ratio: 16 / 9
    radius: Theme.radiusLg
    color: Theme.muted

    // Image placeholder (grayscale-textured fill + image icon)
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
