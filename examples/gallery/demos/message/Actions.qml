import QtQuick
import QtQuick.Layouts
import Shadcn

// Actions: message-level action buttons (copy/upvote/downvote, retry on failure) placed in the footer.
// The default children (IconButton) form the action group. Here actionsOnHover=false keeps actions always visible for preview;
// the default behavior is to fade in only on message hover (see MessageContent.actionsOnHover).
ColumnLayout {
    width: 360
    spacing: Theme.space8

    Message {
        MessageContent {
            variant: MessageContent.Muted
            text: qsTr("The install failure is coming from the workspace package.")
            actionsOnHover: false
            IconButton { iconName: "copy"; size: IconButton.Small; variant: IconButton.Ghost }
            IconButton { iconName: "thumbs-up"; size: IconButton.Small; variant: IconButton.Ghost }
            IconButton { iconName: "thumbs-down"; size: IconButton.Small; variant: IconButton.Ghost }
        }
    }
    Message {
        align: Message.End
        MessageContent {
            variant: MessageContent.Default
            text: qsTr("Okay drop me a link. Taking a look...")
            footer: "Failed to send"
            footerDestructive: true
            actionsOnHover: false
            IconButton { iconName: "refresh-ccw"; size: IconButton.Small; variant: IconButton.Ghost }
        }
    }
}
