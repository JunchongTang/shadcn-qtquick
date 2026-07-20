import QtQuick
import QtQuick.Layouts
import Shadcn

// Header(发送者名,始终左对齐)+ Footer(状态文本,随 align 靠边)。
ColumnLayout {
    width: 360
    spacing: Theme.space8

    Message {
        MessageContent {
            header: "Olivia"
            variant: MessageContent.Muted
            text: "I already checked the logs."
        }
    }
    Message {
        align: Message.End
        MessageContent {
            variant: MessageContent.Default
            text: "Send the report to the team. Ping @shadcn if you need help."
            footer: "Read · Yesterday"
        }
    }
}
