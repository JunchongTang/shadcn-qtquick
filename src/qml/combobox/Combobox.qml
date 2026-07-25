import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import QtQuick.Effects
import LucideIcons

/*!
    \qmltype Combobox
    \inqmlmodule Shadcn
    \inherits Control
    \brief An editable autocomplete input paired with a plain popup list.
    \image combobox.png


    Combobox reproduces the shadcn (base-mira) look. The trigger itself is an
    editable ComboboxInput: the user can type to filter, and the popup contains
    only the item list plus an empty state (there is no separate search box).

    \list
    \li Single select: an editable input with a trailing chevron and an optional
        \l showClear clear button. Typing filters the list; choosing an item fills
        the label and closes the popup; choosing the current value again clears it.
    \li Multiple select (\l multiple): a chips container with an inline input that
        filters as you type. List items show a leading check; toggling does not
        close the popup; each chip's remove button drops one value.
    \endlist

    Model entries may be a plain string, an object
    \c {{ value, label, disabled?, description? }} (keys configurable via
    \l textRole, \l valueRole and \l descriptionRole), a group header
    \c {{ header: "..." }}, or a divider \c {{ separator: true }}.

    The root is a \c Control container used only to propagate hovered / visualFocus /
    font / enabled / palette; its focusPolicy stays NoFocus so focus always rests on
    the inner trigger input.
*/
C.Control {
    id: control

    /*! \qmlproperty var Combobox::model
        The list of entries. See the type description for the accepted entry shapes. */
    property var model: []

    /*! \qmlproperty string Combobox::textRole
        Object key used for an entry's display label. Defaults to \c "label". */
    property string textRole: "label"

    /*! \qmlproperty string Combobox::valueRole
        Object key used for an entry's value. Defaults to \c "value". */
    property string valueRole: "value"

    /*! \qmlproperty string Combobox::placeholder
        Placeholder text shown in the trigger input when nothing is selected. */
    property string placeholder: qsTr("Select...")

    /*! \qmlproperty string Combobox::searchPlaceholder
        \deprecated The base-mira pattern has no separate search box; this is a no-op
        kept for source compatibility. */
    property string searchPlaceholder: ""

    /*! \qmlproperty string Combobox::emptyText
        Message shown in the popup when the filtered list is empty. */
    property string emptyText: qsTr("No results found.")

    /*! \qmlproperty string Combobox::currentValue
        Selected value in single-select mode (empty string when nothing is selected). */
    property string currentValue: ""

    /*! \qmlproperty bool Combobox::invalid
        When true, renders the destructive border and focus ring (aria-invalid). */
    property bool invalid: false

    /*! \qmlproperty bool Combobox::showClear
        Single-select only: show a clear button (in place of the chevron) when a
        value is selected. Defaults to \c false. */
    property bool showClear: false

    /*! \qmlproperty string Combobox::leadingIcon
        Single-select only: name of a Lucide icon shown before the input text
        (equivalent to an InputGroupAddon). Empty means no icon. */
    property string leadingIcon: ""

    /*! \qmlproperty string Combobox::descriptionRole
        Object key for an entry's secondary description line (two-line items,
        equivalent to ItemDescription). Defaults to \c "description". */
    property string descriptionRole: "description"

    /*! \qmlproperty bool Combobox::multiple
        Enable multiple selection (chips container with inline input). Defaults to \c false. */
    property bool multiple: false

    /*! \qmlproperty var Combobox::selectedValues
        Array of selected values in multiple-select mode. */
    property var selectedValues: []

    /*! \qmlproperty string Combobox::currentText
        \readonly
        Label of \l currentValue resolved against \l model (empty when unresolved). */
    readonly property string currentText: _labelForValue(currentValue)

    /*! \qmlsignal Combobox::activated(string value)
        Emitted when the selection changes. In single-select mode \a value is the new
        current value (empty when cleared). In multiple-select mode \a value is the
        toggled or removed value. */
    signal activated(string value)

    implicitWidth: 200
    implicitHeight: multiple ? chipsTrigger.implicitHeight : 28

    // ==== Model helpers ====
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

    // ==== Filter query: while the popup is open and the user has typed, use the
    // matching input's text; otherwise empty (show everything). ====
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

    // ==== Keyboard highlight ====
    property int _highlight: -1
    // Move the highlight to the next selectable item in direction dir (+1 down,
    // -1 up), skipping headers, separators and disabled items, wrapping around.
    // With nothing highlighted, Down starts at the first item and Up at the last.
    function _step(dir) {
        var n = _rows.length
        if (n === 0) { _highlight = -1; return }
        var i = _highlight < 0 ? (dir > 0 ? -1 : 0) : _highlight
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

    // Sync the single-select input display when currentValue changes externally
    // (only while not being edited).
    onCurrentValueChanged: if (!input.activeFocus) input.text = currentText
    Component.onCompleted: if (!multiple) input.text = currentText

    // ==== Single-select trigger: editable input (ComboboxInput) ====
    C.TextField {
        id: input
        visible: !control.multiple
        anchors.fill: parent
        enabled: control.enabled
        leftPadding: Theme.space2 + (control.leadingIcon !== "" ? (14 + Theme.space1_5) : 0)
        // Right side always holds one 20px icon button (chevron or clear, never
        // both at once) plus padding on each side.
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
            // Focusing (clicking) only opens the popup; it does not select the text
            // (matches the web: a click does not highlight existing text).
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
            // Text input: any focus counts as focus-visible, so use activeFocus.
            FocusRing { active: input.activeFocus && !control.invalid; targetRadius: bg.radius }
        }

        // Optional leading icon
        LucideIcon {
            visible: control.leadingIcon !== ""
            anchors.left: parent.left
            anchors.leftMargin: Theme.space2
            anchors.verticalCenter: parent.verticalCenter
            name: control.leadingIcon
            size: 14
            color: Theme.mutedForeground
        }

        // Right side: clear (optional) + chevron (small square button, accent on hover)
        Row {
            anchors.right: parent.right
            anchors.rightMargin: Theme.space1
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0

            // Clear button (when showClear is set and a value is selected)
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

            // Dropdown chevron (down arrow + hover background). Hidden when the
            // clear button is shown (the two are mutually exclusive).
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

    // ==== Multiple-select trigger: chips container + inline input ====
    Item {
        id: chipsTrigger
        objectName: "cbChipsTrigger"        // for unit-test lookup
        visible: control.multiple
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        opacity: control.enabled ? 1.0 : 0.5

        readonly property bool _hasChips: control.selectedValues.length > 0
        readonly property real _padX: _hasChips ? Theme.space1 : Theme.space2
        // Top/bottom padding equals the row spacing (space1) so the first row of a
        // multi-row chips layout is vertically symmetric.
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
            objectName: "cbChipsFlow"       // for unit-test lookup
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

            // Inline input (ComboboxChipsInput): filters as you type; shows the
            // placeholder when empty.
            C.TextField {
                id: chipsInput
                // Fixed width, to avoid a binding loop / spurious wrapping from
                // deriving width from its own x (which once inflated the container
                // to two rows).
                width: 90
                height: 19                                  // same height as a chip, for inline alignment
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
                // When the input is empty, Backspace/Delete removes the last
                // selected chip (matches the web's keyboard removal).
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

    // ==== Popup: list + empty state only (no search box) ====
    C.Popup {
        id: pop
        y: control.height + 4
        x: 0
        width: control.width
        padding: 0
        modal: false
        dim: false
        focus: false                                   // do not steal focus: the trigger input handles keys
        closePolicy: C.Popup.CloseOnEscape | C.Popup.CloseOnPressOutside

        readonly property int _listMax: 260
        implicitHeight: Math.min(col.implicitHeight, pop._listMax)

        onClosed: {
            control._typed = false
            control._highlight = -1
            // On close (including outside/blank clicks) blur the trigger input so the
            // focus ring disappears, matching the web's blur-on-outside-click.
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

        // Scale-in only; the panel stays opaque (avoids bleeding a dark overlay,
        // consistent with the other popovers).
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
