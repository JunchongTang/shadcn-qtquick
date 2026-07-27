import QtQuick
import Shadcn

// Sorting (new Table) -- the Email header is a ghost Button (headerDelegate); clicking toggles between asc/desc,
// the trailing icon changes with direction; model is the rows sorted by direction.
Rectangle {
    id: root
    width: 620
    property bool fillCard: true
    implicitHeight: tbl.implicitHeight
    radius: Theme.radiusMd
    color: "transparent"
    border.width: 1
    border.color: Theme.border
    clip: true

    readonly property var payments: [
        { id: "m5gr84i9", amount: 316, status: "success",    email: "ken99@example.com" },
        { id: "3u1reuv4", amount: 242, status: "success",    email: "Abe45@example.com" },
        { id: "derv1ws0", amount: 837, status: "processing", email: "Monserrat44@example.com" },
        { id: "5kma53ae", amount: 874, status: "success",    email: "Silas22@example.com" },
        { id: "bhqecj4p", amount: 721, status: "failed",     email: "carmella@example.com" }
    ]
    property string sortDir: "asc"              // "asc" | "desc"
    readonly property var _rows: {
        var arr = payments.slice()
        arr.sort(function (a, b) {
            var ea = a.email.toLowerCase(), eb = b.email.toLowerCase()
            var r = ea < eb ? -1 : (ea > eb ? 1 : 0)
            return sortDir === "asc" ? r : -r
        })
        return arr
    }
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
    Component {
        id: emailHeader
        Item {
            Button {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                variant: Button.Ghost
                text: qsTr("Email")
                // leftPadding: 0
                // rightPadding: 4
                trailingIconName: root.sortDir === "asc" ? qsTr("arrow-up") : qsTr("arrow-down")
                onClicked: root.sortDir = (root.sortDir === "asc") ? qsTr("desc") : qsTr("asc")
            }
        }
    }

    Table {
        id: tbl
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        columns: [
            { title: qsTr("Status"), key: "status", width: 150, cellDelegate: statusCell },
            { title: qsTr("Email"),  key: "email",  headerDelegate: emailHeader, format: function (s) { return s.toLowerCase() } },
            { title: qsTr("Amount"), key: "amount", width: 120, medium: true, format: root.money }
        ]
        model: root._rows
    }
}
