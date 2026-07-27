import QtQuick
import Shadcn

// Basic invoice table (new Table) -- header + 7 rows + total footer + bottom caption.
// Columns: Invoice (fixed 100, medium) / Status (fill) / Method (fill) / Amount (fixed 100, right-aligned).
Table {
    id: root
    width: 560
    property bool fillCard: true

    columns: [
        { title: qsTr("Invoice"), key: "invoice", width: 100, medium: true },
        { title: qsTr("Status"),  key: "status" },
        { title: qsTr("Method"),  key: "method" },
        { title: qsTr("Amount"),  key: "amount",  width: 100 }
    ]
    model: [
        { invoice: "INV001", status: "Paid",    method: "Credit Card",   amount: "$250.00" },
        { invoice: "INV002", status: "Pending", method: "PayPal",        amount: "$150.00" },
        { invoice: "INV003", status: "Unpaid",  method: "Bank Transfer", amount: "$350.00" },
        { invoice: "INV004", status: "Paid",    method: "Credit Card",   amount: "$450.00" },
        { invoice: "INV005", status: "Paid",    method: "PayPal",        amount: "$550.00" },
        { invoice: "INV006", status: "Pending", method: "Bank Transfer", amount: "$200.00" },
        { invoice: "INV007", status: "Unpaid",  method: "Credit Card",   amount: "$300.00" }
    ]
    footerData: ["Total", "", "", "$2,500.00"]
    caption: qsTr("A list of your recent invoices.")
}
