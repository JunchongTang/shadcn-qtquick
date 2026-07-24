import QtQuick

/*!
    \qmltype InputOtpSlot
    \inqmlmodule Shadcn
    \inherits Item
    \brief Single character cell of an OTP field, matching shadcn/ui base-mira.

    InputOtpSlot maps the base-mira \c {.cn-input-otp-slot} utility: a \c size-7
    (28px) cell showing one character in \c text-xs. Slots sit edge-to-edge inside
    a rounded group (drawn by \l InputOtp); the shared 1px \c border-input vertical
    line between neighbours is drawn on the left edge of every non-first slot. The
    \l first and \l last flags round the group's outer left/right corners.

    When \l active, the cell shows the focus ring (\c border-ring plus a
    \c {ring/30} halo, raised above neighbours with \c {z: 10}); when \l invalid
    those switch to \c Theme.destructive. A blinking caret (\l showCaret /
    \l caretOn) is drawn while the cell is the current input position and empty.

    This is a presentational component: all state is injected by \l InputOtp.
*/
Item {
    id: slot

    /*! \qmlproperty string InputOtpSlot::glyph
        \brief The character shown in this cell (empty when unfilled). */
    property string glyph: ""

    /*! \qmlproperty bool InputOtpSlot::active
        \brief Whether this is the current input position (maps \c {data-active}).
        When \c true the cell shows the ring and \c border-ring outline. */
    property bool active: false

    /*! \qmlproperty bool InputOtpSlot::first
        \brief Whether this is the first slot in its group; rounds the left corners
        (maps \c {first:rounded-l-md}). Defaults to \c false. */
    property bool first: false

    /*! \qmlproperty bool InputOtpSlot::last
        \brief Whether this is the last slot in its group; rounds the right corners
        (maps \c {last:rounded-r-md}). Defaults to \c false. */
    property bool last: false

    /*! \qmlproperty bool InputOtpSlot::invalid
        \brief Marks the cell as failing validation (maps \c {aria-invalid}); the
        divider, border and ring switch to \c Theme.destructive. */
    property bool invalid: false

    /*! \qmlproperty bool InputOtpSlot::showCaret
        \brief Whether the blinking caret may be drawn (only while empty). */
    property bool showCaret: false

    /*! \qmlproperty bool InputOtpSlot::caretOn
        \brief Current on/off phase of the blinking caret. */
    property bool caretOn: true

    implicitWidth: 28                   // size-7
    implicitHeight: 28

    // Shared vertical divider (= border-input between adjacent slots).
    Rectangle {
        visible: !slot.first
        width: 1
        height: parent.height
        color: slot.invalid ? Theme.destructive : Theme.input
    }

    // Character glyph.
    Text {
        anchors.centerIn: parent
        text: slot.glyph
        color: Theme.foreground
        font.pixelSize: Theme.textXs
        font.family: Theme.fontSans
    }

    // Blinking caret (only at the current input position while empty).
    Rectangle {
        anchors.centerIn: parent
        visible: slot.showCaret && slot.glyph === ""
        width: 1
        height: 16                      // h-4
        color: Theme.foreground
        opacity: slot.caretOn ? 1 : 0
    }

    // Active overlay: ring outline + ring-colored border, raised above neighbours.
    Rectangle {
        id: activeBox
        anchors.fill: parent
        visible: slot.active
        z: 10                           // data-[active=true]:z-10
        color: "transparent"
        border.width: 1
        border.color: slot.invalid ? Theme.destructive : Theme.ring
        topLeftRadius: slot.first ? Theme.radiusMd : 0
        bottomLeftRadius: slot.first ? Theme.radiusMd : 0
        topRightRadius: slot.last ? Theme.radiusMd : 0
        bottomRightRadius: slot.last ? Theme.radiusMd : 0

        // Focus ring: expands outward by ringWidth; ring/30 (invalid -> destructive/20,
        // dark destructive/40).
        Rectangle {
            anchors.fill: parent
            anchors.margins: -Theme.ringWidth
            color: "transparent"
            border.width: Theme.ringWidth
            border.color: slot.invalid ? Theme.alpha(Theme.destructive, Theme.dark ? 0.4 : 0.2)
                                       : Theme.alpha(Theme.ring, Theme.ringOpacity)
            topLeftRadius: activeBox.topLeftRadius > 0 ? activeBox.topLeftRadius + Theme.ringWidth : 0
            bottomLeftRadius: activeBox.bottomLeftRadius > 0 ? activeBox.bottomLeftRadius + Theme.ringWidth : 0
            topRightRadius: activeBox.topRightRadius > 0 ? activeBox.topRightRadius + Theme.ringWidth : 0
            bottomRightRadius: activeBox.bottomRightRadius > 0 ? activeBox.bottomRightRadius + Theme.ringWidth : 0
        }
    }
}
