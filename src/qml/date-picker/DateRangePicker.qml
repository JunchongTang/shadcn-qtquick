import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import LucideIcons
import Shadcn

/*!
    \qmltype DateRangePicker
    \inqmlmodule Shadcn
    \inherits AbstractButton
    \brief An outline trigger that opens a two-month range calendar in a popover.

    DateRangePicker is a convenience composition mirroring the date-picker "Range
    Picker" example: a \l Popover whose trigger is an outline button and whose
    content is a range-selection \l Calendar spanning \l numberOfMonths months.

    The trigger follows the base-mira style: left-aligned range text (or
    placeholder) with a trailing \c chevron-down indicator. It shows the start date
    once the first endpoint is chosen and "start - end" once both are set, closing
    the popover when the second endpoint is selected.

    \sa DatePicker
*/
C.AbstractButton {
    id: control

    /*!
        \qmlproperty date DateRangePicker::rangeStart
        Start of the selected range as a JavaScript \c Date, or \c undefined.
        Guaranteed to be less than or equal to \l rangeEnd.
    */
    property var rangeStart: undefined

    /*!
        \qmlproperty date DateRangePicker::rangeEnd
        End of the selected range as a JavaScript \c Date, or \c undefined.
    */
    property var rangeEnd: undefined

    /*!
        \qmlproperty string DateRangePicker::placeholder
        Text shown when no range is selected. Rendered in the muted foreground color.
    */
    property string placeholder: qsTr("Pick a date")

    /*!
        \qmlproperty int DateRangePicker::align
        Horizontal alignment of the popover relative to the trigger. Defaults to
        \c Popover.Align.Start.
    */
    property int align: Popover.Align.Start

    /*!
        \qmlproperty string DateRangePicker::displayFormat
        Qt.formatDate() format string for each endpoint in the trigger label.
        Defaults to \c "MMM dd, yyyy" (approximating date-fns "LLL dd, y").
    */
    property string displayFormat: "MMM dd, yyyy"

    /*!
        \qmlproperty int DateRangePicker::numberOfMonths
        Number of months displayed side by side in the popover. Defaults to \c 2.
    */
    property int numberOfMonths: 2

    /*!
        \qmlsignal DateRangePicker::rangeSelected(date start, date end)
        Emitted when the second endpoint is chosen, completing a range.
        \a start and \a end are JavaScript \c Date values.
    */
    signal rangeSelected(var start, var end)

    readonly property bool _empty: rangeStart === undefined
    function _format(d) {
        return d === undefined ? "" : Qt.formatDate(d, displayFormat)
    }
    // Trigger label: placeholder when empty, single date while only the start is
    // set, "start - end" once both endpoints exist.
    readonly property string _label: {
        if (_empty)
            return placeholder
        if (rangeEnd === undefined)
            return _format(rangeStart)
        return _format(rangeStart) + " - " + _format(rangeEnd)
    }

    implicitWidth: 256               // wider than single date to fit "start - end"; overridable
    implicitHeight: 28               // h-7
    hoverEnabled: true
    padding: 0
    leftPadding: Theme.space2_5      // px-2.5
    rightPadding: Theme.space2_5
    opacity: enabled ? 1.0 : 0.5

    // Toggle the popover with a reopen guard; see DatePicker.qml for the rationale
    // (Popover CloseOnPressOutside closes on press, so a naive reopen never dismisses).
    property double _lastPopClose: 0
    onClicked: {
        if (pop.opened) { pop.close(); return }
        if (Date.now() - control._lastPopClose < 250) return
        pop.open()
    }
    Connections {
        target: pop
        function onOpenedChanged() { if (!pop.opened) control._lastPopClose = Date.now() }
    }

    // Trigger content: left-aligned label + trailing chevron-down (base-mira).
    contentItem: RowLayout {
        spacing: Theme.space2        // gap-2
        Text {
            Layout.fillWidth: true
            text: control._label
            color: control._empty ? Theme.mutedForeground : Theme.foreground
            font.pixelSize: Theme.textXs
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
        LucideIcon {
            name: "chevron-down"
            size: 14                 // size-3.5
            color: Theme.mutedForeground
            opacity: 0.5             // opacity-50
        }
    }

    // Trigger background: replicates Button variant=outline.
    background: Rectangle {
        id: bg
        radius: Theme.radiusMd
        color: control.hovered ? Theme.alpha(Theme.input, 0.5) : Theme.alpha(Theme.input, 0)  // hover:bg-input/50
        border.width: 1
        border.color: control.activeFocus ? Theme.ring : Theme.border
        Behavior on color { ColorAnimation { duration: Theme.durBase } }
        Behavior on border.color { ColorAnimation { duration: Theme.durFast } }

        FocusRing { active: control.visualFocus; targetRadius: bg.radius }
    }

    // Popover content (w-auto p-0) wrapping a two-month range calendar.
    Popover {
        id: pop
        align: control.align
        padding: 0                   // p-0
        width: cal.implicitWidth     // w-auto
        height: cal.implicitHeight

        // Re-seed the range and shown month on each open; Calendar assigns its own
        // range on click, breaking the downward binding, so we push it back here.
        onOpened: {
            cal.rangeStart = control.rangeStart
            cal.rangeEnd = control.rangeEnd
            cal.displayMonth = control.rangeStart !== undefined
                             ? control.rangeStart : new Date()
        }

        Calendar {
            id: cal
            mode: Calendar.Range
            numberOfMonths: control.numberOfMonths
            onRangeSelected: function(start, end) {
                control.rangeStart = start
                control.rangeEnd = end
                control.rangeSelected(start, end)
                pop.close()
            }
        }
    }
}
