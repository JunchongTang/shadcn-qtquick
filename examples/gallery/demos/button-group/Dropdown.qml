import QtQuick
import Shadcn

// Official button-group-dropdown: main action button + dropdown trigger (chevron) form a split button.
ButtonGroup {
    Button { variant: Button.Outline; text: qsTr("Follow") }
    Button {
        id: moreBtn
        variant: Button.Outline
        size: Button.Icon
        iconName: "chevron-down"
        onClicked: menu.popup(0, moreBtn.height + 4)

        Menu {
            id: menu
            MenuItem { text: qsTr("Mute Conversation"); iconName: "volume-off" }
            MenuItem { text: qsTr("Mark as Read"); iconName: "check" }
            MenuItem { text: qsTr("Report Conversation"); iconName: "alert-triangle" }
            MenuItem { text: qsTr("Block User"); iconName: "user-round-x" }
            MenuItem { text: qsTr("Share Conversation"); iconName: "share" }
            MenuItem { text: qsTr("Copy Conversation"); iconName: "copy" }
            MenuSeparator {}
            MenuItem { text: qsTr("Delete Conversation"); iconName: "trash" }
        }
    }
}
