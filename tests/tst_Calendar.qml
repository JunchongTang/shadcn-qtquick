import QtQuick
import QtTest
import Shadcn

// Calendar unit tests: interface defaults, single-selection (sets selectedDate
// + emits selected), month navigation (prev/next update displayMonth), and
// range mode (fills start/end, ordering, emits rangeSelected).
// Deterministic under offscreen: displayMonth is set explicitly so tests never
// depend on today's date. Geometry is read where useful (multi-month width).
Item {
    id: root
    width: 640
    height: 480

    // Single-selection instance, pinned to January 2024.
    Calendar {
        id: single
        displayMonth: new Date(2024, 0, 1)
    }

    // Range instance, pinned to January 2024.
    Calendar {
        id: range
        mode: Calendar.Range
        displayMonth: new Date(2024, 0, 1)
    }

    // Two-month instance for geometry assertions.
    Calendar {
        id: dual
        numberOfMonths: 2
        displayMonth: new Date(2024, 0, 1)
    }

    SignalSpy { id: selectedSpy; target: single; signalName: "selected" }
    SignalSpy { id: rangeSpy; target: range; signalName: "rangeSelected" }

    TestCase {
        name: "Calendar"
        when: windowShown

        // Recursive lookup of a visible child by objectName.
        function findByName(item, name) {
            if (!item)
                return null
            for (var i = 0; i < item.children.length; i++) {
                var c = item.children[i]
                if (c.objectName === name)
                    return c
                var f = findByName(c, name)
                if (f)
                    return f
            }
            return null
        }

        function init() {
            selectedSpy.clear()
            rangeSpy.clear()
            single.selectedDate = undefined
            single.displayMonth = new Date(2024, 0, 1)
            range.mode = Calendar.Range
            range.rangeStart = undefined
            range.rangeEnd = undefined
            range.displayMonth = new Date(2024, 0, 1)
        }

        // ---- Interface defaults ----
        function test_defaults() {
            compare(single.mode, Calendar.Single)
            compare(single.captionLayout, Calendar.Label)
            compare(single.numberOfMonths, 1)
            compare(single.showOutsideDays, true)
            verify(single.selectedDate === undefined)
            verify(single.rangeStart === undefined)
            verify(single.rangeEnd === undefined)
        }

        // ---- Single: picking a day sets selectedDate and emits selected ----
        function test_single_select() {
            var d = new Date(2024, 0, 15)
            single._pick(d, false)
            verify(single.selectedDate !== undefined)
            verify(single._sameDay(single.selectedDate, d))
            compare(selectedSpy.count, 1)
            verify(single._sameDay(selectedSpy.signalArguments[0][0], d))
        }

        // ---- Single: clicking an outside day reframes the month ----
        function test_single_reframe() {
            // A day in February reached via reframe=true jumps displayMonth.
            var d = new Date(2024, 1, 3)
            single._pick(d, true)
            compare(single.displayMonth.getMonth(), 1) // February
            compare(single.displayMonth.getFullYear(), 2024)
        }

        // ---- Navigation: prev/next buttons update displayMonth by one month ----
        function test_navigation() {
            var prev = findByName(single, "calPrev")
            var next = findByName(single, "calNext")
            verify(prev !== null)
            verify(next !== null)

            // Start at January 2024.
            compare(single.displayMonth.getMonth(), 0)
            next.clicked()
            compare(single.displayMonth.getMonth(), 1) // February
            prev.clicked()
            prev.clicked()
            compare(single.displayMonth.getMonth(), 11) // rolled back to December
            compare(single.displayMonth.getFullYear(), 2023)
        }

        // ---- Range: first pick sets start; second completes and emits ----
        function test_range_select() {
            var start = new Date(2024, 0, 10)
            var end = new Date(2024, 0, 20)
            range._pick(start, false)
            verify(range._sameDay(range.rangeStart, start))
            verify(range.rangeEnd === undefined)
            compare(rangeSpy.count, 0)

            range._pick(end, false)
            verify(range._sameDay(range.rangeStart, start))
            verify(range._sameDay(range.rangeEnd, end))
            compare(rangeSpy.count, 1)
            verify(range._sameDay(rangeSpy.signalArguments[0][0], start))
            verify(range._sameDay(rangeSpy.signalArguments[0][1], end))
        }

        // ---- Range: out-of-order endpoints are swapped to keep start <= end ----
        function test_range_swap() {
            var later = new Date(2024, 0, 25)
            var earlier = new Date(2024, 0, 5)
            range._pick(later, false)
            range._pick(earlier, false)
            verify(range._sameDay(range.rangeStart, earlier))
            verify(range._sameDay(range.rangeEnd, later))
        }

        // ---- Range: picking again after a complete range starts a new span ----
        function test_range_restart() {
            range._pick(new Date(2024, 0, 5), false)
            range._pick(new Date(2024, 0, 15), false)
            verify(range.rangeEnd !== undefined)
            var fresh = new Date(2024, 0, 22)
            range._pick(fresh, false)
            verify(range._sameDay(range.rangeStart, fresh))
            verify(range.rangeEnd === undefined)
        }

        // ---- Geometry: two-month width = 2 grids + gap + 2 pads ----
        function test_multimonth_geometry() {
            var expected = dual._gridW * 2 + dual._monthGap + dual._pad * 2
            compare(dual.numberOfMonths, 2)
            verify(Math.abs(dual.implicitWidth - expected) <= 0.5)
            // Next moves the leading month forward by exactly one month.
            var next = findByName(dual, "calNext")
            verify(next !== null)
            var m0 = dual.displayMonth.getMonth()
            next.clicked()
            compare(dual.displayMonth.getMonth(), (m0 + 1) % 12)
        }
    }
}
