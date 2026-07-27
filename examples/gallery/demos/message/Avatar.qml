import QtQuick
import QtQuick.Layouts
import Shadcn

// Avatar slot: align=start puts the avatar on the left, align=end on the right.
ColumnLayout {
    width: 360
    spacing: Theme.space6

    Message {
        MessageAvatar { fallback: "R" }
        MessageContent {
            variant: MessageContent.Muted
            text: qsTr("The build failed during dependency installation.")
        }
    }
    Message {
        align: Message.End
        MessageAvatar { fallback: "ME" }
        MessageContent {
            variant: MessageContent.Default
            text: qsTr("Can you share the exact error?")
        }
    }
    Message {
        MessageAvatar { fallback: "R" }
        MessageContent {
            variant: MessageContent.Muted
            text: qsTr("Something went wrong with the build. The libraries are not installed correctly. Try running the build again.")
        }
    }
}
