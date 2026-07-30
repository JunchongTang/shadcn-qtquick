import QtQuick
import QtQuick.Controls.Basic as C
import QtQuick.Effects

/*!
    \qmltype NativeSelect
    \inqmlmodule Shadcn
    \inherits ComboBox
    \brief A plain native-style dropdown select (\c .cn-native-select).
    \image native-select.png


    NativeSelect is the plainer counterpart to \l Select, styled after shadcn's
    base-mira \c .cn-native-select rules. Both show a trailing \c chevron-down;
    compared with \l Select, NativeSelect's popup is a plain list of options with
    no per-item check mark.

    Visuals: an \c input-colored border over a faint \c {bg-input/20} fill,
    height 28 (24 when \l size is \c Sm), \c rounded-md corners, extra-small text
    (\c 0.625rem when \c Sm) and \c pr-6 right padding to clear the chevron.

    The \l model may be a plain string list or a list of objects. An object with
    a \c header key renders as a non-selectable optgroup title; a normal item may
    carry \c {disabled: true} to disable that single row. Object items resolve
    their label through the standard \c textRole.

    \qml
    NativeSelect {
        placeholder: "Select a fruit"
        model: ["Apple", "Banana", "Blueberry"]
    }
    NativeSelect { size: NativeSelect.Sm; invalid: true; model: ["Error state"] }
    \endqml

    \sa Select
*/
C.ComboBox {
    id: control

    // Compact size scale. Members (Default, Sm) do not clash with the TransformOrigin
    // values QML flattens in from the Item base, so no renaming is required.
    enum Size { Default, Sm }

    /*!
        \qmlproperty enumeration NativeSelect::size
        The size on the compact scale. Defaults to \c NativeSelect.Default.

        \value NativeSelect.Default 28px height, 12px text, 14px chevron.
        \value NativeSelect.Sm 24px height, 10px text, 12px chevron.
    */
    property int size: NativeSelect.Default
    /*!
        \qmlproperty string NativeSelect::placeholder
        Text shown while nothing is selected (\c currentIndex < 0), matching the \c value="" first option.
    */
    property string placeholder: ""
    /*!
        \qmlproperty bool NativeSelect::invalid
        When \c true, paints the aria-invalid destructive border and ring. Defaults to \c false.
    */
    property bool invalid: false

    readonly property bool _sm: size === NativeSelect.Sm
    readonly property int _itemHeight: 28

    implicitHeight: _sm ? 24 : 28              // h-6 / h-7
    leftPadding: Theme.space2                  // pl-2
    rightPadding: Theme.space6                 // pr-6 (clears the trailing chevron)
    font.pixelSize: _sm ? 10 : Theme.textXs    // text-[0.625rem] / text-xs
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus     // Tab-focusable; Space/Enter/arrow handling comes from ComboBox
    opacity: enabled ? 1.0 : 0.5               // has-[select:disabled]:opacity-50

    // ==== Trigger text (selected value / placeholder) ====
    contentItem: Text {
        readonly property bool _empty: control.currentIndex < 0 || control.displayText === ""
        text: _empty && control.placeholder !== "" ? control.placeholder : control.displayText
        font: control.font
        color: _empty ? Theme.mutedForeground : Theme.foreground  // placeholder:text-muted-foreground
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    // ==== Trailing single chevron-down ====
    indicator: Icon {
        x: control.width - width - Theme.space1_5  // right-1.5
        y: (control.height - height) / 2
        name: "chevron-down"
        size: control._sm ? 12 : 14                // size-3 / size-3.5
        color: Theme.mutedForeground
    }

    // ==== Trigger background + focus ring ====
    background: Rectangle {
        id: bg
        radius: Theme.radiusMd
        // bg-input/20; dark:bg-input/30 + dark:hover:bg-input/50 (light mode has no hover change).
        color: Theme.dark
               ? Theme.alpha(Theme.input, Theme.input.a * (control.hovered ? 0.5 : 0.3))
               : Theme.alpha(Theme.input, Theme.input.a * (0.2))
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

        // Focus ring only for keyboard focus-visible (never on a mouse-open click).
        FocusRing { active: control.visualFocus && !control.invalid; targetRadius: bg.radius }
    }

    // ==== Plain option delegate (normal item / optgroup title, no check mark) ====
    delegate: C.ItemDelegate {
        id: item
        required property int index
        required property var model
        width: ListView.view ? ListView.view.width : control.width
        padding: 0
        hoverEnabled: true

        // optgroup title: { header: "..." }; everything else is a normal option.
        readonly property bool _isHeader: model.header !== undefined
        readonly property bool _isItem: !_isHeader
        readonly property bool _selected: control.currentIndex === index

        enabled: _isItem && model.disabled !== true   // titles / disabled rows are not selectable
        height: control._itemHeight
        opacity: (_isItem && model.disabled === true) ? 0.5 : 1.0  // disabled:opacity-50

        contentItem: Item {
            // ---- optgroup title (text-muted-foreground px-2 text-xs) ----
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
            // ---- normal option text ----
            Text {
                visible: item._isItem
                anchors.left: parent.left
                anchors.leftMargin: Theme.space2
                anchors.right: parent.right
                anchors.rightMargin: Theme.space2
                anchors.verticalCenter: parent.verticalCenter
                text: item.model[control.textRole] !== undefined
                      ? item.model[control.textRole] : item.model.modelData
                font.pixelSize: Theme.textXs
                color: item.hovered || item._selected ? Theme.accentForeground : Theme.foreground
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
            }
        }

        // Plain highlight: hover / current row fills the whole row (no per-item check mark).
        background: Rectangle {
            visible: item._isItem && (item.hovered || item._selected)
            radius: Theme.radiusSm
            color: Theme.accent
        }
    }

    // ==== Popup (plain list surface) ====
    popup: C.Popup {
        y: control.height + Theme.space1
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
