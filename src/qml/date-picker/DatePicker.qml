import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as C
import Shadcn

/*!
    \qmltype DatePicker
    \inqmlmodule Shadcn
    \inherits AbstractButton
    \brief An outline trigger that opens a single-date calendar in a popover.
    \image date-picker.png


    DatePicker is a convenience composition (shadcn has no standalone DatePicker
    component; see the date-picker "Composition" docs): a \l Popover whose trigger
    is an outline button and whose content is a single-selection \l Calendar.

    The trigger follows the base-mira style: left-aligned date text (or placeholder)
    with a trailing \c chevron-down indicator. Picking a day fills the formatted
    date and closes the popover. Range and multiple selection are out of scope
    (use \l DateRangePicker for ranges).

    \qml
    DatePicker {
        placeholder: "Pick a date"
        onSelected: (date) => console.log(date)
    }
    \endqml
*/
C.AbstractButton {
    id: control

    /*!
        \qmlproperty date DatePicker::selectedDate
        The currently selected day as a JavaScript \c Date, or \c undefined when
        nothing is selected.
    */
    property var selectedDate: undefined

    /*!
        \qmlproperty string DatePicker::placeholder
        Text shown when no date is selected. Rendered in the muted foreground color.
    */
    property string placeholder: qsTr("Pick a date")

    /*!
        \qmlproperty int DatePicker::align
        Horizontal alignment of the popover relative to the trigger. One of
        \c Popover.Align.Start, \c Center or \c End. Defaults to \c Start.
    */
    property int align: Popover.Align.Start

    /*!
        \qmlproperty string DatePicker::displayFormat
        Qt.formatDate() format string for the trigger label. Defaults to
        \c "MMMM d, yyyy" (approximating date-fns "PPP", e.g. "June 1, 2025").
    */
    property string displayFormat: "MMMM d, yyyy"

    /*!
        \qmlsignal DatePicker::selected(date date)
        Emitted when the user picks a day. \a date is the selected JavaScript \c Date.
    */
    signal selected(var date)

    readonly property bool _empty: selectedDate === undefined
    function _format(d) {
        return d === undefined ? "" : Qt.formatDate(d, displayFormat)
    }

    implicitWidth: 212               // date-picker-demo w-[212px]; overridable via width
    implicitHeight: 28               // h-7
    hoverEnabled: true
    padding: 0
    leftPadding: Theme.space2_5      // px-2.5
    rightPadding: Theme.space2_5
    opacity: enabled ? 1.0 : 0.5

    // Toggle the popover. Popover uses CloseOnPressOutside, so clicking an already
    // open trigger closes it on press; by release pop.opened is already false and a
    // naive reopen would make it "impossible to dismiss". The _lastPopClose guard
    // suppresses the reopen when this very click was the source of that close.
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
            text: control._empty ? control.placeholder : control._format(control.selectedDate)
            color: control._empty ? Theme.mutedForeground : Theme.foreground
            font.pixelSize: Theme.textXs
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
        Icon {
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

    // Popover content (w-auto p-0) wrapping a single-selection calendar.
    Popover {
        id: pop
        align: control.align
        padding: 0                   // p-0
        width: cal.implicitWidth     // w-auto
        height: cal.implicitHeight

        // Re-seed the calendar's selection and shown month on each open (mirrors the
        // official selected + defaultMonth). Calendar assigns its own selectedDate on
        // click, breaking the downward binding, so we push the value back here.
        onOpened: {
            cal.selectedDate = control.selectedDate
            cal.displayMonth = control.selectedDate !== undefined
                             ? control.selectedDate : new Date()
        }

        Calendar {
            id: cal
            onSelected: function(d) {
                control.selectedDate = d
                control.selected(d)
                pop.close()
            }
        }
    }
}
