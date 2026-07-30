import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C

/*!
    \qmltype Command
    \inqmlmodule Shadcn
    \inherits Rectangle
    \brief A command palette: a search field over a filterable, grouped item list
           with an empty-state fallback.
    \image command.png


    Command is a self-contained, data-driven port of shadcn/ui's cmdk-based
    \c Command (base-mira). Content is described declaratively through \l model
    (an array of groups), mirroring the approach used by Select.qml in this
    repository, rather than via composed child elements.

    Styling authority is style-mira.css: \c{.cn-command} panel is \c bg-popover
    \c rounded-xl \c p-1; the list is capped at \c max-h-72 (288px); each item is
    \c min-h-7 with \c gap-2 \c px-2.5 \c py-1.5 \c rounded-md; the selected /
    hovered row uses \c data-selected:bg-muted with \c text-foreground; the
    trailing shortcut is \c text-[0.625rem] \c tracking-widest and turns to
    \c foreground when selected.

    \section2 Data model

    \l model is an array of groups:
    \c{[ { heading?, items: [ { text, icon?, shortcut?, disabled? } ] }, ... ]}.
    A separator is inserted automatically between any two groups that still have
    visible items (matching the official CommandSeparator usage). Filtering is a
    case-insensitive substring match against each item's \c text; a group whose
    items are all filtered out hides its heading and its separator too.

    \section2 Hosting in a dialog

    To reproduce command-dialog (Cmd-K), place Command as the content of a Dialog
    with the dialog's padding set to 0 and its close button hidden, then call
    \l focusInput() once the dialog opens to focus the search field.
*/
Rectangle {
    id: root

    // ==== Public API ====

    /*! \qmlproperty var Command::model
        Grouped content. Array of \c{{ heading?, items: [{ text, icon?,
        shortcut?, disabled? }] }}. See the type description for details. */
    property var model: []

    /*! \qmlproperty string Command::placeholder
        Placeholder text shown in the search field while it is empty. */
    property string placeholder: qsTr("Type a command or search...")

    /*! \qmlproperty string Command::emptyText
        Message shown when no item matches the current query. */
    property string emptyText: qsTr("No results found.")

    /*! \qmlproperty bool Command::showBorder
        When true, renders as an inline card (border + rounded-lg) instead of a
        borderless popover panel (rounded-xl). */
    property bool showBorder: false

    /*! \qmlproperty string Command::query
        The current search text (readable and writable); editing it re-filters. */
    property alias query: searchField.text

    /*! \qmlproperty int Command::currentIndex
        Read-only index, within the flattened visible rows, of the highlighted
        row, or -1 when nothing is highlighted. */
    readonly property int currentIndex: _current

    /*! \qmlsignal Command::triggered(var item)
        Emitted when an item row is activated by click or Enter. \a item is the
        row object \c{{ text, icon, shortcut, disabled }}. */
    signal triggered(var item)

    /*! \qmlmethod void Command::focusInput()
        Moves keyboard focus to the search field (call after a hosting dialog
        opens). */
    function focusInput() { searchField.forceActiveFocus() }

    /*! \qmlmethod void Command::reset()
        Clears the search text, which restores the full item list. */
    function reset() { searchField.text = "" }

    // ==== Internal state ====
    property var _rows: []            // Flattened visible rows: { type: "heading"|"item"|"separator", ... }
    property int _current: -1         // Highlighted row index

    color: Theme.popover
    radius: showBorder ? Theme.radiusLg : Theme.radiusXl     // inline rounded-lg / panel rounded-xl
    border.width: showBorder ? 1 : 0
    border.color: Theme.border
    implicitWidth: 400
    implicitHeight: col.implicitHeight + 2 * Theme.space1     // p-1
    clip: true

    // Filter the model and rebuild the flattened row list.
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
            if (rows.length > 0)                              // separator between groups
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

    // Move the highlight between selectable items (skipping headings, separators
    // and disabled items), wrapping around at either end.
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

        // ==== Search field (input-wrapper p-1 pb-0 -> 4 on top/left/right;
        //      input-group bg-input/20 h-8) ====
        Rectangle {
            id: inputGroup
            Layout.fillWidth: true
            Layout.leftMargin: Theme.space1
            Layout.rightMargin: Theme.space1
            Layout.topMargin: Theme.space1
            implicitHeight: 32               // h-8
            radius: Theme.radiusMd
            color: Theme.alpha(Theme.input, Theme.input.a * (Theme.dark ? 0.3 : 0.2))   // bg-input/20 dark:/30

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.space2_5   // px-2.5
                anchors.rightMargin: Theme.space2_5
                spacing: Theme.space2                // gap-2

                Icon {
                    name: "search"
                    size: 14                         // size-3.5
                    color: Theme.foreground
                    opacity: 0.5                     // opacity-50
                }
                C.TextField {
                    id: searchField
                    Layout.fillWidth: true
                    padding: 0
                    background: null                 // group background comes from inputGroup (outline-hidden)
                    font.pixelSize: Theme.textXs     // text-xs
                    color: Theme.foreground
                    placeholderText: root.placeholder
                    placeholderTextColor: Theme.mutedForeground
                    selectionColor: Theme.alpha(Theme.primary, 0.35)
                    selectedTextColor: Theme.foreground
                    verticalAlignment: TextInput.AlignVCenter
                    onTextChanged: root._rebuild()
                    // Consume the navigation keys so they do not propagate to a
                    // hosting dialog (e.g. Enter triggering a default button).
                    Keys.onDownPressed: (event) => { root._move(1); event.accepted = true }
                    Keys.onUpPressed: (event) => { root._move(-1); event.accepted = true }
                    Keys.onReturnPressed: (event) => { root._activate(root._current); event.accepted = true }
                    Keys.onEnterPressed: (event) => { root._activate(root._current); event.accepted = true }
                }
            }
        }

        // ==== List area (list max-h-72 = 288) / empty-state message ====
        Item {
            Layout.fillWidth: true
            Layout.leftMargin: Theme.space1
            Layout.rightMargin: Theme.space1
            Layout.topMargin: Theme.space1
            implicitHeight: root._rows.length === 0
                ? empty.implicitHeight
                : Math.min(list.contentHeight, 288)

            // Empty state (cn-command-empty: py-6 text-center text-xs)
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
                // .cn-command-list no-scrollbar -> no scroll bar drawn

                delegate: Item {
                    id: rowItem
                    required property int index
                    required property var modelData
                    width: ListView.view ? ListView.view.width : 0
                    height: modelData.type === "separator" ? 9      // h-px + my-1
                          : modelData.type === "heading" ? 26       // px-2.5 py-1.5 text-xs
                          : 28                                       // min-h-7

                    readonly property bool _selected: root._current === index

                    // ---- Separator (cn-command-separator: bg-border/50 -mx-1 my-1 h-px) ----
                    Rectangle {
                        visible: rowItem.modelData.type === "separator"
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: -Theme.space1        // -mx-1 (relative to group p-1)
                        anchors.rightMargin: -Theme.space1
                        anchors.verticalCenter: parent.verticalCenter
                        height: 1
                        color: Theme.alpha(Theme.border, 0.5)
                    }

                    // ---- Group heading (cmdk-group-heading: text-muted-foreground px-2.5 py-1.5 text-xs) ----
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

                    // ---- Item (cn-command-item) ----
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

                            Icon {
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
