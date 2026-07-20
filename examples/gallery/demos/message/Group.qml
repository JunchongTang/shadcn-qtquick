import QtQuick
import QtQuick.Layouts
import Shadcn

// Group:堆叠同一发送者的连续消息(紧间距 gap-1.5)。
// 前序消息用「空 MessageAvatar」占位,使其与末条消息的头像对齐。
// 注:基础版未提供独立 MessageGroup 组件,用 ColumnLayout + 紧间距近似官方分组视觉。
ColumnLayout {
    width: 360
    spacing: Theme.space6

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Theme.space1_5             // cn-message-group gap-1.5

        Message {
            MessageAvatar {}                // 空占位:对齐用
            MessageContent {
                variant: MessageContent.Muted
                text: "I checked the registry addresses."
            }
        }
        Message {
            MessageAvatar { fallback: "CN" }
            MessageContent {
                variant: MessageContent.Muted
                text: "The component and example JSON now live under the UI registry."
            }
        }
    }
}
