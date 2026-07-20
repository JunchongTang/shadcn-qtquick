import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import QtQuick.Effects
import LucideIcons

// shadcn Combobox(base-nova)—— 可编辑的自动补全输入框 + 纯列表弹层。
// 对齐官方:触发器本身就是一个 ComboboxInput(可打字过滤、显光标/焦点环),
// 弹层里只有条目列表 + 空态,**没有独立搜索框**。
//
//   · 单选:ComboboxInput,右侧 chevrons-up-down;可选 showClear 显清除 ×;
//     打字即过滤;选中回填标签并关闭;再次选中同值清空(setValue(cur===v?"":cur))。
//   · 多选(multiple):chips 容器 + 内联 ComboboxChipsInput(打字过滤),
//     下拉项左侧显勾选;切换不关闭;chip 的 × 逐个移除。
//
// 模型条目:字符串 | { value,label(可配 textRole/valueRole),disabled? } | { header } | { separator }。
// 根用 C.Control(容器):拿 hovered/visualFocus/font/enabled/palette 传播;focusPolicy 默认 NoFocus,
// 不与内部触发器输入框争焦点(焦点始终落在 TextField 上)。
C.Control {
    id: control

    property var model: []
    property string textRole: "label"
    property string valueRole: "value"
    property string placeholder: qsTr("Select...")
    property string searchPlaceholder: ""     // 兼容旧用法:base-nova 无独立搜索框,已废弃(无操作)
    property string emptyText: qsTr("No results found.")
    property string currentValue: ""
    property bool invalid: false
    property bool showClear: false            // 单选:显示清除按钮(对标 ComboboxInput showClear)
    property string leadingIcon: ""           // 单选:输入框左侧前置图标(对标 InputGroupAddon)
    property string descriptionRole: "description"  // 条目次级说明文字的键(两行条目,对标 ItemDescription)

    property bool multiple: false
    property var selectedValues: []

    readonly property string currentText: _labelForValue(currentValue)

    signal activated(string value)

    implicitWidth: 200
    implicitHeight: multiple ? chipsTrigger.implicitHeight : 28

    // ==== 模型工具 ====
    function _isObj(it) { return typeof it === "object" && it !== null }
    function _label(it) {
        if (!_isObj(it)) return String(it)
        if (it[textRole] !== undefined) return String(it[textRole])
        if (it.modelData !== undefined) return String(it.modelData)
        return ""
    }
    function _value(it) {
        if (!_isObj(it)) return String(it)
        if (it[valueRole] !== undefined) return String(it[valueRole])
        return _label(it)
    }
    function _labelForValue(v) {
        if (v === "") return ""
        for (var i = 0; i < model.length; i++) {
            var it = model[i]
            if (_isObj(it) && (it.header !== undefined || it.separator === true)) continue
            if (_value(it) === v) return _label(it)
        }
        return ""
    }

    // ==== 过滤查询:弹层打开且用户已打字时,取对应输入框的文本;否则为空(显示全部)====
    property bool _typed: false
    readonly property string _effQuery: {
        if (!pop.opened) return ""
        if (multiple) return chipsInput.text
        return _typed ? input.text : ""
    }

    readonly property var _rows: {
        var out = []
        var pendingHeader = null
        var q = _effQuery.toLowerCase()
        for (var i = 0; i < model.length; i++) {
            var it = model[i]
            if (_isObj(it) && it.header !== undefined) { pendingHeader = String(it.header); continue }
            if (_isObj(it) && it.separator === true) {
                if (out.length > 0 && out[out.length - 1].type !== "sep") out.push({ type: "sep" })
                continue
            }
            var lbl = _label(it)
            if (q === "" || lbl.toLowerCase().indexOf(q) >= 0) {
                if (pendingHeader !== null) { out.push({ type: "header", label: pendingHeader }); pendingHeader = null }
                out.push({ type: "item", label: lbl, value: _value(it),
                           description: _isObj(it) && it[descriptionRole] !== undefined ? String(it[descriptionRole]) : "",
                           disabled: _isObj(it) && it.disabled === true })
            }
        }
        while (out.length > 0 && out[out.length - 1].type === "sep") out.pop()
        return out
    }

    // ==== 键盘高亮 ====
    property int _highlight: -1
    function _step(dir) {
        var n = _rows.length
        if (n === 0) { _highlight = -1; return }
        var i = _highlight
        for (var c = 0; c < n; c++) {
            i = (i + dir + n) % n
            if (_rows[i].type === "item" && !_rows[i].disabled) { _highlight = i; return }
        }
    }
    function _select(v) {
        currentValue = (v === currentValue ? "" : v)
        activated(currentValue)
        _typed = false
        pop.close()
        input.text = currentText
    }
    function _toggle(v) {
        var arr = selectedValues.slice()
        var idx = arr.indexOf(v)
        if (idx >= 0) arr.splice(idx, 1); else arr.push(v)
        selectedValues = arr
        activated(v)
        chipsInput.text = ""
    }
    function _remove(v) {
        var arr = selectedValues.slice()
        var idx = arr.indexOf(v)
        if (idx < 0) return
        arr.splice(idx, 1)
        selectedValues = arr
        activated(v)
    }
    function _choose(v) { if (multiple) _toggle(v); else _select(v) }
    function _confirm() { if (_highlight >= 0 && _rows[_highlight].type === "item") _choose(_rows[_highlight].value) }
    function _clear() {
        currentValue = ""
        activated("")
        _typed = false
        input.text = ""
        input.forceActiveFocus()
    }

    // 选中值外部变化时,同步单选输入框显示(未在编辑中时)。
    onCurrentValueChanged: if (!input.activeFocus) input.text = currentText
    Component.onCompleted: if (!multiple) input.text = currentText

    // ==== 单选触发器:可编辑输入框(ComboboxInput)====
    C.TextField {
        id: input
        visible: !control.multiple
        anchors.fill: parent
        enabled: control.enabled
        leftPadding: Theme.space2 + (control.leadingIcon !== "" ? (14 + Theme.space1_5) : 0)
        // 右侧恒为单个 20px 图标按钮(箭头或清除,二选一,不同时出现)+ 两侧留白。
        rightPadding: Theme.space1 + 20 + Theme.space1
        topPadding: 0; bottomPadding: 0
        font.pixelSize: Theme.textXs
        color: Theme.foreground
        placeholderText: control.placeholder
        placeholderTextColor: Theme.mutedForeground
        selectionColor: Theme.alpha(Theme.primary, 0.35)
        selectedTextColor: Theme.foreground
        verticalAlignment: TextInput.AlignVCenter
        opacity: enabled ? 1.0 : 0.5

        onActiveFocusChanged: {
            // 聚焦(点击)只打开弹层,不选中文本(对齐官网:点击不高亮已有文字)。
            if (activeFocus) { control._typed = false; pop.open() }
            else if (!pop.opened) input.text = control.currentText
        }
        onTextEdited: { control._typed = true; if (!pop.opened) pop.open(); control._highlight = -1 }
        Keys.onDownPressed: { if (!pop.opened) pop.open(); control._step(1) }
        Keys.onUpPressed: { if (!pop.opened) pop.open(); control._step(-1) }
        Keys.onReturnPressed: control._confirm()
        Keys.onEnterPressed: control._confirm()
        Keys.onEscapePressed: pop.close()

        background: Rectangle {
            id: bg
            radius: Theme.radiusMd
            color: control.invalid ? Theme.alpha(Theme.input, 0) : Theme.alpha(Theme.input, 0.2)  // bg-input/20
            border.width: 1
            border.color: control.invalid ? Theme.destructive
                          : input.activeFocus ? Theme.ring : Theme.border
            Behavior on border.color { ColorAnimation { duration: Theme.durFast } }

            Rectangle {
                anchors.fill: parent
                anchors.margins: -Theme.ringWidth
                radius: bg.radius + Theme.ringWidth
                color: "transparent"
                border.width: Theme.ringWidth
                border.color: Theme.alpha(Theme.destructive, Theme.dark ? 0.4 : 0.2)
                visible: control.invalid
                z: -1
            }
            // 文本输入:聚焦即算 focus-visible,故用 activeFocus。
            FocusRing { active: input.activeFocus && !control.invalid; targetRadius: bg.radius }
        }

        // 左侧前置图标(可选)
        LucideIcon {
            visible: control.leadingIcon !== ""
            anchors.left: parent.left
            anchors.leftMargin: Theme.space2
            anchors.verticalCenter: parent.verticalCenter
            name: control.leadingIcon
            size: 14
            color: Theme.mutedForeground
        }

        // 右侧:清除(可选)+ chevron(小方按钮,hover 显 accent 底)
        Row {
            anchors.right: parent.right
            anchors.rightMargin: Theme.space1
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0

            // 清除按钮(showClear 且有值时)
            Rectangle {
                width: 20; height: 20
                radius: Theme.radiusSm
                visible: control.showClear && control.currentValue !== ""
                color: clearHover.hovered ? Theme.accent : Theme.alpha(Theme.accent, 0)
                LucideIcon {
                    anchors.centerIn: parent
                    name: "x"; size: 14
                    color: Theme.mutedForeground
                }
                HoverHandler { id: clearHover; cursorShape: Qt.PointingHandCursor }
                TapHandler { onTapped: control._clear() }
            }

            // 下拉箭头(对标官方:向下箭头 + hover 背景)。有清除键时不显示(二选一)。
            Rectangle {
                width: 20; height: 20
                radius: Theme.radiusSm
                visible: !(control.showClear && control.currentValue !== "")
                color: chevHover.hovered ? Theme.accent : Theme.alpha(Theme.accent, 0)
                LucideIcon {
                    anchors.centerIn: parent
                    name: "chevron-down"; size: 14
                    color: Theme.mutedForeground
                    opacity: chevHover.hovered ? 0.9 : 0.6
                }
                HoverHandler { id: chevHover; cursorShape: Qt.PointingHandCursor }
                TapHandler {
                    onTapped: {
                        if (pop.opened) pop.close()
                        else { input.forceActiveFocus(); pop.open() }
                    }
                }
            }
        }
    }

    // ==== 多选触发器:chips 容器 + 内联输入 ====
    Item {
        id: chipsTrigger
        objectName: "cbChipsTrigger"        // 供单测定位
        visible: control.multiple
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        opacity: control.enabled ? 1.0 : 0.5

        readonly property bool _hasChips: control.selectedValues.length > 0
        readonly property real _padX: _hasChips ? Theme.space1 : Theme.space2
        // 上下内边距 = 行间距(space1),使多行 chips 的第一行上下对称(此前用 space0_5 与行间距不等)。
        implicitHeight: Math.max(28, flow.implicitHeight + 2 * Theme.space1)
        height: implicitHeight

        Rectangle {
            id: chipsBg
            anchors.fill: parent
            radius: Theme.radiusMd
            color: control.invalid ? Theme.alpha(Theme.input, 0)
                   : Theme.dark ? Theme.alpha(Theme.input, 0.3) : Theme.alpha(Theme.input, 0.2)
            border.width: 1
            border.color: control.invalid ? Theme.destructive
                          : chipsInput.activeFocus ? Theme.ring : Theme.input
            Behavior on border.color { ColorAnimation { duration: Theme.durFast } }

            Rectangle {
                anchors.fill: parent
                anchors.margins: -Theme.ringWidth
                radius: chipsBg.radius + Theme.ringWidth
                color: "transparent"
                border.width: Theme.ringWidth
                border.color: Theme.alpha(Theme.destructive, Theme.dark ? 0.4 : 0.2)
                visible: control.invalid
                z: -1
            }
            FocusRing { active: chipsInput.activeFocus && !control.invalid; targetRadius: chipsBg.radius }
        }

        Flow {
            id: flow
            objectName: "cbChipsFlow"       // 供单测定位
            anchors.verticalCenter: parent.verticalCenter
            x: chipsTrigger._padX
            width: parent.width - 2 * chipsTrigger._padX
            spacing: Theme.space1

            Repeater {
                model: control.selectedValues
                delegate: ComboboxChip {
                    required property var modelData
                    text: control._labelForValue(modelData)
                    onRemoved: control._remove(modelData)
                }
            }

            // 内联输入(ComboboxChipsInput):打字过滤;空态显 placeholder。
            C.TextField {
                id: chipsInput
                // 固定宽度,避免用自身 x 计算宽度形成循环绑定 / 误换行(曾致容器虚高两行)。
                width: 90
                height: 19                                  // 与 chip 等高,行内对齐
                padding: 0
                leftPadding: Theme.space1
                font.pixelSize: Theme.textXs
                color: Theme.foreground
                placeholderText: chipsTrigger._hasChips ? "" : control.placeholder
                placeholderTextColor: Theme.mutedForeground
                verticalAlignment: TextInput.AlignVCenter
                background: null
                onActiveFocusChanged: if (activeFocus) pop.open()
                onTextEdited: { if (!pop.opened) pop.open(); control._highlight = -1 }
                Keys.onDownPressed: { if (!pop.opened) pop.open(); control._step(1) }
                Keys.onUpPressed: { if (!pop.opened) pop.open(); control._step(-1) }
                Keys.onReturnPressed: control._confirm()
                Keys.onEnterPressed: control._confirm()
                Keys.onEscapePressed: pop.close()
                // 输入为空时按 Backspace/Delete 删除最后一个已选标签(对齐官网键盘移除)。
                Keys.onPressed: function (event) {
                    if ((event.key === Qt.Key_Backspace || event.key === Qt.Key_Delete)
                            && chipsInput.text === "" && control.selectedValues.length > 0) {
                        control._remove(control.selectedValues[control.selectedValues.length - 1])
                        event.accepted = true
                    }
                }
            }
        }
    }

    // ==== 弹层:仅列表 + 空态(无搜索框)====
    C.Popup {
        id: pop
        y: control.height + 4
        x: 0
        width: control.width
        padding: 0
        modal: false
        dim: false
        focus: false                                   // 不夺焦:键盘由触发器输入框处理
        closePolicy: C.Popup.CloseOnEscape | C.Popup.CloseOnPressOutside

        readonly property int _listMax: 260
        implicitHeight: Math.min(col.implicitHeight, pop._listMax)

        onClosed: {
            control._typed = false
            control._highlight = -1
            // 关闭(含点击外部/空白处)时让触发器输入框失焦 → 焦点环消失,对齐 web 点外部失焦。
            if (!control.multiple) { input.text = control.currentText; input.focus = false }
            else { chipsInput.text = ""; chipsInput.focus = false }
        }

        background: Rectangle {
            radius: Theme.radiusLg
            color: Theme.popover
            border.width: Theme.overlayRingWidth
            border.color: Theme.overlayRing
            layer.enabled: true
            layer.effect: MultiEffect {
                autoPaddingEnabled: true
                shadowEnabled: true
                shadowColor: Theme.shadowColor
                shadowBlur: Theme.shadowBlur
                shadowVerticalOffset: Theme.shadowOffset
            }
        }

        // 仅缩放弹入,面板不透明(避免透出黑遮罩;与其它浮层一致)。
        enter: Transition { NumberAnimation { property: "scale"; from: 0.97; to: 1; duration: Theme.durFast; easing.type: Easing.OutCubic } }
        exit: Transition { NumberAnimation { property: "scale"; from: 1; to: 0.97; duration: Theme.durFast } }

        contentItem: ColumnLayout {
            id: col
            spacing: 0

            Text {
                Layout.fillWidth: true
                visible: control._rows.length === 0
                text: control.emptyText
                horizontalAlignment: Text.AlignHCenter
                topPadding: Theme.space6
                bottomPadding: Theme.space6
                color: Theme.mutedForeground
                font.pixelSize: Theme.textXs
            }

            ListView {
                id: list
                visible: control._rows.length > 0
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(contentHeight + 2 * Theme.space1, pop._listMax)
                clip: true
                topMargin: Theme.space1; bottomMargin: Theme.space1
                leftMargin: Theme.space1; rightMargin: Theme.space1
                boundsBehavior: Flickable.StopAtBounds
                model: control._rows
                currentIndex: control._highlight
                C.ScrollIndicator.vertical: C.ScrollIndicator {}

                delegate: Item {
                    id: row
                    required property int index
                    required property var modelData
                    width: ListView.view ? ListView.view.width - 2 * Theme.space1 : 0
                    x: Theme.space1
                    readonly property bool _isItem: modelData.type === "item"
                    readonly property bool _isHeader: modelData.type === "header"
                    readonly property bool _isSep: modelData.type === "sep"
                    readonly property bool _selected: _isItem && (control.multiple
                        ? control.selectedValues.indexOf(modelData.value) >= 0
                        : modelData.value === control.currentValue)
                    readonly property bool _highlighted: _isItem && !modelData.disabled
                        && (hover.hovered || control._highlight === index)
                    readonly property bool _hasDesc: _isItem && modelData.description !== undefined && modelData.description !== ""
                    implicitHeight: _isSep ? 9 : (_isHeader ? 26 : (_hasDesc ? 44 : 28))
                    opacity: (_isItem && modelData.disabled) ? 0.5 : 1.0

                    HoverHandler {
                        id: hover
                        enabled: row._isItem && !row.modelData.disabled
                        onHoveredChanged: if (hovered) control._highlight = row.index
                    }
                    TapHandler {
                        enabled: row._isItem && !row.modelData.disabled
                        onTapped: control._choose(row.modelData.value)
                    }

                    Rectangle {
                        anchors.fill: parent
                        visible: row._highlighted
                        radius: Theme.radiusMd
                        color: Theme.accent
                    }
                    Rectangle {
                        visible: row._isSep
                        anchors.left: parent.left; anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        height: 1
                        color: Theme.alpha(Theme.border, 0.5)
                    }
                    Text {
                        visible: row._isHeader
                        anchors.left: parent.left; anchors.leftMargin: Theme.space2
                        anchors.verticalCenter: parent.verticalCenter
                        text: row._isHeader ? row.modelData.label : ""
                        font.pixelSize: Theme.textXs
                        color: Theme.mutedForeground
                        elide: Text.ElideRight
                    }
                    LucideIcon {
                        id: leftCheck
                        anchors.left: parent.left; anchors.leftMargin: Theme.space2
                        anchors.verticalCenter: parent.verticalCenter
                        name: "check"; size: 14
                        color: row._highlighted ? Theme.accentForeground : Theme.foreground
                        visible: control.multiple && row._selected
                    }
                    Column {
                        visible: row._isItem
                        anchors.left: parent.left
                        anchors.leftMargin: control.multiple ? Theme.space2 + Theme.space5 : Theme.space2
                        anchors.right: check.left
                        anchors.rightMargin: Theme.space1
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 1
                        Text {
                            width: parent.width
                            text: row._isItem ? row.modelData.label : ""
                            font.pixelSize: Theme.textXs
                            color: row._highlighted ? Theme.accentForeground : Theme.foreground
                            elide: Text.ElideRight
                        }
                        Text {
                            visible: row._hasDesc
                            width: parent.width
                            text: row._hasDesc ? row.modelData.description : ""
                            font.pixelSize: 11
                            color: row._highlighted ? Theme.alpha(Theme.accentForeground, 0.75) : Theme.mutedForeground
                            elide: Text.ElideRight
                        }
                    }
                    LucideIcon {
                        id: check
                        anchors.right: parent.right; anchors.rightMargin: Theme.space2
                        anchors.verticalCenter: parent.verticalCenter
                        name: "check"; size: 14
                        color: row._highlighted ? Theme.accentForeground : Theme.foreground
                        visible: row._selected && !control.multiple
                    }
                }
            }
        }
    }
}
