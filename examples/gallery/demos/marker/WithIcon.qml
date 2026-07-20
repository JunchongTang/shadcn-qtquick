import QtQuick
import QtQuick.Layouts
import Shadcn

// 官方 marker-icon:MarkerIcon 图标槽;第三个用 flex-col(stacked)图标在上、内容在下。
ColumnLayout {
    width: 320
    spacing: 48                     // gap-12

    Marker {
        iconName: "git-branch"
        text: "Switched to a new branch"
    }
    Marker {
        variant: Marker.Separator
        iconName: "search"
        text: "Explored 4 files"
    }
    Marker {
        stacked: true               // className="flex-col"
        iconName: "book-open-check"
        text: "Syncing completed"
    }
}
