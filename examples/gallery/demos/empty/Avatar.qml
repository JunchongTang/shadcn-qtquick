import QtQuick
import QtQuick.Layouts
import Shadcn

// Official empty-avatar: avatar in the default media slot.
// Note: Avatar uses enum sizes (Lg = 40); web is size-12 (48); grayscale unsupported (approximation).
Empty {
    EmptyHeader {
        EmptyMedia {
            variant: EmptyMedia.Default
            Avatar {
                size: Avatar.Lg
                source: "https://github.com/shadcn.png"
                fallback: "LR"
            }
        }
        EmptyTitle { text: qsTr("User Offline") }
        EmptyDescription {
            text: qsTr("This user is currently offline. You can leave a message to notify them or try again later.")
        }
    }

    EmptyContent {
        Button {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Leave Message")
            size: Button.Sm
        }
    }
}
