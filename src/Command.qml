import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import LucideIcons

// shadcn Command(命令面板)—— 顶部搜索框 + 分组的可过滤条目列表 + 空结果提示。
// 自包含、数据驱动:与本仓 Select.qml 一致用 model 数组描述内容(QML 侧对 cmdk 的等价表达)。
//
// 样式权威:style-mira.css 的 .cn-command / -input-wrapper / -input-group / -input-icon /
//   -input / -list / -empty / -group / -separator / -item / -shortcut(见 registry/styles)。
//   面板 bg-popover rounded-xl p-1;列表 max-h-72;条目 min-h-7 gap-2 px-2.5 py-1.5 rounded-md;
//   选中/悬停 data-selected:bg-muted + text-foreground(mira 中 muted===accent 同色);
//   右侧 shortcut text-[0.625rem] tracking-widest,选中时转 foreground。
//
// 数据 API(model):[ { heading?, items: [ { text, icon?, shortcut?, disabled? } ] }, … ]
//   相邻两个「有可见项」的分组间自动插入分隔线(对齐官方 CommandSeparator 用法)。
//   过滤:按 text 大小写不敏感子串匹配;某组全部被过滤则该组标题/分隔线一并隐藏。
//
// 承载于 Dialog(command-dialog / ⌘K)时,把本组件作为 Dialog 内容,并设 Dialog padding:0、
//   showCloseButton:false;打开后调用 focusInput() 聚焦搜索框。
Rectangle {
    id: root

    // ==== 公开 API ====
    property var model: []                                   // 分组数据(见文件头)
    property string placeholder: qsTr("Type a command or search...")
    property string emptyText: qsTr("No results found.")
    property bool showBorder: false                          // 内联用法(max-w-sm rounded-lg border)
    property alias query: searchField.text                   // 搜索文本(可读写)
    readonly property int currentIndex: _current             // 当前高亮的行下标(_rows 内)

    // 条目被激活(点击 / 回车)时触发,item 为该行对象 { text, icon, shortcut, disabled }。
    signal triggered(var item)

    function focusInput() { searchField.forceActiveFocus() } // Dialog 打开后聚焦搜索框
    function reset() { searchField.text = "" }               // 清空搜索

    // ==== 内部状态 ====
    property var _rows: []            // 扁平可见行:{ type: "heading"|"item"|"separator", … }
    property int _current: -1         // 高亮行下标

    color: Theme.popover
    radius: showBorder ? Theme.radiusLg : Theme.radiusXl     // 内联 rounded-lg / 面板 rounded-xl
    border.width: showBorder ? 1 : 0
    border.color: Theme.border
    implicitWidth: 400
    implicitHeight: col.implicitHeight + 2 * Theme.space1     // p-1
    clip: true

    // 过滤 + 重建扁平行模型。
    function _rebuild() {
        var q = String(searchField.text).trim().toLowerCase()
        var rows = []
        var groups = root.model || []
        for (var g = 0; g < groups.length; g++) {
            var grp = groups[g]
            var items = grp.items || []
            var matched = []
            for (var i = 0; i < items.length; i++) {
                var it = items[i]
                var label = String(it.text || "").toLowerCase()
                if (q === "" || label.indexOf(q) !== -1)
                    matched.push(it)
            }
            if (matched.length === 0)
                continue
            if (rows.length > 0)                              // 分组间分隔线
                rows.push({ type: "separator" })
            if (grp.heading)
                rows.push({ type: "heading", text: String(grp.heading) })
            for (var j = 0; j < matched.length; j++) {
                var m = matched[j]
                rows.push({ type: "item",
                            text: String(m.text || ""),
                            icon: String(m.icon || ""),
                            shortcut: String(m.shortcut || ""),
                            disabled: m.disabled === true })
            }
        }
        root._rows = rows
        _selectFirst()
    }

    function _selectFirst() {
        for (var i = 0; i < _rows.length; i++) {
            if (_rows[i].type === "item" && !_rows[i].disabled) {
                _current = i
                return
            }
        }
        _current = -1
    }

    // 在可选条目间移动高亮(跳过标题/分隔线/禁用项),循环。
    function _move(dir) {
        var n = _rows.length
        if (n === 0) return
        var i = _current
        for (var step = 0; step < n; step++) {
            i += dir
            if (i < 0) i = n - 1
            else if (i >= n) i = 0
            if (_rows[i].type === "item" && !_rows[i].disabled) {
                _current = i
                list.positionViewAtIndex(i, ListView.Contain)
                return
            }
        }
    }

    function _activate(i) {
        if (i < 0 || i >= _rows.length) return
        var row = _rows[i]
        if (row.type === "item" && !row.disabled)
            root.triggered(row)
    }

    onModelChanged: _rebuild()
    Component.onCompleted: _rebuild()

    ColumnLayout {
        id: col
        anchors.fill: parent
        anchors.margins: Theme.space1        // .cn-command p-1
        spacing: 0

        // ==== 搜索框(input-wrapper p-1 pb-0 → 上/左/右各 4;input-group bg-input/20 h-8)====
        Rectangle {
            id: inputGroup
            Layout.fillWidth: true
            Layout.leftMargin: Theme.space1
            Layout.rightMargin: Theme.space1
            Layout.topMargin: Theme.space1
            implicitHeight: 32               // h-8
            radius: Theme.radiusMd
            color: Theme.alpha(Theme.input, Theme.dark ? 0.3 : 0.2)   // bg-input/20 dark:/30

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.space2_5   // px-2.5
                anchors.rightMargin: Theme.space2_5
                spacing: Theme.space2                // gap-2

                LucideIcon {
                    name: "search"
                    size: 14                         // size-3.5
                    color: Theme.foreground
                    opacity: 0.5                     // opacity-50
                }
                C.TextField {
                    id: searchField
                    Layout.fillWidth: true
                    padding: 0
                    background: null                 // 组底色由 inputGroup 提供(outline-hidden)
                    font.pixelSize: Theme.textXs     // text-xs
                    color: Theme.foreground
                    placeholderText: root.placeholder
                    placeholderTextColor: Theme.mutedForeground
                    selectionColor: Theme.alpha(Theme.primary, 0.35)
                    selectedTextColor: Theme.foreground
                    verticalAlignment: TextInput.AlignVCenter
                    onTextChanged: root._rebuild()
                    Keys.onDownPressed: root._move(1)
                    Keys.onUpPressed: root._move(-1)
                    Keys.onReturnPressed: root._activate(root._current)
                    Keys.onEnterPressed: root._activate(root._current)
                }
            }
        }

        // ==== 列表区(list max-h-72 = 288)/ 空结果提示 ====
        Item {
            Layout.fillWidth: true
            Layout.leftMargin: Theme.space1
            Layout.rightMargin: Theme.space1
            Layout.topMargin: Theme.space1
            implicitHeight: root._rows.length === 0
                ? empty.implicitHeight
                : Math.min(list.contentHeight, 288)

            // 空结果(cn-command-empty: py-6 text-center text-xs)
            Text {
                id: empty
                visible: root._rows.length === 0
                anchors.fill: parent
                text: root.emptyText
                color: Theme.foreground
                font.pixelSize: Theme.textXs
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                topPadding: Theme.space6          // py-6
                bottomPadding: Theme.space6
            }

            ListView {
                id: list
                visible: root._rows.length > 0
                anchors.fill: parent
                model: root._rows
                clip: true
                interactive: contentHeight > height
                boundsBehavior: Flickable.StopAtBounds
                // .cn-command-list no-scrollbar → 不显示滚动条

                delegate: Item {
                    id: rowItem
                    required property int index
                    required property var modelData
                    width: ListView.view ? ListView.view.width : 0
                    height: modelData.type === "separator" ? 9      // h-px + my-1
                          : modelData.type === "heading" ? 26       // px-2.5 py-1.5 text-xs
                          : 28                                       // min-h-7

                    readonly property bool _selected: root._current === index

                    // ---- 分隔线(cn-command-separator: bg-border/50 -mx-1 my-1 h-px)----
                    Rectangle {
                        visible: rowItem.modelData.type === "separator"
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: -Theme.space1        // -mx-1(相对 group p-1)
                        anchors.rightMargin: -Theme.space1
                        anchors.verticalCenter: parent.verticalCenter
                        height: 1
                        color: Theme.alpha(Theme.border, 0.5)
                    }

                    // ---- 分组标题(cmdk-group-heading: text-muted-foreground px-2.5 py-1.5 text-xs)----
                    Text {
                        visible: rowItem.modelData.type === "heading"
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: Theme.space2_5
                        anchors.rightMargin: Theme.space2_5
                        anchors.verticalCenter: parent.verticalCenter
                        text: rowItem.modelData.text || ""
                        color: Theme.mutedForeground
                        font.pixelSize: Theme.textXs
                        font.weight: Font.Medium
                        elide: Text.ElideRight
                    }

                    // ---- 条目(cn-command-item)----
                    Rectangle {
                        visible: rowItem.modelData.type === "item"
                        anchors.fill: parent
                        radius: Theme.radiusMd                   // rounded-md
                        color: rowItem._selected ? Theme.muted : "transparent"  // data-selected:bg-muted
                        opacity: rowItem.modelData.disabled ? 0.5 : 1.0         // data-disabled:opacity-50

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: Theme.space2_5   // px-2.5
                            anchors.rightMargin: Theme.space2_5
                            spacing: Theme.space2                // gap-2

                            readonly property color _fg: rowItem._selected
                                ? Theme.foreground : Theme.popoverForeground

                            LucideIcon {
                                visible: (rowItem.modelData.icon || "") !== ""
                                name: rowItem.modelData.icon || ""
                                size: 14                         // svg size-3.5
                                color: parent._fg
                                Layout.preferredWidth: visible ? 14 : 0
                                Layout.preferredHeight: 14
                            }
                            Text {
                                text: rowItem.modelData.text || ""
                                font.pixelSize: Theme.textXs
                                color: parent._fg
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                                Layout.fillWidth: true
                            }
                            Text {                                // cn-command-shortcut
                                visible: (rowItem.modelData.shortcut || "") !== ""
                                text: rowItem.modelData.shortcut || ""
                                font.pixelSize: 10               // text-[0.625rem]
                                font.letterSpacing: 1            // tracking-widest
                                color: rowItem._selected ? Theme.foreground : Theme.mutedForeground
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: rowItem.modelData.disabled
                                ? Qt.ArrowCursor : Qt.PointingHandCursor
                            enabled: !rowItem.modelData.disabled
                            onEntered: root._current = rowItem.index
                            onClicked: root._activate(rowItem.index)
                        }
                    }
                }
            }
        }
    }
}
