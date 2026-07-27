import QtQuick
import QtQuick.Layouts
import Shadcn

// Previous / next buttons only (page numbers hidden), paired with a "rows per page" dropdown -- common in data-table footers.
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
