import QtQuick
import QtQuick.Layouts
import Shadcn

// 行选择(新 Table)—— 表头全选 + 逐行 Checkbox;选中行 bg-muted;Status 用 Badge;底部「已选/总数」。
ColumnLayout {
    id: root
    width: 640
    property bool fillCard: true
    spacing: 0

    readonly property var payments: [
        { id: "m5gr84i9", amount: 316, status: "success",    email: "ken99@example.com" },
        { id: "3u1reuv4", amount: 242, status: "success",    email: "Abe45@example.com" },
        { id: "derv1ws0", amount: 837, status: "processing", email: "Monserrat44@example.com" },
        { id: "5kma53ae", amount: 874, status: "success",    email: "Silas22@example.com" },
        { id: "bhqecj4p", amount: 721, status: "failed",     email: "carmella@example.com" }
    ]
    property var sel: [1]                       // 选中行索引(预选一行)
    function toggleRow(r, v) {
        var s = sel.slice(); var i = s.indexOf(r)
        if (v && i < 0) s.push(r); else if (!v && i >= 0) s.splice(i, 1)
        sel = s
    }
    function toggleAll(v) {
        if (!v) { sel = []; return }
        var a = []; for (var i = 0; i < payments.length; i++) a.push(i); sel = a
    }
    function money(a) { return "$" + a.toFixed(2) }
    function cap(s) { return s.charAt(0).toUpperCase() + s.slice(1) }
    function statusVariant(s) {
        return s === "success" ? Badge.Secondary : s === "failed" ? Badge.Destructive : Badge.Outline
    }

    Component {
        id: selHeader
        Item {
            Checkbox {
                id: hcb
                anchors.centerIn: parent
                Binding { target: hcb; property: "checked"
                          value: root.payments.length > 0 && root.sel.length === root.payments.length
                          restoreMode: Binding.RestoreBinding }
                onToggled: root.toggleAll(hcb.checked)
            }
        }
    }
    Component {
        id: selCell
        Item {
            id: c
            readonly property int r: parent ? parent.row : -1
            Checkbox {
                id: rcb
                anchors.centerIn: parent
                Binding { target: rcb; property: "checked"; value: root.sel.indexOf(c.r) >= 0
                          restoreMode: Binding.RestoreBinding }
                onToggled: root.toggleRow(c.r, rcb.checked)
            }
        }
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
            selectedRows: root.sel
            columns: [
                { title: "", key: "", width: 52, headerDelegate: selHeader, cellDelegate: selCell },
                { title: "Status", key: "status", width: 150, cellDelegate: statusCell },
                { title: "Email",  key: "email",  format: function (s) { return s.toLowerCase() } },
                { title: "Amount", key: "amount", width: 120, medium: true, format: root.money }
            ]
            model: root.payments
        }
    }

    Text {
        Layout.topMargin: 16
        text: root.sel.length + " of " + root.payments.length + " row(s) selected."
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
    }
}
