import QtQuick
import Shadcn

// 基础表(新 Table)——本卡展示【声明式列】写法:用 columnItems + TableColumn 子元素定义列
//(与 JS columns 写法等价、可互换)。Status 首字母大写 / Email 小写 / Amount 货币格式 + 加粗。
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

        // 声明式列:每列一个 TableColumn 子对象(等价于 JS columns 的对象元素)。
        columnItems: [
            TableColumn { title: "Status"; key: "status"; width: 150; format: root.cap },
            TableColumn { title: "Email";  key: "email";  format: function (s) { return s.toLowerCase() } },
            TableColumn { title: "Amount"; key: "amount"; width: 120; medium: true; format: root.money }
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
