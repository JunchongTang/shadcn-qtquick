import QtQuick
import QtQuick.Layouts
import Shadcn

// 分页(新 Table)—— 13 条数据、每页 5 行;底部 Pagination + 行数区间。model 为当前页切片。
ColumnLayout {
    id: root
    width: 640
    property bool fillCard: true
    spacing: 0

    readonly property var payments: [
        { id: "m5gr84i9", amount: 316, status: "success",    email: "ken99@example.com" },
        { id: "3u1reuv4", amount: 242, status: "success",    email: "abe45@example.com" },
        { id: "derv1ws0", amount: 837, status: "processing", email: "monserrat44@example.com" },
        { id: "5kma53ae", amount: 874, status: "success",    email: "silas22@example.com" },
        { id: "bhqecj4p", amount: 721, status: "failed",     email: "carmella@example.com" },
        { id: "p0a1b2c3", amount: 129, status: "pending",    email: "jamal@example.com" },
        { id: "q4d5e6f7", amount: 452, status: "success",    email: "harper@example.com" },
        { id: "r8g9h0i1", amount: 967, status: "processing", email: "noah@example.com" },
        { id: "s2j3k4l5", amount: 88,  status: "failed",     email: "olivia@example.com" },
        { id: "t6m7n8o9", amount: 540, status: "success",    email: "liam@example.com" },
        { id: "u0p1q2r3", amount: 213, status: "pending",    email: "emma@example.com" },
        { id: "v4s5t6u7", amount: 705, status: "success",    email: "mason@example.com" },
        { id: "w8x9y0z1", amount: 361, status: "processing", email: "ava@example.com" }
    ]
    readonly property int pageSize: 5
    property int page: 1
    readonly property int _pageCount: Math.max(1, Math.ceil(payments.length / pageSize))
    readonly property int _from: (page - 1) * pageSize
    readonly property var _rows: payments.slice(_from, _from + pageSize)

    function money(a) { return "$" + a.toFixed(2) }
    function cap(s) { return s.charAt(0).toUpperCase() + s.slice(1) }
    function statusVariant(s) {
        return s === "success" ? Badge.Secondary : s === "failed" ? Badge.Destructive : Badge.Outline
    }

    Component {
        id: statusCell
        Item {
            id: sc
            readonly property var v: parent ? parent.value : ""
            Badge {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                variant: root.statusVariant(sc.v)
                text: root.cap(sc.v)
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        implicitHeight: tbl.implicitHeight
        radius: Theme.radiusMd
        color: "transparent"
        border.width: 1
        border.color: Theme.border
        clip: true

        Table {
            id: tbl
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            columns: [
                { title: qsTr("Status"), key: "status", width: 150, cellDelegate: statusCell },
                { title: qsTr("Email"),  key: "email" },
                { title: qsTr("Amount"), key: "amount", width: 120, medium: true, format: root.money }
            ]
            model: root._rows
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.topMargin: 16
        spacing: 8
        Text {
            Layout.fillWidth: true
            text: (root._from + 1) + "–" + (root._from + root._rows.length) + " of " + root.payments.length
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
        }
        Pagination {
            count: root._pageCount
            page: root.page
            onPageRequested: function (p) { root.page = p }
        }
    }
}
