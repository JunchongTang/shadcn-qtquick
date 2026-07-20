import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 empty-background:带背景色的空状态(bg-muted/30)。
Empty {
    surface: Theme.alpha(Theme.muted, 0.3)

    EmptyHeader {
        EmptyMedia {
            variant: EmptyMedia.Icon
            iconName: "bell"
        }
        EmptyTitle { text: "No Notifications" }
        EmptyDescription {
            text: "You're all caught up. New notifications will appear here."
        }
    }

    EmptyContent {
        Button {
            Layout.alignment: Qt.AlignHCenter
            text: "Refresh"
            variant: Button.Outline
            iconName: "refresh-cw"
        }
    }
}
