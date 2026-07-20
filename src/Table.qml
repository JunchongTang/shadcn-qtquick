import QtQuick
import Qt.labs.qmlmodels

// shadcn Table(base-mira)—— 高性能版:表体用 QtQuick TableView(虚拟化),
// 表头是自绘 Row(每列可配布局属性 + 稳定的列宽拖拽手柄)。模型/列定义驱动。
//
// 数据(model):JS 行数组 / QML TableModel / C++ QAbstractItemModel。
// 列定义(columns):[{ title, key, role, width, fillWidth, minWidth, maxWidth, align, format, medium }]
//   · width:固定/首选宽(px);fillWidth:true 则占剩余空间;minWidth/maxWidth:夹取;
//   · 用户拖拽某列 → 记为该列的显式覆盖宽(其余 fill 列重新分配剩余)。
//   · key:JS 数组取行对象字段;role:item model 取的角色(默认 "display");
//   · align:Qt.AlignLeft/Right/HCenter;format(v)->string;medium:加粗。
Item {
    id: root

    property var model: []
    property var columns: []                        // JS 列定义:[{ title, key, ... }]
    property list<TableColumn> columnItems          // 声明式列定义(子元素);非空时优先
    // 生效的列集合:优先声明式 columnItems,否则 JS columns。两种写法属性同名,访问方式一致。
    readonly property var _cols: (columnItems && columnItems.length > 0) ? columnItems : (columns || [])
    // 现算列集合:在 columns/columnItems 变更处理器里,派生的 _cols 绑定尚未标脏重算(惰性),
    // 直接读源属性才拿得到最新值,避免重建模型时用了上一次的旧列集合(慢一拍 → 表头/模型列数错位)。
    function _currentCols() { return (columnItems && columnItems.length > 0) ? columnItems : (columns || []) }
    property string caption: ""
    property string emptyText: "No results."      // 无数据行时居中显示
    // 合计/脚注行:按列对齐的数组(元素为字符串,或 { text, align, medium })。空则不显。
    property var footerData: []
    readonly property bool _hasFooter: footerData && footerData.length > 0
    property int rowHeight: 40
    property int headerHeight: 40
    property real minFillWidth: 60

    readonly property alias view: tableView
    property int hoverRow: -1
    property var selectedRows: []              // 选中行索引数组 → 行高亮 bg-muted(data-state=selected)
    signal rowClicked(int row)

    implicitWidth: 480
    implicitHeight: headerHeight
                    + (tableView.rows === 0 ? 96 : tableView.contentHeight)   // 空态留 h-24
                    + (_hasFooter ? rowHeight : 0)
                    + (caption !== "" ? captionText.implicitHeight + 16 : 0)

    // ==== 数据规范化:JS 数组 → 内部 TableModel;否则透传 ====
    property QtObject _internalModel: null
    readonly property bool _isArray: model !== undefined && model !== null && model.constructor === Array
    function _rebuild() {
        var cols = root._currentCols()
        if (root._isArray) {
            if (cols.length === 0) { tableView.model = null; return }
            var colsQml = ""
            for (var i = 0; i < cols.length; i++)
                colsQml += '    TableModelColumn { display: "' + (cols[i].key || "") + '" }\n'
            if (root._internalModel) { root._internalModel.destroy(); root._internalModel = null }
            root._internalModel = Qt.createQmlObject(
                'import Qt.labs.qmlmodels\nTableModel {\n' + colsQml + '}', root)
            root._internalModel.rows = root.model
            tableView.model = root._internalModel
        } else {
            root._internalModel = null
            tableView.model = root.model
        }
    }

    // ==== 列宽计算(Layout 式:固定 + fill 均分剩余,支持 min/max 夹取 + 拖拽覆盖)====
    property var _overrides: ({})          // 列索引 → 用户拖拽后的显式宽
    property var _widths: []               // 解析后各列宽度(表头/表体共用)
    property real _dragStartW: 0

    function _clamp(v, mn, mx) {
        if (mn && mn > 0 && v < mn) v = mn      // 0/undefined 视为不限
        if (mx && mx > 0 && v > mx) v = mx
        return v
    }
    function _recompute() {
        var cols = root._currentCols()
        var n = cols.length
        var arr = []
        var fixedTotal = 0
        var fillIdx = []
        for (var i = 0; i < n; i++) {
            var def = cols[i] || {}
            // 固定列 = 显式 width>0 且未强制 fillWidth;其余(含未设 width 的列)一律 fill。
            var isFixed = (def.width && def.width > 0) && def.fillWidth !== true
            if (root._overrides[i] !== undefined) {
                arr[i] = root._overrides[i]; fixedTotal += arr[i]
            } else if (isFixed) {
                arr[i] = root._clamp(def.width, def.minWidth, def.maxWidth); fixedTotal += arr[i]
            } else {
                arr[i] = -1; fillIdx.push(i)
            }
        }
        if (fillIdx.length > 0) {
            var each = Math.max(0, root.width - fixedTotal) / fillIdx.length
            for (var k = 0; k < fillIdx.length; k++) {
                var d = cols[fillIdx[k]] || {}
                arr[fillIdx[k]] = Math.max(root.minFillWidth, root._clamp(each, d.minWidth, d.maxWidth))
            }
        }
        // 兜底铺满:总宽仍小于表宽时(无 fill 列 / fill 被 max 夹住),把剩余补给最后一列,
        // 保证列铺满表宽、每行分隔线完整到右边缘、右侧无空白。
        if (n > 0) {
            var sum = 0
            for (var s = 0; s < n; s++) sum += arr[s]
            if (sum < root.width) arr[n - 1] += (root.width - sum)
        }
        root._widths = arr
        tableView.forceLayout()
    }
    function _resize(col, w) {
        var o = root._overrides
        o[col] = Math.max(root.minFillWidth, w)
        root._overrides = o
        root._recompute()
    }
    function _align(def) { return (def && def.align) ? def.align : Text.AlignLeft }

    onWidthChanged: _recompute()
    // 列集合变化(如显隐某列)→ 清掉按索引记录的拖拽覆盖宽(旧索引已错配),再重建/重算。
    onColumnsChanged: { root._overrides = ({}); _rebuild(); _recompute() }
    onColumnItemsChanged: { root._overrides = ({}); _rebuild(); _recompute() }
    onModelChanged: _rebuild()
    Component.onCompleted: { _rebuild(); _recompute() }

    // ==== 自绘表头(普通 Row;随表体水平滚动)====
    Item {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: root.headerHeight
        clip: true

        Row {
            id: headerRow
            height: parent.height
            x: -tableView.contentX          // 与表体水平滚动同步

            Repeater {
                model: root._cols.length
                delegate: Item {
                    id: hcell
                    required property int index
                    width: root._widths[index] !== undefined ? root._widths[index] : 120
                    height: root.headerHeight
                    readonly property var _def: root._cols[index]
                    readonly property bool _custom: _def && _def.headerDelegate !== undefined && _def.headerDelegate !== null

                    // 默认表头文本
                    Text {
                        visible: !hcell._custom
                        anchors.fill: parent
                        anchors.leftMargin: Theme.space2
                        anchors.rightMargin: Theme.space2 + 8   // 给右侧手柄让位
                        text: hcell._def ? (hcell._def.title || "") : ""
                        color: Theme.mutedForeground
                        font.pixelSize: Theme.textXs
                        font.weight: Font.Medium
                        horizontalAlignment: root._align(hcell._def)
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    // 自定义表头(列定义 headerDelegate:Component)。组件内经 parent 访问:
                    //   parent.column(列号)· parent.table(Table)
                    Loader {
                        visible: hcell._custom
                        active: hcell._custom
                        anchors.fill: parent
                        anchors.leftMargin: Theme.space2
                        anchors.rightMargin: Theme.space2   // 与单元格一致 → 自定义表头/单元格(如 checkbox)对齐
                        readonly property int column: hcell.index
                        readonly property var table: root
                        sourceComponent: hcell._custom ? hcell._def.headerDelegate : null
                    }

                    // 列宽拖拽手柄:跨列右边界,宽命中区 + resize 光标。最后一列不显(它兜底填满)。
                    Item {
                        visible: hcell.index < root._cols.length - 1
                        width: 11
                        height: parent.height
                        anchors.right: parent.right
                        anchors.rightMargin: -5
                        z: 5
                        // 普通短竖分隔线(恒定,不随 hover/拖动高亮)
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            width: 1
                            height: parent.height * 0.4
                            color: Theme.border
                        }
                        HoverHandler { cursorShape: Qt.SplitHCursor }
                        DragHandler {
                            target: null
                            yAxis.enabled: false
                            cursorShape: Qt.SplitHCursor
                            onActiveChanged: if (active)
                                root._dragStartW = (root._widths[hcell.index] !== undefined ? root._widths[hcell.index] : 120)
                            onTranslationChanged: root._resize(hcell.index, root._dragStartW + translation.x)
                        }
                    }
                }
            }
        }
        // 表头下边框(通栏)
        Rectangle {
            anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
            height: 1; color: Theme.border
        }
    }

    // ==== 表体(TableView,虚拟化)====
    TableView {
        id: tableView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.bottom: root._hasFooter ? footer.top
                        : (root.caption !== "" ? captionText.top : parent.bottom)
        anchors.bottomMargin: (!root._hasFooter && root.caption !== "") ? 16 : 0
        clip: true
        reuseItems: true
        boundsBehavior: Flickable.StopAtBounds
        columnWidthProvider: function (c) { return root._widths[c] !== undefined ? root._widths[c] : 120 }
        rowHeightProvider: function (r) { return root.rowHeight }

        delegate: Rectangle {
            id: cellItem
            required property var model
            required property int row
            required property int column
            implicitWidth: root._widths[column] !== undefined ? root._widths[column] : 120
            implicitHeight: root.rowHeight
            readonly property var _def: root._cols[column]
            readonly property string _role: (_def && _def.role) ? _def.role : "display"
            readonly property var _raw: model[_role]

            readonly property bool _selected: root.selectedRows.indexOf(cellItem.row) >= 0
            color: _selected ? Theme.muted
                   : (root.hoverRow === cellItem.row ? Theme.alpha(Theme.muted, 0.5) : "transparent")

            readonly property bool _custom: cellItem._def && cellItem._def.cellDelegate !== undefined
                                            && cellItem._def.cellDelegate !== null

            // 默认文本单元格
            Text {
                visible: !cellItem._custom
                anchors.fill: parent
                anchors.leftMargin: Theme.space2
                anchors.rightMargin: Theme.space2
                text: {
                    var d = cellItem._def
                    var v = cellItem._raw
                    var s = (v === undefined || v === null) ? "" : String(v)
                    // format 用 try 包裹:切列瞬间 _def/_raw 绑定更新有先后,format 可能短暂收到
                    // 另一列的值(类型不符)→ 静默回退到原值,避免过渡帧抛异常刷屏。
                    if (d && d.format) { try { return d.format(v) } catch (e) { return s } }
                    return s
                }
                color: Theme.foreground
                font.pixelSize: Theme.textXs
                font.weight: (cellItem._def && cellItem._def.medium) ? Font.Medium : Font.Normal
                horizontalAlignment: root._align(cellItem._def)
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            // 自定义单元格(列定义 cellDelegate:Component)。组件内经 parent 访问:
            //   parent.value(本格值)· parent.row(行号)· parent.rowData(整行 model)· parent.table(Table)
            Loader {
                id: cellLoader
                visible: cellItem._custom
                active: cellItem._custom
                anchors.fill: parent
                anchors.leftMargin: Theme.space2
                anchors.rightMargin: Theme.space2
                readonly property var value: cellItem._raw
                readonly property int row: cellItem.row
                readonly property var rowData: cellItem.model
                readonly property var table: root
                sourceComponent: cellItem._custom ? cellItem._def.cellDelegate : null
            }
            Rectangle {
                anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
                height: 1; color: Theme.border
            }
            HoverHandler {
                onHoveredChanged: root.hoverRow = hovered ? cellItem.row
                                  : (root.hoverRow === cellItem.row ? -1 : root.hoverRow)
            }
            TapHandler { onTapped: root.rowClicked(cellItem.row) }
        }
    }

    // ==== 空态(无数据行时居中)====
    Text {
        visible: tableView.rows === 0
        anchors.horizontalCenter: tableView.horizontalCenter
        anchors.verticalCenter: tableView.verticalCenter
        text: root.emptyText
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
    }

    // ==== 合计/脚注行(muted 底 + medium)====
    Item {
        id: footer
        visible: root._hasFooter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: root.caption !== "" ? captionText.top : parent.bottom
        anchors.bottomMargin: root.caption !== "" ? 16 : 0
        height: root._hasFooter ? root.rowHeight : 0
        clip: true

        Rectangle { anchors.fill: parent; color: Theme.alpha(Theme.muted, 0.5) }   // TableFooter bg-muted/50
        // 顶部分隔线
        Rectangle {
            anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top
            height: 1; color: Theme.border
        }
        Row {
            height: parent.height
            x: -tableView.contentX
            Repeater {
                model: root._cols.length
                delegate: Item {
                    id: fcell
                    required property int index
                    width: root._widths[index] !== undefined ? root._widths[index] : 120
                    height: root.rowHeight
                    readonly property var _f: (root.footerData && index < root.footerData.length) ? root.footerData[index] : ""
                    readonly property bool _isObj: _f !== null && typeof _f === "object"
                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: Theme.space2
                        anchors.rightMargin: Theme.space2
                        text: fcell._isObj ? (fcell._f.text || "") : String(fcell._f)
                        color: Theme.foreground
                        font.pixelSize: Theme.textXs
                        font.weight: (fcell._isObj && fcell._f.medium === false) ? Font.Normal : Font.Medium
                        horizontalAlignment: fcell._isObj && fcell._f.align ? fcell._f.align
                                             : root._align(root._cols[fcell.index])
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }

    // ==== 表说明(caption-bottom)====
    Text {
        id: captionText
        visible: root.caption !== ""
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        horizontalAlignment: Text.AlignHCenter
        text: root.caption
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
    }
}
