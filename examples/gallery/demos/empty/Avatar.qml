import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 empty-avatar:default 媒体槽内放头像。
// 注:Avatar 组件用枚举尺寸(Lg = 40),web 为 size-12(48);grayscale 未支持(近似)。
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
        EmptyTitle { text: "User Offline" }
        EmptyDescription {
            text: "This user is currently offline. You can leave a message to notify them or try again later."
        }
    }

    EmptyContent {
        Button {
            Layout.alignment: Qt.AlignHCenter
            text: "Leave Message"
            size: Button.Sm
        }
    }
}
