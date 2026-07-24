import QtQuick
import QtTest
import Shadcn

// DatePicker / DateRangePicker unit tests: interface defaults (placeholder,
// align, displayFormat, numberOfMonths), the _format() helper, selecting a day
// through the popover's Calendar (sets selectedDate/range + emits the signal +
// closes the popover), the _lastPopClose reopen-guard toggle logic, and the
// DateRangePicker _label for zero/one/two endpoints.
//
// Deterministic under offscreen: all dates are pinned (never today's date), and
// _format is asserted against Qt.formatDate() with the same format string so the
// checks are locale-independent. The private Popover is reached through the
// control's `data` list (it is a non-visual Popup, so it is a resource, not a
// visual child); the inner Calendar is then found under pop.contentItem.
Item {
    id: root
    width: 640
    height: 480

    DatePicker { id: dp }
    DateRangePicker { id: drp }

    SignalSpy { id: selectedSpy; target: dp; signalName: "selected" }
    SignalSpy { id: rangeSpy; target: drp; signalName: "rangeSelected" }

    TestCase {
        name: "DatePicker"
        when: windowShown

        // Pinned dates (deterministic; never today).
        readonly property var d1: new Date(2024, 0, 15)   // Jan 15, 2024
        readonly property var rStart: new Date(2024, 0, 10)
        readonly property var rEnd: new Date(2024, 0, 20)

        // ---- helpers ------------------------------------------------------

        // The inline Popover is a non-visual Popup, so it lands in the control's
        // `data`/resources list rather than among visual children. Identify it by
        // its Popup API surface.
        function findPopover(ctrl) {
            var list = ctrl.data
            for (var i = 0; i < list.length; i++) {
                var o = list[i]
                if (o && typeof o.open === "function"
                      && typeof o.close === "function"
                      && o.opened !== undefined)
                    return o
            }
            return null
        }

        // Recursive lookup of the (single) Calendar below the given item,
        // identified by its _pick function + mode property. Mode-agnostic: each
        // popover contains exactly one Calendar, so we don't filter by mode here
        // (filtering across the whole tree was fragile when multiple pickers
        // coexist); callers assert cal.mode separately.
        function findAnyCalendar(item) {
            if (!item)
                return null
            if (typeof item._pick === "function" && item.mode !== undefined)
                return item
            for (var i = 0; i < item.children.length; i++) {
                var f = findAnyCalendar(item.children[i])
                if (f)
                    return f
            }
            return null
        }

        // Locate a popover's Calendar under its contentItem (where it lives once
        // the popover opens; verified via a render probe).
        function locateCalendar(pop) {
            return findAnyCalendar(pop.contentItem)
        }

        function sameYMD(a, b) {
            return a !== undefined && b !== undefined
                && a.getFullYear() === b.getFullYear()
                && a.getMonth() === b.getMonth()
                && a.getDate() === b.getDate()
        }

        function init() {
            // Close any open popover and reset all mutable state between tests.
            var p1 = findPopover(dp)
            var p2 = findPopover(drp)
            if (p1) p1.close()
            if (p2) p2.close()
            if (p1) tryVerify(function() { return !p1.visible })
            if (p2) tryVerify(function() { return !p2.visible })
            dp.selectedDate = undefined
            dp._lastPopClose = 0
            drp.rangeStart = undefined
            drp.rangeEnd = undefined
            drp._lastPopClose = 0
            selectedSpy.clear()
            rangeSpy.clear()
        }

        // ---- DatePicker: interface defaults -------------------------------
        function test_dp_defaults() {
            compare(dp.placeholder, "Pick a date")
            compare(dp.align, Popover.Align.Start)   // also guards enum resolution
            compare(dp.displayFormat, "MMMM d, yyyy")
            verify(dp.selectedDate === undefined)
            verify(dp._empty)
        }

        // ---- DatePicker: _format helper (locale-independent) --------------
        function test_dp_format() {
            compare(dp._format(undefined), "")
            compare(dp._format(d1), Qt.formatDate(d1, dp.displayFormat))
            // Sanity: with the default format the output is non-empty and stable.
            verify(dp._format(d1).length > 0)
        }

        // ---- DatePicker: selecting a day via the popover ------------------
        function test_dp_select_via_popover() {
            var pop = findPopover(dp)
            verify(pop !== null)

            pop.open()
            tryVerify(function() { return pop.opened })

            // Content lays out asynchronously; wait until the Calendar exists.
            var cal = null
            tryVerify(function() {
                cal = locateCalendar(pop)
                return cal !== null
            })

            cal._pick(d1, false)   // emulate a day click inside the popover

            // Selection propagated up, signal emitted, and the popover closed.
            tryVerify(function() { return sameYMD(dp.selectedDate, d1) })
            verify(!dp._empty)
            tryVerify(function() { return selectedSpy.count === 1 })
            verify(sameYMD(selectedSpy.signalArguments[0][0], d1))
            tryVerify(function() { return !pop.opened })
        }

        // ---- DatePicker: _lastPopClose reopen-guard toggle logic ----------
        function test_dp_reopen_guard() {
            var pop = findPopover(dp)
            verify(pop !== null)
            tryVerify(function() { return !pop.visible })

            // (1) A recent close suppresses the reopen on the next click.
            dp._lastPopClose = Date.now()
            dp.clicked()
            verify(!pop.visible)   // open() was not called

            // (2) Once the guard window (250ms) has passed, a click opens it.
            dp._lastPopClose = Date.now() - 1000
            dp.clicked()
            verify(pop.visible)    // open() called; visible flips synchronously
            tryVerify(function() { return pop.opened })

            // (3) Clicking while open closes it (pop.opened branch).
            dp.clicked()
            tryVerify(function() { return !pop.opened })

            // (4) Closing stamps _lastPopClose via the openedChanged connection.
            dp._lastPopClose = 0
            pop.open()
            tryVerify(function() { return pop.opened })
            pop.close()
            tryVerify(function() { return !pop.opened })
            verify(dp._lastPopClose > 0)
        }

        // ---- DateRangePicker: interface defaults --------------------------
        function test_drp_defaults() {
            compare(drp.placeholder, "Pick a date")
            compare(drp.align, Popover.Align.Start)
            compare(drp.displayFormat, "MMM dd, yyyy")
            compare(drp.numberOfMonths, 2)
            verify(drp.rangeStart === undefined)
            verify(drp.rangeEnd === undefined)
            verify(drp._empty)
        }

        // ---- DateRangePicker: _label for zero / one / two endpoints -------
        function test_drp_label() {
            // Empty -> placeholder.
            drp.rangeStart = undefined
            drp.rangeEnd = undefined
            compare(drp._label, drp.placeholder)

            // One endpoint -> single formatted date.
            drp.rangeStart = rStart
            drp.rangeEnd = undefined
            compare(drp._label, Qt.formatDate(rStart, drp.displayFormat))

            // Both endpoints -> "start - end".
            drp.rangeEnd = rEnd
            compare(drp._label,
                    Qt.formatDate(rStart, drp.displayFormat)
                    + " - "
                    + Qt.formatDate(rEnd, drp.displayFormat))

            // Reset.
            drp.rangeStart = undefined
            drp.rangeEnd = undefined
        }

        // ---- DateRangePicker: selecting a range via the popover -----------
        function test_drp_select_via_popover() {
            var pop = findPopover(drp)
            verify(pop !== null)

            pop.open()
            tryVerify(function() { return pop.opened })

            // The 2-month range content lays out asynchronously; wait for it.
            var cal = null
            tryVerify(function() {
                cal = locateCalendar(pop)
                return cal !== null
            })
            compare(cal.mode, Calendar.Range)

            // First endpoint: the calendar records it internally but does NOT
            // emit rangeSelected yet, so the control's rangeStart stays undefined
            // until the range completes on the second pick.
            cal._pick(rStart, false)
            compare(rangeSpy.count, 0)

            cal._pick(rEnd, false)     // second endpoint: completes the range
            tryVerify(function() { return sameYMD(drp.rangeEnd, rEnd) })
            verify(sameYMD(drp.rangeStart, rStart))
            tryVerify(function() { return rangeSpy.count === 1 })
            verify(sameYMD(rangeSpy.signalArguments[0][0], rStart))
            verify(sameYMD(rangeSpy.signalArguments[0][1], rEnd))
            tryVerify(function() { return !pop.opened })
        }
    }
}
