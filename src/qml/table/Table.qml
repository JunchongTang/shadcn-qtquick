import QtQuick
import Qt.labs.qmlmodels

/*!
    \qmltype Table
    \inqmlmodule Shadcn
    \inherits Item
    \brief A high-performance, model/column-driven data table.
    \image data-table.png

    Table is the shadcn/ui (base-mira) table, reworked for performance: the body
    is a virtualized \c TableView and the header is a self-drawn row with a
    stable per-column resize handle. It is driven by a data \l model and a set of
    column definitions (\l columns, or declarative \l TableColumn children via
    \l columnItems).

    The \l model may be a JavaScript array of row objects, a QML \c TableModel, or
    a C++ \c QAbstractItemModel. Each column definition is an object of the form
    \c {{ title, key, role, width, fillWidth, minWidth, maxWidth, align, format, medium }}:
    \c width is a fixed/preferred pixel width, \c fillWidth lets the column absorb
    the remaining space, \c minWidth / \c maxWidth clamp it, \c key reads a field
    from a JS row object, \c role reads a role from an item model (default
    \c "display"), \c align is one of \c Qt.AlignLeft / \c Right / \c HCenter,
    \c format(v) formats the cell value, and \c medium renders it bold. Dragging a
    column edge records an explicit override width and re-distributes the rest.

    \sa TableColumn
*/
Item {
    id: root

    /*! \qmlproperty var Table::model
        Row data: a JS array of row objects, a QML \c TableModel, or a C++
        \c QAbstractItemModel. */
    property var model: []
    /*! \qmlproperty var Table::columns
        JS column definitions, an array of \c {{ title, key, ... }} objects. */
    property var columns: []
    /*! \qmlproperty list<TableColumn> Table::columnItems
        Declarative \l TableColumn children; when non-empty they take precedence
        over \l columns. */
    property list<TableColumn> columnItems
    // Effective column set: prefer declarative columnItems, else the JS columns.
    readonly property var _cols: (columnItems && columnItems.length > 0) ? columnItems : (columns || [])
    // Freshly computed column set: inside the columns/columnItems change handlers
    // the derived _cols binding is not yet re-evaluated (lazy), so read the source
    // properties directly to avoid rebuilding the model with the previous column
    // set (one step behind -> header/model column-count mismatch).
    function _currentCols() { return (columnItems && columnItems.length > 0) ? columnItems : (columns || []) }
    /*! \qmlproperty string Table::caption
        Optional caption rendered, muted and centered, below the table. */
    property string caption: ""
    /*! \qmlproperty string Table::emptyText
        Centered message shown when there are no data rows. Defaults to \c "No results.". */
    property string emptyText: qsTr("No results.")
    /*! \qmlproperty var Table::footerData
        Optional totals/footer row: a per-column array whose elements are strings
        or \c {{ text, align, medium }} objects. Hidden when empty. */
    property var footerData: []
    readonly property bool _hasFooter: footerData && footerData.length > 0
    /*! \qmlproperty int Table::rowHeight
        Body row height in pixels. Defaults to \c 40. */
    property int rowHeight: 40
    /*! \qmlproperty int Table::headerHeight
        Header row height in pixels. Defaults to \c 40. */
    property int headerHeight: 40
    /*! \qmlproperty real Table::minFillWidth
        Minimum width a fill column may shrink to. Defaults to \c 60. */
    property real minFillWidth: 60

    /*! \qmlproperty TableView Table::view
        The underlying virtualized body \c TableView (read-only). */
    readonly property alias view: tableView
    /*! \qmlproperty int Table::hoverRow
        Index of the currently hovered row, or \c -1. */
    property int hoverRow: -1
    /*! \qmlproperty var Table::selectedRows
        Array of selected row indices; selected rows paint the muted background
        (the web \c data-state=selected). */
    property var selectedRows: []
    /*! \qmlsignal Table::rowClicked(int row)
        Emitted when a body row is tapped; \a row is its index. */
    signal rowClicked(int row)

    implicitWidth: 480
    implicitHeight: headerHeight
                    + (tableView.rows === 0 ? 96 : tableView.contentHeight)   // h-24 placeholder when empty
                    + (_hasFooter ? rowHeight : 0)
                    + (caption !== "" ? captionText.implicitHeight + 16 : 0)

    // ==== Normalize data: JS array -> internal TableModel; otherwise pass through ====
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

    // ==== Column widths (fixed + fill share the remainder; min/max clamp + drag override) ====
    property var _overrides: ({})          // column index -> explicit width after a user drag
    property var _widths: []               // resolved per-column widths (shared by header and body)
    property real _dragStartW: 0

    function _clamp(v, mn, mx) {
        if (mn && mn > 0 && v < mn) v = mn      // 0 / undefined means unbounded
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
            // Fixed = explicit width>0 and not forced fillWidth; everything else fills.
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
        // Fallback fill: if the total is still narrower than the table (no fill column,
        // or fill capped by max), give the remainder to the last column so rows fill fully.
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
    // Column-set change (e.g. show/hide) -> drop index-keyed drag overrides (now misaligned), then rebuild/recompute.
    onColumnsChanged: { root._overrides = ({}); _rebuild(); _recompute() }
    onColumnItemsChanged: { root._overrides = ({}); _rebuild(); _recompute() }
    onModelChanged: _rebuild()
    Component.onCompleted: { _rebuild(); _recompute() }

    // ==== Self-drawn header (a plain Row; scrolls horizontally with the body) ====
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
            x: -tableView.contentX          // stay in sync with the body's horizontal scroll

            Repeater {
                model: root._cols.length
                delegate: Item {
                    id: hcell
                    required property int index
                    width: root._widths[index] !== undefined ? root._widths[index] : 120
                    height: root.headerHeight
                    readonly property var _def: root._cols[index]
                    readonly property bool _custom: _def && _def.headerDelegate !== undefined && _def.headerDelegate !== null

                    // default header text
                    Text {
                        visible: !hcell._custom
                        anchors.fill: parent
                        anchors.leftMargin: Theme.space2
                        anchors.rightMargin: Theme.space2 + 8   // leave room for the right-side handle
                        text: hcell._def ? (hcell._def.title || "") : ""
                        color: Theme.mutedForeground
                        font.pixelSize: Theme.textXs
                        font.weight: Font.Medium
                        horizontalAlignment: root._align(hcell._def)
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    // Custom header (column headerDelegate: Component). Inside it, via parent:
                    //   parent.column (column index), parent.table (the Table)
                    Loader {
                        visible: hcell._custom
                        active: hcell._custom
                        anchors.fill: parent
                        anchors.leftMargin: Theme.space2
                        anchors.rightMargin: Theme.space2   // match the cell margin so custom header/cell (e.g. checkbox) align
                        readonly property int column: hcell.index
                        readonly property var table: root
                        sourceComponent: hcell._custom ? hcell._def.headerDelegate : null
                    }

                    // Column resize handle straddling the right edge (wide hit area + resize cursor). Hidden on the last column (it fills).
                    Item {
                        visible: hcell.index < root._cols.length - 1
                        width: 11
                        height: parent.height
                        anchors.right: parent.right
                        anchors.rightMargin: -5
                        z: 5
                        // plain short vertical divider (constant; no hover/drag highlight)
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
        // header bottom border (full width)
        Rectangle {
            anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
            height: 1; color: Theme.border
        }
    }

    // ==== Body (virtualized TableView) ====
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

            // default text cell
            Text {
                visible: !cellItem._custom
                anchors.fill: parent
                anchors.leftMargin: Theme.space2
                anchors.rightMargin: Theme.space2
                text: {
                    var d = cellItem._def
                    var v = cellItem._raw
                    var s = (v === undefined || v === null) ? "" : String(v)
                    // Wrap format() in try: while columns switch, _def/_raw update out of step, so format may
                    // briefly receive another column's value -> silently fall back to the raw value.
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

            // Custom cell (column cellDelegate: Component). Inside it, via parent:
            //   parent.value, parent.row, parent.rowData (the whole row model), parent.table
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

    // ==== Empty state (centered when there are no rows) ====
    Text {
        visible: tableView.rows === 0
        anchors.horizontalCenter: tableView.horizontalCenter
        anchors.verticalCenter: tableView.verticalCenter
        text: root.emptyText
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
    }

    // ==== Totals/footer row (muted background + medium) ====
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
        // top divider
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

    // ==== Caption (caption-bottom) ====
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
