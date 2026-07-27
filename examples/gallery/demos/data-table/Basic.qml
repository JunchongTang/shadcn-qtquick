import QtQuick
import Shadcn

// Basic table (new Table) -- this card shows the declarative-column style: define columns via columnItems + TableColumn child elements
// (equivalent to and interchangeable with the JS columns style). Status capitalized / Email lowercased / Amount currency format + bold.
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

    function money(a) { return "$" + a.toFixed(2) }
    function cap(s) { return s.charAt(0).toUpperCase() + s.slice(1) }

    Table {
        id: tbl
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        // Declarative columns: one TableColumn child object per column (equivalent to the object elements of JS columns).
        columnItems: [
            TableColumn { title: qsTr("Status"); key: "status"; width: 150; format: root.cap },
            TableColumn { title: qsTr("Email");  key: "email";  format: function (s) { return s.toLowerCase() } },
            TableColumn { title: qsTr("Amount"); key: "amount"; width: 120; medium: true; format: root.money }
        ]
        model: [
            { id: "m5gr84i9", amount: 316, status: "success",    email: "ken99@example.com" },
            { id: "3u1reuv4", amount: 242, status: "success",    email: "Abe45@example.com" },
            { id: "derv1ws0", amount: 837, status: "processing", email: "Monserrat44@example.com" },
            { id: "5kma53ae", amount: 874, status: "success",    email: "Silas22@example.com" },
            { id: "bhqecj4p", amount: 721, status: "failed",     email: "carmella@example.com" }
        ]
    }
}
