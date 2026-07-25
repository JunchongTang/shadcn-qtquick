import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 empty-icon:圆底图标空状态网格(仅 header,无动作)。2 列。
GridLayout {
    columns: 2
    columnSpacing: Theme.space6
    rowSpacing: Theme.space6

    Repeater {
        model: [
            { icon: "inbox",    title: qsTr("No messages"),  desc: "Your inbox is empty. New messages will appear here." },
            { icon: "star",     title: qsTr("No favorites"), desc: "Items you mark as favorites will appear here." },
            { icon: "heart",    title: qsTr("No likes yet"), desc: "Content you like will be saved here for easy access." },
            { icon: "bookmark", title: qsTr("No bookmarks"), desc: "Save interesting content by bookmarking it." }
        ]
        Empty {
            EmptyHeader {
                maxWidth: 220
                EmptyMedia {
                    variant: EmptyMedia.Icon
                    iconName: modelData.icon
                }
                EmptyTitle { text: modelData.title }
                EmptyDescription { text: modelData.desc }
            }
        }
    }
}
