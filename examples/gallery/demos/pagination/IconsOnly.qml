import QtQuick
import QtQuick.Layouts
import Shadcn

// 仅上一页 / 下一页按钮(隐藏页码),配合「每页行数」下拉——常用于数据表页脚。
RowLayout {
    width: 420
    spacing: 16

    RowLayout {
        spacing: 8
        Label { text: qsTr("Rows per page") }
        Select {
            Layout.preferredWidth: 80
            model: ["10", "25", "50", "100"]
            currentIndex: 1
        }
    }

    Item { Layout.fillWidth: true }

    Pagination {
        count: 10
        page: 2
        showPages: false
    }
}
