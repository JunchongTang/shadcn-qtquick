import QtQuick
import Shadcn

// Official button-group-demo: mail toolbar. Multiple ButtonGroups leave gap-2 (outer Row spacing 8),
// adjacent buttons within a group join edge-to-edge. The last group's "more" icon button opens a dropdown menu.
Row {
    spacing: 8

    ButtonGroup {
        Button { variant: Button.Outline; size: Button.Icon; iconName: "arrow-left" }
    }
    ButtonGroup {
        Button { variant: Button.Outline; text: qsTr("Archive") }
        Button { variant: Button.Outline; text: qsTr("Report") }
    }
    ButtonGroup {
        Button { variant: Button.Outline; text: qsTr("Snooze") }
        Button {
            id: moreBtn
            variant: Button.Outline
            size: Button.Icon
            iconName: "more-horizontal"
            onClicked: moreMenu.popup(0, moreBtn.height + 4)

            Menu {
                id: moreMenu
                MenuItem { text: qsTr("Mark as Read"); iconName: "mail-check" }
                MenuItem { text: qsTr("Archive"); iconName: "archive" }
                MenuSeparator {}
                MenuItem { text: qsTr("Snooze"); iconName: "clock" }
                MenuItem { text: qsTr("Add to Calendar"); iconName: "calendar-plus" }
                MenuItem { text: qsTr("Add to List"); iconName: "list-filter" }
                MenuSeparator {}
                MenuItem { text: qsTr("Trash"); iconName: "trash-2" }
            }
        }
    }
}
