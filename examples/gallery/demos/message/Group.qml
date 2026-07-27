import QtQuick
import QtQuick.Layouts
import Shadcn

// Group: stacks consecutive messages from the same sender (tight spacing gap-1.5).
// Preceding messages use an "empty MessageAvatar" as a placeholder so they align with the last message's avatar.
// Note: the basic version has no standalone MessageGroup component; ColumnLayout + tight spacing approximates the official group visual.
ColumnLayout {
    width: 360
    spacing: Theme.space6

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Theme.space1_5             // cn-message-group gap-1.5

        Message {
            MessageAvatar {}                // empty placeholder: for alignment
            MessageContent {
                variant: MessageContent.Muted
                text: qsTr("I checked the registry addresses.")
            }
        }
        Message {
            MessageAvatar { fallback: "CN" }
            MessageContent {
                variant: MessageContent.Muted
                text: qsTr("The component and example JSON now live under the UI registry.")
            }
        }
    }
}
