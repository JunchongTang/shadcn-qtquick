pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Shadcn

/*!
    \qmltype Calendar
    \inqmlmodule Shadcn
    \inherits Item
    \brief A month-grid date picker (base-mira style).

    Port of shadcn/ui's Calendar (base-mira). Qt Quick has no built-in
    calendar (Qt.labs.calendar is deprecated), so this component computes a
    7x6 day grid per month from JS \c Date values, padding the leading/trailing
    weeks with the adjacent months' days.

    Styling follows \c {registry/bases/base/ui/calendar.tsx} and the
    \c {.cn-calendar} tokens:
    \list
        \li p-3 padding, \c {--cell-radius} = radius-md (8).
        \li Selected day: bg-primary / text-primary-foreground (single mode).
        \li Today: bg-muted / text-foreground when not selected.
        \li Outside days: text-muted-foreground when \l showOutsideDays is set.
    \endlist

    The default configuration (single month, single selection, Label caption)
    is backward compatible with earlier versions and is what DatePicker and
    DateRangePicker rely on. Range mode paints a muted connector band beneath
    the span with rounded pills at the endpoints, matching mira's
    range_start / range_middle / range_end.

    \qml
    Calendar {
        displayMonth: new Date(2024, 0, 1)
        onSelected: (d) => console.log("picked", d)
    }
    \endqml
*/
Item {
    id: cal

    /*!
        \qmlproperty enumeration Calendar::mode
        Selection mode.
        \value Calendar.Single Single day selection (default); writes \l selectedDate.
        \value Calendar.Range Two-endpoint range; writes \l rangeStart / \l rangeEnd.
    */
    enum Mode { Single, Range }

    /*!
        \qmlproperty enumeration Calendar::captionLayout
        Month/year caption presentation.
        \value Calendar.Label Plain centered "Month Year" text (default).
        \value Calendar.Dropdown Month and year NativeSelect dropdowns.
    */
    enum CaptionLayout { Label, Dropdown }

    /*!
        \qmlproperty int Calendar::mode
        The selection mode; see \l Mode. Defaults to \c Calendar.Single.
    */
    property int mode: Calendar.Single

    /*!
        \qmlproperty int Calendar::captionLayout
        The caption presentation; see \l CaptionLayout.
        Defaults to \c Calendar.Label.
    */
    property int captionLayout: Calendar.Label

    /*!
        \qmlproperty int Calendar::numberOfMonths
        How many consecutive months to render side by side.
        Defaults to 1. When greater than 1 the first column shows
        \l displayMonth and the shared navigation moves all columns by one
        month at a time.
    */
    property int numberOfMonths: 1

    /*!
        \qmlproperty var Calendar::selectedDate
        The selected day as a JS \c Date (Single mode).
        \c undefined until a day is picked.
    */
    property var selectedDate: undefined

    /*!
        \qmlproperty var Calendar::rangeStart
        Start of the selected range as a JS \c Date (Range mode).
        Always ordered so \c rangeStart <= \l rangeEnd. \c undefined until set.
    */
    property var rangeStart: undefined

    /*!
        \qmlproperty var Calendar::rangeEnd
        End of the selected range as a JS \c Date (Range mode).
        \c undefined until the second endpoint is picked.
    */
    property var rangeEnd: undefined

    /*!
        \qmlproperty date Calendar::displayMonth
        The month currently shown (only its year/month matter).
        In multi-month views this is the leading month. Defaults to today.
    */
    property date displayMonth: new Date()

    /*!
        \qmlproperty bool Calendar::showOutsideDays
        Whether leading/trailing days from adjacent months are drawn.
        Defaults to \c true.
    */
    property bool showOutsideDays: true

    /*!
        \qmlproperty real Calendar::cellSize
        The edge length of a day cell in px.
        The mira token \c {--cell-size} is spacing(6) = 24; this defaults to 32
        for readability and a larger hit target. Set to 24 to match mira
        exactly. The weekday header and navigation scale with it.
    */
    property real cellSize: 32

    /*!
        \qmlproperty int Calendar::fromYear
        First year offered by the Dropdown caption's year list.
        Defaults to this year - 100 (approximating react-day-picker).
    */
    property int fromYear: (new Date()).getFullYear() - 100

    /*!
        \qmlproperty int Calendar::toYear
        Last year offered by the Dropdown caption's year list.
        Defaults to this year + 10.
    */
    property int toYear: (new Date()).getFullYear() + 10

    /*!
        \qmlsignal Calendar::selected(var date)
        Emitted in Single mode when a day is picked. \a date is a JS \c Date.
    */
    signal selected(var date)

    /*!
        \qmlsignal Calendar::rangeSelected(var start, var end)
        Emitted in Range mode once the second endpoint completes the range.
        \a start and \a end are ordered JS \c Date values (start <= end).
    */
    signal rangeSelected(var start, var end)

    // ==== Internal derived state ====
    readonly property int _year: displayMonth.getFullYear()
    readonly property int _month: displayMonth.getMonth()
    property date _today: new Date()

    readonly property real _pad: Theme.space3           // p-3 = 12
    readonly property real _gridW: cellSize * 7
    readonly property real _monthGap: Theme.space4      // months container gap-4 = 16

    readonly property var _weekdays: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    readonly property var _monthNames: [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]
    readonly property var _monthShort: [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ]
    // Year model for the Dropdown caption: [fromYear .. toYear].
    readonly property var _years: {
        const arr = []
        for (let y = fromYear; y <= toYear; y++)
            arr.push(y)
        return arr
    }

    // 6 rows x 7 columns = 42 JS Dates for a month (with adjacent-month
    // padding). Each column in a multi-month view computes its own array.
    function _daysFor(year, month) {
        const first = new Date(year, month, 1)
        const startDow = first.getDay()   // 0 = Sunday
        const arr = []
        for (let i = 0; i < 42; i++)
            arr.push(new Date(year, month, 1 - startDow + i))
        return arr
    }

    function _sameDay(a, b) {
        return a !== undefined && b !== undefined
            && a.getFullYear() === b.getFullYear()
            && a.getMonth() === b.getMonth()
            && a.getDate() === b.getDate()
    }

    // Encode as year*10000 + month*100 + day for cross-month ordering
    // (used to decide range middle/endpoint order).
    function _dayNum(d) {
        return d.getFullYear() * 10000 + d.getMonth() * 100 + d.getDate()
    }

    // Pick a day: Single writes selectedDate; Range fills start then end
    // (swapping if picked out of order). When reframe is true (single-month
    // view clicking an outside day) jump displayMonth to that month;
    // multi-month views do not reframe.
    function _pick(date, reframe) {
        if (mode === Calendar.Range) {
            if (rangeStart === undefined || rangeEnd !== undefined) {
                // No start yet, or range already complete: begin a new span.
                rangeStart = date
                rangeEnd = undefined
            } else {
                // Have a start, no end yet: set the end (swap to keep start<=end).
                if (_dayNum(date) < _dayNum(rangeStart)) {
                    rangeEnd = rangeStart
                    rangeStart = date
                } else {
                    rangeEnd = date
                }
                rangeSelected(rangeStart, rangeEnd)
            }
        } else {
            selectedDate = date
            selected(date)
        }
        if (reframe)
            displayMonth = new Date(date.getFullYear(), date.getMonth(), 1)
    }

    implicitWidth: _gridW * numberOfMonths + _monthGap * (numberOfMonths - 1) + _pad * 2
    implicitHeight: monthsRow.implicitHeight + _pad * 2

    // ==== Side-by-side months (shared navigation overlaid on top) ====
    Row {
        id: monthsRow
        x: cal._pad
        y: cal._pad
        spacing: cal._monthGap

        Repeater {
            model: cal.numberOfMonths

            // ---- One month column: caption + weekday header + 6x7 grid ----
            ColumnLayout {
                id: mcol
                required property int index
                width: cal._gridW
                spacing: Theme.space3

                // This column's month = leading displayMonth + index months.
                readonly property date _mDate: new Date(cal._year, cal._month + index, 1)
                readonly property int _mYear: _mDate.getFullYear()
                readonly property int _mMonth: _mDate.getMonth()

                // ==== Month caption (label / dropdown; chevrons are shared,
                // so they are not drawn here). ====
                Item {
                    Layout.fillWidth: true
                    implicitHeight: cal.cellSize

                    // ---- Label caption (captionLayout = Label, default) ----
                    Text {
                        anchors.centerIn: parent
                        visible: cal.captionLayout === Calendar.Label
                        text: cal._monthNames[mcol._mMonth] + " " + mcol._mYear
                        color: Theme.foreground
                        font.pixelSize: Theme.textSm
                        font.weight: Font.Medium
                    }

                    // ---- Dropdown caption (captionLayout = Dropdown): month / year ----
                    Row {
                        anchors.centerIn: parent
                        visible: cal.captionLayout === Calendar.Dropdown
                        spacing: Theme.space1_5   // dropdowns gap-1.5

                        NativeSelect {
                            id: monthSelect
                            model: cal._monthShort
                            Component.onCompleted: currentIndex = mcol._mMonth
                            // Show the chosen month in this column, then back
                            // out the leading displayMonth (subtract the offset).
                            onActivated: (idx) => {
                                const t = new Date(mcol._mYear, idx, 1)
                                cal.displayMonth = new Date(t.getFullYear(), t.getMonth() - mcol.index, 1)
                            }
                        }
                        NativeSelect {
                            id: yearSelect
                            model: cal._years
                            Component.onCompleted: currentIndex = mcol._mYear - cal.fromYear
                            onActivated: (idx) => {
                                const t = new Date(cal.fromYear + idx, mcol._mMonth, 1)
                                cal.displayMonth = new Date(t.getFullYear(), t.getMonth() - mcol.index, 1)
                            }
                        }

                        // When navigation / outside-day clicks change
                        // displayMonth, sync this column's two dropdowns.
                        Connections {
                            target: cal
                            function onDisplayMonthChanged() {
                                monthSelect.currentIndex = mcol._mMonth
                                yearSelect.currentIndex = mcol._mYear - cal.fromYear
                            }
                        }
                    }
                }

                // ==== Weekday header (Su..Sa) ====
                Row {
                    Layout.fillWidth: true
                    spacing: 0
                    Repeater {
                        model: cal._weekdays
                        delegate: Item {
                            required property var modelData
                            width: cal.cellSize
                            height: cal.cellSize * 0.75
                            Text {
                                anchors.centerIn: parent
                                text: parent.modelData
                                color: Theme.mutedForeground
                                font.pixelSize: Theme.textXs
                            }
                        }
                    }
                }

                // ==== 6x7 day grid ====
                Grid {
                    Layout.fillWidth: true
                    columns: 7
                    rowSpacing: 2
                    columnSpacing: 0

                    Repeater {
                        model: cal._daysFor(mcol._mYear, mcol._mMonth)
                        delegate: Item {
                            id: dayCell
                            required property var modelData   // JS Date
                            width: cal.cellSize
                            height: cal.cellSize

                            // Whether this cell belongs to the column's month
                            // (drives dimming of outside-month padding days).
                            readonly property bool inMonth: modelData.getMonth() === mcol._mMonth
                                                         && modelData.getFullYear() === mcol._mYear
                            readonly property bool isToday: cal._sameDay(modelData, cal._today)
                            readonly property bool shown: inMonth || cal.showOutsideDays

                            // Single-selection highlight (Single mode only).
                            readonly property bool isSelectedSingle: cal.mode === Calendar.Single
                                                                  && cal._sameDay(modelData, cal.selectedDate)

                            // Range roles (Range mode only). _hasSpan: both
                            // endpoints set and >= 2 days apart, so a band is needed.
                            readonly property bool _rangeMode: cal.mode === Calendar.Range
                            readonly property bool _isStart: _rangeMode && cal.rangeStart !== undefined
                                                          && cal._sameDay(modelData, cal.rangeStart)
                            readonly property bool _isEnd: _rangeMode && cal.rangeEnd !== undefined
                                                        && cal._sameDay(modelData, cal.rangeEnd)
                            readonly property bool _hasSpan: _rangeMode
                                                          && cal.rangeStart !== undefined && cal.rangeEnd !== undefined
                                                          && cal._dayNum(cal.rangeEnd) > cal._dayNum(cal.rangeStart)
                            readonly property bool _isMiddle: _hasSpan
                                                           && cal._dayNum(modelData) > cal._dayNum(cal.rangeStart)
                                                           && cal._dayNum(modelData) < cal._dayNum(cal.rangeEnd)
                            readonly property bool _isEndpoint: _isStart || _isEnd
                            // In the connector band (start/middle/end, span present).
                            readonly property bool _inSpan: _hasSpan && (_isStart || _isMiddle || _isEnd)

                            // Primary pill: single-selected day or a range endpoint
                            // (bg-primary / text-primary-foreground).
                            readonly property bool _pillPrimary: isSelectedSingle || _isEndpoint
                            // Muted pill: today / hover (when not an endpoint or middle day).
                            readonly property bool _pillMuted: !_pillPrimary && !_isMiddle
                                                            && (isToday || hover.hovered)

                            // ---- Range connector band (muted) ----
                            // Start/middle/end all fill the same band; outer
                            // corners round at range endpoints or week boundaries:
                            //   * left round: cell is the start, or the week's first
                            //     day (Sunday) - i.e. no adjacent range cell to the left;
                            //   * right round: cell is the end, or the week's last day (Saturday).
                            // Every per-week band segment thus has rounded ends
                            // (matching the web); endpoints then stack a primary pill.
                            Rectangle {
                                visible: dayCell._inSpan
                                anchors.fill: parent
                                color: Theme.muted
                                readonly property bool _roundL: dayCell._isStart || dayCell.modelData.getDay() === 0
                                readonly property bool _roundR: dayCell._isEnd || dayCell.modelData.getDay() === 6
                                topLeftRadius:     _roundL ? Theme.radiusMd : 0
                                bottomLeftRadius:  _roundL ? Theme.radiusMd : 0
                                topRightRadius:    _roundR ? Theme.radiusMd : 0
                                bottomRightRadius: _roundR ? Theme.radiusMd : 0
                            }

                            // ---- Per-cell pill (radius-md, over the band) ----
                            Rectangle {
                                anchors.fill: parent
                                radius: Theme.radiusMd   // --cell-radius = radius-md
                                visible: dayCell.shown && (dayCell._pillPrimary || dayCell._pillMuted)
                                color: dayCell._pillPrimary ? Theme.primary : Theme.muted
                            }

                            // ---- Day number ----
                            Text {
                                anchors.centerIn: parent
                                text: dayCell.modelData.getDate()
                                font.pixelSize: Theme.textXs
                                color: dayCell._pillPrimary ? Theme.primaryForeground
                                     : dayCell.inMonth ? Theme.foreground
                                     : Theme.mutedForeground
                            }

                            HoverHandler { id: hover; enabled: dayCell.shown }
                            TapHandler {
                                enabled: dayCell.shown
                                // Single-month: clicking an outside day jumps the month;
                                // multi-month views stay put.
                                onTapped: cal._pick(dayCell.modelData, !dayCell.inMonth && cal.numberOfMonths === 1)
                            }
                        }
                    }
                }
            }
        }
    }

    // ==== Shared prev/next navigation (overlaid on the first caption row,
    // at the first column's left edge and the last column's right edge). ====
    // Moves one month at a time (react-day-picker default pagedNavigation=false).
    IconButton {
        objectName: "calPrev"
        variant: IconButton.Ghost
        size: IconButton.Small
        iconName: "chevron-left"
        x: monthsRow.x
        y: cal._pad + (cal.cellSize - height) / 2
        onClicked: cal.displayMonth = new Date(cal._year, cal._month - 1, 1)
    }
    IconButton {
        objectName: "calNext"
        variant: IconButton.Ghost
        size: IconButton.Small
        iconName: "chevron-right"
        x: monthsRow.x + monthsRow.width - width
        y: cal._pad + (cal.cellSize - height) / 2
        onClicked: cal.displayMonth = new Date(cal._year, cal._month + 1, 1)
    }
}
