import QtQuick
import Shadcn

// 行选择(新 Table)—— 表头「全选」+ 每行 Checkbox;选中行经 selectedRows → bg-muted 高亮。
Table {
    id: root
    width: 560
    property bool fillCard: true

    readonly property var invoices: [
        { invoice: "INV001", status: "Paid",    amount: "$250.00" },
        { invoice: "INV002", status: "Pending", amount: "$150.00" },
        { invoice: "INV003", status: "Unpaid",  amount: "$350.00" },
        { invoice: "INV004", status: "Paid",    amount: "$450.00" }
    ]
    property var sel: [0]                      // 选中行索引(预选首行)
    function toggleRow(r, v) {
        var s = sel.slice(); var i = s.indexOf(r)
        if (v && i < 0) s.push(r); else if (!v && i >= 0) s.splice(i, 1)
        sel = s
    }
    function toggleAll(v) {
        if (!v) { sel = []; return }
        var a = []; for (var i = 0; i < invoices.length; i++) a.push(i); sel = a
    }

    selectedRows: sel
    columns: [
        { title: "", key: "", width: 52, headerDelegate: cbHeader, cellDelegate: cbCell },
        { title: qsTr("Invoice"), key: "invoice", medium: true },
        { title: qsTr("Status"),  key: "status" },
        { title: qsTr("Amount"),  key: "amount",  width: 100, align: Qt.AlignRight }
    ]
    model: invoices
    caption: sel.length + " of " + invoices.length + " row(s) selected."

    Component {
        id: cbHeader
        Item {
            Checkbox {
                id: hcb
                anchors.centerIn: parent
                Binding {
                    target: hcb; property: "checked"
                    value: root.invoices.length > 0 && root.sel.length === root.invoices.length
                    restoreMode: Binding.RestoreBinding
                }
                onToggled: root.toggleAll(hcb.checked)
            }
        }
    }
    Component {
        id: cbCell
        Item {
            id: c
            readonly property int r: parent ? parent.row : -1
            Checkbox {
                id: rcb
                anchors.centerIn: parent
                Binding {
                    target: rcb; property: "checked"
                    value: root.sel.indexOf(c.r) >= 0
                    restoreMode: Binding.RestoreBinding
                }
                onToggled: root.toggleRow(c.r, rcb.checked)
            }
        }
    }
}
