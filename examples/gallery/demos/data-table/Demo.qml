import QtQuick
import QtQuick.Layouts
import Shadcn

// 完整交互数据表(新 Table)—— Filter Input + Columns 列显隐 + 全选/逐行 Checkbox(选中高亮)
// + Email 表头排序 + 行末操作下拉 + 底部「已选/总数」+ 上一页/下一页。
// 数据管线:payments → 过滤(email)→ 排序(email)→ 分页;Table 用 model+columns 驱动。
ColumnLayout {
    id: root
    width: 760
    property bool fillCard: true
    spacing: 0

    readonly property var payments: [
        { id: "m5gr84i9", amount: 316, status: "success",    email: "ken99@example.com" },
        { id: "3u1reuv4", amount: 242, status: "success",    email: "Abe45@example.com" },
        { id: "derv1ws0", amount: 837, status: "processing", email: "Monserrat44@example.com" },
        { id: "5kma53ae", amount: 874, status: "success",    email: "Silas22@example.com" },
        { id: "bhqecj4p", amount: 721, status: "failed",     email: "carmella@example.com" }
    ]

    property string filterText: ""
    property string sortDir: ""                 // "" | "asc" | "desc"
    property int page: 1
    readonly property int pageSize: 10
    property bool colStatusVisible: true
    property bool colEmailVisible: true
    property bool colAmountVisible: true
    property var selectedIds: ({})

    readonly property var _filtered: {
        var q = filterText.toLowerCase()
        return payments.filter(function (p) { return q === "" || p.email.toLowerCase().indexOf(q) !== -1 })
    }
    readonly property var _sorted: {
        if (sortDir === "") return _filtered
        var arr = _filtered.slice()
        arr.sort(function (a, b) {
            var ea = a.email.toLowerCase(), eb = b.email.toLowerCase()
            var r = ea < eb ? -1 : (ea > eb ? 1 : 0)
            return sortDir === "asc" ? r : -r
        })
        return arr
    }
    readonly property int _pageCount: Math.max(1, Math.ceil(_sorted.length / pageSize))
    readonly property var _pageRows: _sorted.slice((page - 1) * pageSize, (page - 1) * pageSize + pageSize)
    // 当前页中被选中的行索引 → Table.selectedRows(行高亮)
    readonly property var _selRows: {
        var a = []
        for (var i = 0; i < _pageRows.length; i++)
            if (selectedIds[_pageRows[i].id]) a.push(i)
        return a
    }
    onFilterTextChanged: page = 1

    function isSel(id) { return selectedIds[id] === true }
    function setSel(id, v) {
        var m = Object.assign({}, selectedIds)
        if (v) m[id] = true; else delete m[id]
        selectedIds = m
    }
    function toggleAll(v) {
        var m = Object.assign({}, selectedIds)
        for (var i = 0; i < _filtered.length; i++) { if (v) m[_filtered[i].id] = true; else delete m[_filtered[i].id] }
        selectedIds = m
    }
    readonly property int _selCount: {
        var c = 0
        for (var i = 0; i < _filtered.length; i++) if (selectedIds[_filtered[i].id]) c++
        return c
    }
    readonly property bool _allSel: _filtered.length > 0 && _selCount === _filtered.length

    function money(a) { return "$" + a.toFixed(2) }
    function lc(s) { return s.toLowerCase() }
    function cap(s) { return s.charAt(0).toUpperCase() + s.slice(1) }
    function statusVariant(s) {
        return s === "success" ? Badge.Secondary : s === "failed" ? Badge.Destructive : Badge.Outline
    }

    // ==== 列的自定义表头/单元格 ====
    Component {
        id: selHeader
        Item { Checkbox {
            id: hcb; anchors.centerIn: parent
            Binding { target: hcb; property: "checked"; value: root._allSel; restoreMode: Binding.RestoreBinding }
            onToggled: root.toggleAll(hcb.checked)
        } }
    }
    Component {
        id: selCell
        Item { id: c; readonly property int r: parent ? parent.row : -1
            Checkbox {
                id: rcb; anchors.centerIn: parent
                Binding { target: rcb; property: "checked"
                          value: c.r >= 0 && c.r < root._pageRows.length && root.isSel(root._pageRows[c.r].id)
                          restoreMode: Binding.RestoreBinding }
                onToggled: if (c.r >= 0 && c.r < root._pageRows.length) root.setSel(root._pageRows[c.r].id, rcb.checked)
            } }
    }
    Component {
        id: statusCell
        Item { id: sc; readonly property var v: parent ? parent.value : ""
            Badge {
                anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
                variant: root.statusVariant(sc.v); text: root.cap(sc.v)
            } }
    }
    Component {
        id: emailHeader
        Item { Button {
            anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter
            variant: Button.Ghost; text: qsTr("Email");
            trailingIconName: root.sortDir === "asc" ? "arrow-up" : root.sortDir === "desc" ? qsTr("arrow-down") : qsTr("arrow-up-down")
            onClicked: root.sortDir = (root.sortDir === "asc") ? qsTr("desc") : qsTr("asc")
        } }
    }
    Component {
        id: actionsCell
        Item { id: ac; readonly property int r: parent ? parent.row : -1
            IconButton {
                id: rowBtn
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                variant: IconButton.Ghost; size: IconButton.Small; iconName: "ellipsis"
                onClicked: rowMenu.popup(rowBtn.width - 176, rowBtn.height + 4)
                Menu {
                    id: rowMenu
                    implicitWidth: 176
                    MenuLabel { text: qsTr("Actions") }
                    MenuItem { text: qsTr("Copy payment ID") }
                    MenuSeparator {}
                    MenuItem { text: qsTr("View customer") }
                    MenuItem { text: qsTr("View payment details") }
                }
            } }
    }

    // ==== 顶部工具条 ====
    RowLayout {
        Layout.fillWidth: true
        Layout.bottomMargin: 16
        spacing: 8
        Input {
            Layout.preferredWidth: 240
            placeholderText: qsTr("Filter emails...")
            onTextChanged: root.filterText = text
        }
        Item { Layout.fillWidth: true }
        Button {
            id: colBtn
            text: qsTr("Columns"); variant: Button.Outline; trailingIconName: "chevron-down"
            onClicked: colMenu.popup(colBtn.width - 176, colBtn.height + 4)
            Menu {
                id: colMenu
                implicitWidth: 176
                MenuCheckboxItem { id: cbS; text: qsTr("Status")
                    Binding { target: cbS; property: "checked"; value: root.colStatusVisible; restoreMode: Binding.RestoreBinding }
                    onToggled: root.colStatusVisible = cbS.checked }
                MenuCheckboxItem { id: cbE; text: qsTr("Email")
                    Binding { target: cbE; property: "checked"; value: root.colEmailVisible; restoreMode: Binding.RestoreBinding }
                    onToggled: root.colEmailVisible = cbE.checked }
                MenuCheckboxItem { id: cbA; text: qsTr("Amount")
                    Binding { target: cbA; property: "checked"; value: root.colAmountVisible; restoreMode: Binding.RestoreBinding }
                    onToggled: root.colAmountVisible = cbA.checked }
            }
        }
    }

    // ==== 表体外框 ====
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
            selectedRows: root._selRows
            model: root._pageRows
            columns: {
                var c = [{ title: "", key: "", width: 52, headerDelegate: selHeader, cellDelegate: selCell }]
                if (root.colStatusVisible) c.push({ title: qsTr("Status"), key: "status", width: 150, cellDelegate: statusCell })
                if (root.colEmailVisible) c.push({ title: qsTr("Email"), key: "email", headerDelegate: emailHeader, format: root.lc })
                if (root.colAmountVisible) c.push({ title: qsTr("Amount"), key: "amount", width: 120, medium: true, format: root.money })
                c.push({ title: "", key: "", width: 52, cellDelegate: actionsCell })
                return c
            }
        }
    }

    // ==== 底部 ====
    RowLayout {
        Layout.fillWidth: true
        Layout.topMargin: 16
        spacing: 8
        Text {
            Layout.fillWidth: true
            text: root._selCount + " of " + root._filtered.length + " row(s) selected."
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
        }
        Button { text: qsTr("Previous"); variant: Button.Outline; size: Button.Sm; enabled: root.page > 1; onClicked: root.page-- }
        Button { text: qsTr("Next"); variant: Button.Outline; size: Button.Sm; enabled: root.page < root._pageCount; onClicked: root.page++ }
    }
}
