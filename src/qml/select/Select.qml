import QtQuick
import QtQuick.Controls.Basic as C
import QtQuick.Effects

/*!
    \qmltype Select
    \inqmlmodule Shadcn
    \inherits ComboBox
    \brief A rich dropdown select with a popover list, group labels and per-item check marks.
    \image select.png


    Select is the richer counterpart to \l NativeSelect, styled after shadcn's
    base-mira \c .cn-select-* rules. The trigger shows the selected value (or a
    muted \l placeholder) plus a trailing \c chevron-down; the popover surface is
    a \c rounded-lg card that lists the model with the current row marked by a
    trailing \c check icon and the hovered/highlighted row painted with the
    accent background.

    Visuals: an \c input-colored border over a faint \c {bg-input/20} fill,
    height 28 (24 when \l size is \c Sm), \c rounded-md corners and extra-small
    (\c text-xs) text. Set \l invalid for the aria-invalid destructive border and
    ring, mirroring \l Switch and \l NativeSelect.

    The \l model may be a plain string list or a list of objects. An object with
    a \c header key renders as a non-selectable group label (SelectLabel); an
    object with \c {separator: true} renders as a separator line (SelectSeparator);
    a normal item may carry \c {disabled: true} to disable that single row. Object
    items resolve their label through the standard \c textRole.

    The keyboard focus ring is gated on \c visualFocus, so it only appears for Tab
    focus (focus-visible), not for a mouse click that opens the popup; \c focusPolicy
    is \c Qt.StrongFocus so Space / Enter / arrow keys are handled by the ComboBox
    base.

    \qml
    Select {
        placeholder: "Select a fruit"
        model: ["Apple", "Banana", "Blueberry"]
    }
    Select { size: Select.Sm; invalid: true; model: ["Error state", "Apple"] }
    \endqml

    \sa NativeSelect
*/
C.ComboBox {
    id: control

    // Compact size scale (documented on the size property); members Default/Sm
    // do not clash with the TransformOrigin values flattened in from the Item base.
    enum Size { Default, Sm }

    /*!
        \qmlproperty enumeration Select::size
        The size on the compact scale (only the trigger height changes; text stays
        \c text-xs). Defaults to \c Select.Default.

        \value Select.Default 28px height (data-[size=default]:h-7).
        \value Select.Sm 24px height (data-[size=sm]:h-6).
    */
    property int size: Select.Default
    /*!
        \qmlproperty string Select::placeholder
        Text shown while nothing is selected (\c currentIndex < 0); rendered in the muted color (data-placeholder:text-muted-foreground).
    */
    property string placeholder: ""
    /*!
        \qmlproperty bool Select::invalid
        When \c true, paints the aria-invalid destructive border and ring. Defaults to \c false.
    */
    property bool invalid: false
    /*!
        \qmlproperty bool Select::alignItemWithTrigger
        When \c true, the popup shifts up so the current row overlays the trigger
        (a simplified take on base-ui's default behaviour). This simplified
        implementation does not scroll the list or clamp against the viewport top
        edge, so \c false (open below the trigger) is recommended for long lists.
        Defaults to \c false.
    */
    property bool alignItemWithTrigger: false
    /*!
        \qmlproperty int Select::groupPosition
        Adjacency inside a ButtonGroup, which decides which corners are
        straightened; see \l {Button::GroupPosition}. Set automatically by ButtonGroup.
    */
    property int groupPosition: Button.GroupNone
    /*!
        \qmlproperty bool Select::groupVertical
        Whether the containing ButtonGroup is vertical. Set by ButtonGroup.
    */
    property bool groupVertical: false

    readonly property bool _sm: size === Select.Sm
    readonly property int _itemHeight: 28              // min-h-7

    implicitHeight: _sm ? 24 : 28                       // data-[size=sm]:h-6 / data-[size=default]:h-7
    leftPadding: Theme.space2                           // px-2
    rightPadding: Theme.space2 + 14 + Theme.space1_5    // clear the chevron (px-2 + icon + gap-1.5)
    font.pixelSize: Theme.textXs                        // text-xs (both sizes)
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus     // Tab-focusable; Space/Enter/arrow handling comes from ComboBox
    opacity: enabled ? 1.0 : 0.5

    // Raise above neighbours while keyboard-focused or open (focus-visible:z-10) so the
    // ring-colored border covers the shared edge with a neighbour (spacing:-1). Uses
    // visualFocus: a mouse click that opens the popup is not focus-visible.
    z: (visualFocus || popup.visible) ? 10 : 0

    // ==== Trigger text (selected value / placeholder) ====
    contentItem: Text {
        readonly property bool _empty: control.currentIndex < 0 || control.displayText === ""
        text: _empty && control.placeholder !== "" ? control.placeholder : control.displayText
        font: control.font
        color: _empty ? Theme.mutedForeground : Theme.foreground  // data-placeholder:text-muted-foreground
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    // ==== Trailing chevron-down ====
    indicator: Icon {
        x: control.width - width - Theme.space2
        y: (control.height - height) / 2
        name: "chevron-down"
        size: 14                                  // svg size-3.5
        color: Theme.mutedForeground
    }

    // ==== Trigger background + focus ring ====
    background: Rectangle {
        id: bg
        radius: Theme.radiusMd
        // Straighten the inner corners adjacent to neighbours when grouped (same
        // per-corner derivation as Button).
        readonly property bool _n: control.groupPosition === Button.GroupNone
        readonly property bool _f: control.groupPosition === Button.GroupFirst
        readonly property bool _l: control.groupPosition === Button.GroupLast
        readonly property bool _v: control.groupVertical
        topLeftRadius:     (_n || _f) ? radius : 0
        bottomRightRadius: (_n || _l) ? radius : 0
        topRightRadius:    (_n || (!_v && _l) || (_v && _f)) ? radius : 0
        bottomLeftRadius:  (_n || (!_v && _f) || (_v && _l)) ? radius : 0
        // bg-input/20; dark:bg-input/30 + dark:hover:bg-input/50 (light mode has no hover change).
        color: Theme.alpha(Theme.input, Theme.input.a * (Theme.dark ? (control.hovered ? 0.5 : 0.3) : 0.2))
        Behavior on color { ColorAnimation { duration: Theme.durFast } }
        border.width: 1
        // aria-invalid:border-destructive wins over focus-visible:border-ring.
        // border-ring is focus-visible (keyboard only): a mouse click that opens the
        // popup neither highlights the border nor shows the ring.
        // Dark invalid border uses destructive/50 (dark:aria-invalid:border-destructive/50).
        border.color: control.invalid
                      ? (Theme.dark ? Theme.alpha(Theme.destructive, 0.5) : Theme.destructive)
                      : control.visualFocus ? Theme.ring : Theme.input
        Behavior on border.color { ColorAnimation { duration: Theme.durFast } }

        // aria-invalid destructive ring (ring-destructive/20, dark 40).
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

        // Focus ring follows the background's per-corner radii (a grouped straightened
        // corner gets a square ring corner too); only for keyboard focus-visible.
        FocusRing {
            active: control.visualFocus && !control.invalid
            targetRadius: bg.radius
            targetTopLeft: bg.topLeftRadius
            targetTopRight: bg.topRightRadius
            targetBottomLeft: bg.bottomLeftRadius
            targetBottomRight: bg.bottomRightRadius
        }
    }

    // ==== Option delegate (normal item / group label / separator) ====
    delegate: C.ItemDelegate {
        id: item
        required property int index
        required property var model
        width: ListView.view ? ListView.view.width : control.width
        padding: 0
        hoverEnabled: true
        // Keyboard navigation highlight (focus:bg-accent applies to the highlighted row too).
        highlighted: control.highlightedIndex === index

        // group label: { header: "..." }; separator: { separator: true }; everything else a normal item.
        readonly property bool _isHeader: model.header !== undefined
        readonly property bool _isSeparator: model.separator === true
        readonly property bool _isItem: !_isHeader && !_isSeparator
        readonly property bool _selected: control.currentIndex === index
        readonly property bool _active: _isItem && (hovered || highlighted)

        enabled: _isItem && model.disabled !== true   // labels / separators / disabled rows are not selectable
        height: _isSeparator ? 9 : control._itemHeight // separator h-px + my-1
        opacity: (_isItem && model.disabled === true) ? 0.5 : 1.0  // data-disabled:opacity-50

        contentItem: Item {
            // ---- separator (SelectSeparator: bg-border/50 -mx-1 my-1 h-px) ----
            Rectangle {
                visible: item._isSeparator
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: 1
                color: Theme.alpha(Theme.border, 0.5)
            }
            // ---- group label (SelectLabel: text-muted-foreground px-2 py-1.5 text-xs) ----
            Text {
                visible: item._isHeader
                anchors.left: parent.left
                anchors.leftMargin: Theme.space2
                anchors.verticalCenter: parent.verticalCenter
                text: item._isHeader ? item.model.header : ""
                font.pixelSize: Theme.textXs
                color: Theme.mutedForeground
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            // ---- normal item text ----
            Text {
                visible: item._isItem
                anchors.left: parent.left
                anchors.leftMargin: Theme.space2
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - Theme.space2 * 2 - 14
                // Header/separator rows lack control.textRole, and their raw
                // modelData is the whole row object (not a string) -- reading
                // it here would try to assign a QJSValue object to this
                // string property and warn every repaint, even though the
                // Text stays invisible for those rows. Skip straight to ""
                // for non-items, and only trust modelData when it is really
                // a string (plain string-array models).
                text: {
                    if (!item._isItem)
                        return ""
                    const v = item.model[control.textRole]
                    if (v !== undefined)
                        return v
                    const md = item.model.modelData
                    return typeof md === "string" ? md : ""
                }
                font.pixelSize: Theme.textXs
                color: item._active ? Theme.accentForeground : Theme.foreground
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
            // Trailing check on the selected item (absolute right-2).
            Icon {
                anchors.right: parent.right
                anchors.rightMargin: Theme.space2
                anchors.verticalCenter: parent.verticalCenter
                name: "check"
                size: 14                          // svg size-3.5
                color: item._active ? Theme.accentForeground : Theme.foreground
                visible: item._isItem && item._selected
            }
        }

        background: Rectangle {
            visible: item._active
            radius: Theme.radiusMd                // rounded-md
            color: Theme.accent                   // focus:bg-accent
        }
    }

    // ==== Popup (popover surface) ====
    popup: C.Popup {
        // With alignItemWithTrigger=true, shift up so the current row overlays the trigger
        // (rows are the same 28px height as the trigger). Simplified: no list scrolling and
        // no clamping against the viewport top edge (base-ui clamps and falls back to
        // edge-anchored); prefer false for long, scrolling lists. false opens just below the
        // trigger (= base-ui alignItemWithTrigger={false}).
        y: control.alignItemWithTrigger && control.currentIndex >= 0
           ? -(control.currentIndex * control._itemHeight + padding)
           : control.height + Theme.space1
        width: control.width
        implicitHeight: Math.min(contentItem.implicitHeight + 2 * padding, 300)
        padding: Theme.space1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            boundsBehavior: Flickable.StopAtBounds
            C.ScrollIndicator.vertical: C.ScrollIndicator {}
        }

        // Surface: rounded-lg + ring-1 ring-foreground/10 + shadow-md.
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
    }
}
