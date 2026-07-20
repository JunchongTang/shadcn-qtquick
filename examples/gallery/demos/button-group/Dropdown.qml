import QtQuick
import Shadcn

// 官方 button-group-dropdown:主动作按钮 + 下拉触发(chevron)组成拆分按钮。
ButtonGroup {
    Button { variant: Button.Outline; text: "Follow" }
    Button {
        id: moreBtn
        variant: Button.Outline
        size: Button.Icon
        iconName: "chevron-down"
        onClicked: menu.popup(0, moreBtn.height + 4)

        Menu {
            id: menu
            MenuItem { text: "Mute Conversation"; iconName: "volume-off" }
            MenuItem { text: "Mark as Read"; iconName: "check" }
            MenuItem { text: "Report Conversation"; iconName: "alert-triangle" }
            MenuItem { text: "Block User"; iconName: "user-round-x" }
            MenuItem { text: "Share Conversation"; iconName: "share" }
            MenuItem { text: "Copy Conversation"; iconName: "copy" }
            MenuSeparator {}
            MenuItem { text: "Delete Conversation"; iconName: "trash" }
        }
    }
}
