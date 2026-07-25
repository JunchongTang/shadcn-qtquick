import QtQuick
import QtQuick.Controls.Basic as C

/*!
    \qmltype Textarea
    \inqmlmodule Shadcn
    \inherits TextArea
    \brief Multi-line text field matching shadcn/ui's base-mira \c Textarea.
    \image textarea.png


    Textarea is the multi-line counterpart of \l Input: it shares the same
    \c {input/20} tinted fill, 1px \c border-input outline and base-mira
    focus-visible ring (\l FocusRing), but grows vertically and keeps a
    \c min-h-16 (64px) minimum. It maps the base-mira \c {.cn-textarea} utility:
    on focus the border turns to \c Theme.ring and the ring appears; when
    \l invalid it turns to \c Theme.destructive with a destructive tint ring
    (aria-invalid wins over focus). Being a plain
    \l {QtQuick.Controls.Basic}{TextArea}, it inherits the full text-editing API
    (\c text, \c placeholderText, \c readOnly, \c wrapMode, ...).

    Per repo convention for text inputs, the focus ring is gated on \c activeFocus
    (it appears on any focus, including a mouse click), unlike button-like controls
    which gate on \c visualFocus (keyboard only). \c focusPolicy is
    \c Qt.StrongFocus so the field is reachable by both click and Tab.

    The implicit height follows base-mira's \c {field-sizing-content} with a
    \c min-h-16 floor: it grows with the wrapped content but never shrinks below
    64px. Text wraps (\c {wrapMode: TextEdit.Wrap}) rather than scrolling
    horizontally, matching the CSS \c resize-none / wrapping textarea.

    \qml
    Textarea { placeholderText: "Type your message here." }
    Textarea { invalid: true; placeholderText: "Type your message here." }
    \endqml
*/
// The file name (Textarea) differs only in case from the QML base type
// (TextArea); the `as C` alias keeps the base type unambiguous and matches the
// style used across the library.
C.TextArea {
    id: control

    /*! \qmlproperty bool Textarea::invalid
        Marks the field as failing validation (maps \c {aria-invalid}).
        When \c true the border and ring switch to the destructive color, and
        the destructive ring is shown regardless of focus. Defaults to \c false. */
    property bool invalid: false

    // min-h-16 (64px) floor combined with field-sizing-content: grow with the
    // wrapped content but never drop below the minimum height.
    implicitHeight: Math.max(64, contentHeight + topPadding + bottomPadding)
    leftPadding: Theme.space2       // px-2
    rightPadding: Theme.space2
    topPadding: Theme.space2        // py-2
    bottomPadding: Theme.space2
    font.pixelSize: Theme.textXs    // md:text-xs
    color: Theme.foreground
    placeholderTextColor: Theme.mutedForeground
    selectionColor: Theme.alpha(Theme.primary, 0.35)
    selectedTextColor: Theme.foreground
    wrapMode: TextEdit.Wrap

    // Reachable by click and Tab; the ring is gated on activeFocus below.
    focusPolicy: Qt.StrongFocus
    // disabled:opacity-50 (interaction is disabled via enabled by the consumer).
    opacity: enabled ? 1.0 : 0.5

    background: Rectangle {
        id: bg
        radius: Theme.radiusMd
        // bg-input/20 dark:bg-input/30
        color: Theme.alpha(Theme.input, Theme.dark ? 0.3 : 0.2)
        border.width: 1
        // border-input, focus-visible:border-ring, aria-invalid:border-destructive
        // (dark:aria-invalid:border-destructive/50). invalid wins over focus.
        border.color: control.invalid
                        ? (Theme.dark ? Theme.alpha(Theme.destructive, 0.5) : Theme.destructive)
                     : control.activeFocus ? Theme.ring : Theme.input
        Behavior on border.color { ColorAnimation { duration: Theme.durFast } }

        // aria-invalid ring: ring-destructive/20 (dark:ring-destructive/40),
        // shown whenever invalid regardless of focus.
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

        // Focus-visible ring. Suppressed while invalid so the destructive ring
        // above is the only one shown (aria-invalid wins in base).
        FocusRing {
            active: control.activeFocus && !control.invalid
            targetRadius: bg.radius
        }
    }
}
