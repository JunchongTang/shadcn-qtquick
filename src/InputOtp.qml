pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

/*!
    \qmltype InputOtp
    \inqmlmodule Shadcn
    \inherits FocusScope
    \brief Segmented one-time-passcode field, matching shadcn/ui base-mira.

    InputOtp maps the base-mira \c {.cn-input-otp} family (container, group, slot,
    separator) as a single focusable control. It renders \l length cells split into
    one or more \l groups; each group is a rounded, \c {input/20}-tinted box built
    from \l InputOtpSlot cells sharing 1px dividers, and adjacent groups are joined
    by an \l InputOtpSeparator. The current input position shows the focus ring and
    a blinking caret.

    Keyboard input is handled centrally: a visible character (validated against
    \l pattern) is appended at the current position, and Backspace/Delete removes
    the last character. Advanced editing (multi-character paste, arrow-key edits of
    interior positions, RTL) is intentionally simplified to sequential entry.

    \qml
    InputOtp { length: 6 }                        // single group of 6
    InputOtp { length: 6; groups: [3, 3] }        // 3 + 3 with a separator
    InputOtp { length: 6; pattern: "[0-9]" }      // digits only (per-character)
    \endqml
*/
FocusScope {
    id: control

    /*! \qmlproperty int InputOtp::length
        \brief Total number of slots (characters). Defaults to \c 6. */
    property int length: 6

    /*! \qmlproperty var InputOtp::groups
        \brief Array of per-group slot counts (e.g. \c {[3, 3]}); a separator is
        shown between groups. When empty, a single group of \l length is used. */
    property var groups: []

    /*! \qmlproperty string InputOtp::pattern
        \brief Per-character validation regexp source; an empty string accepts any
        visible character. Anchored full-string sources (e.g. \c {"^\\d+$"}) also
        work since each candidate character is tested individually. */
    property string pattern: ""

    /*! \qmlproperty bool InputOtp::invalid
        \brief Marks the field as failing validation (maps \c {aria-invalid}); the
        group border and ring switch to the destructive color. */
    property bool invalid: false

    /*! \qmlproperty string InputOtp::value
        \brief The characters entered so far. Writable, but the built-in keyboard
        handling never lets it exceed \l length. */
    property string value: ""

    /*! \qmlproperty bool InputOtp::complete
        \brief \c true when \l value has exactly \l length characters. */
    readonly property bool complete: value.length === control.length

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    activeFocusOnTab: true
    opacity: enabled ? 1 : 0.5          // has-disabled:opacity-50

    // Normalized groups: fall back to a single group of `length`.
    readonly property var _groups: (control.groups && control.groups.length > 0)
                                   ? control.groups : [control.length]
    // Current input position (highlighted with ring + caret while focused).
    readonly property int _activeIndex: Math.min(control.value.length, control.length - 1)

    // Layout items: alternating group / separator; each group carries the global
    // indices of the slots it owns.
    readonly property var _items: {
        let res = []
        let start = 0
        for (let g = 0; g < control._groups.length; g++) {
            if (g > 0)
                res.push({ "type": "sep" })
            let idx = []
            for (let k = 0; k < control._groups[g]; k++) {
                idx.push(start)
                start++
            }
            res.push({ "type": "grp", "indices": idx })
        }
        return res
    }

    function _accepts(ch) {
        if (control.pattern === "")
            return true
        return new RegExp(control.pattern).test(ch)
    }

    // Caret blink (animate-caret-blink, ~1s period).
    property bool _caretOn: true
    Timer {
        interval: 500
        repeat: true
        running: control.activeFocus
        onTriggered: control._caretOn = !control._caretOn
        onRunningChanged: if (!running) control._caretOn = true
    }

    Keys.onPressed: (e) => {
        if (!control.enabled)
            return
        if (e.key === Qt.Key_Backspace || e.key === Qt.Key_Delete) {
            control.value = control.value.slice(0, -1)
            e.accepted = true
            return
        }
        const t = e.text
        if (t && t.length === 1 && t.charCodeAt(0) >= 32) {
            e.accepted = true
            if (control.value.length >= control.length)
                return
            if (control._accepts(t))
                control.value += t
        }
    }

    TapHandler {
        enabled: control.enabled
        onTapped: control.forceActiveFocus()
    }

    RowLayout {
        id: row
        spacing: Theme.space2            // .cn-input-otp gap-2 (between groups/separators)

        Repeater {
            model: control._items
            delegate: Item {
                id: cell
                required property var modelData

                readonly property bool _isSep: cell.modelData.type === "sep"
                implicitWidth: _isSep ? sep.implicitWidth : grp.implicitWidth
                implicitHeight: 28
                Layout.preferredWidth: implicitWidth
                Layout.preferredHeight: 28

                InputOtpSeparator {
                    id: sep
                    anchors.centerIn: parent
                    visible: cell._isSep
                }

                // ---- Group: rounded border + faint fill enclosing adjacent slots ----
                Rectangle {
                    id: grp
                    visible: !cell._isSep
                    implicitWidth: slots.implicitWidth
                    implicitHeight: 28
                    radius: Theme.radiusMd
                    color: Theme.dark ? Theme.alpha(Theme.input, 0.3)   // dark:bg-input/30
                                      : Theme.alpha(Theme.input, 0.2)   // bg-input/20
                    border.width: 1
                    border.color: control.invalid ? Theme.destructive : Theme.input

                    // has-aria-invalid: destructive ring around the whole group.
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -Theme.ringWidth
                        radius: grp.radius + Theme.ringWidth
                        color: "transparent"
                        border.width: Theme.ringWidth
                        border.color: Theme.alpha(Theme.destructive, Theme.dark ? 0.4 : 0.2)
                        visible: control.invalid
                    }

                    Row {
                        id: slots
                        spacing: 0
                        Repeater {
                            model: cell._isSep ? [] : cell.modelData.indices
                            delegate: InputOtpSlot {
                                id: slotItem
                                required property var modelData      // global slot index
                                required property int index          // position within group
                                first: index === 0
                                last: index === (cell.modelData.indices.length - 1)
                                glyph: (slotItem.modelData < control.value.length)
                                       ? control.value.charAt(slotItem.modelData) : ""
                                active: control.activeFocus
                                        && slotItem.modelData === control._activeIndex
                                showCaret: active
                                caretOn: control._caretOn
                                invalid: control.invalid
                            }
                        }
                    }
                }
            }
        }
    }
}
