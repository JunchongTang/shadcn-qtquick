import QtQuick
import QtTest
import Shadcn

// Pagination unit tests: the page-window / ellipsis computation for various
// count / page / siblingCount, Previous / Next enabled state, the pageRequested
// signal (with clamping), and the active-page highlight (outline variant).
// Everything is asserted by reading computed properties and delegate state, so
// the suite is deterministic offscreen (no mouse / focus required).
Item {
    id: root
    width: 480
    height: 120

    Pagination { id: pag; count: 10; page: 5 }
    Pagination { id: pagSimple; count: 5; page: 2; showPrevNext: false }

    SignalSpy { id: reqSpy; target: pag; signalName: "pageRequested" }

    TestCase {
        name: "Pagination"
        when: windowShown

        function init() {
            reqSpy.clear()
            pag.count = 10
            pag.page = 5
            pag.siblingCount = 1
        }

        function test_defaults() {
            var p = Qt.createQmlObject("import Shadcn; Pagination {}", root)
            compare(p.count, 1)
            compare(p.page, 1)
            compare(p.siblingCount, 1)
            compare(p.showPrevNext, true)
            compare(p.showPages, true)
            compare(p._items, [1])
            compare(p._canPrev, false)
            compare(p._canNext, false)
            p.destroy()
        }

        // Page window / ellipsis sequence for representative inputs.
        function test_pages_window_data() {
            return [
                // total<=7 -> no collapsing, show every page.
                { tag: "small-5",  count: 5,  page: 2, sib: 1, out: [1, 2, 3, 4, 5] },
                { tag: "exact-7",  count: 7,  page: 4, sib: 1, out: [1, 2, 3, 4, 5, 6, 7] },
                // Near the start: right ellipsis only.
                { tag: "start-10", count: 10, page: 1, sib: 1, out: [1, 2, 3, 4, 5, "ellipsis", 10] },
                { tag: "left3-10", count: 10, page: 3, sib: 1, out: [1, 2, 3, 4, 5, "ellipsis", 10] },
                // In the middle: both ellipses.
                { tag: "mid-10",   count: 10, page: 5, sib: 1, out: [1, "ellipsis", 4, 5, 6, "ellipsis", 10] },
                // Near the end: left ellipsis only.
                { tag: "end-10",   count: 10, page: 10, sib: 1, out: [1, "ellipsis", 6, 7, 8, 9, 10] },
                // Larger sibling window widens the middle run.
                { tag: "sib2-mid", count: 10, page: 5, sib: 2, out: [1, "ellipsis", 3, 4, 5, 6, 7, "ellipsis", 10] },
                // Degenerate totals clamp to at least one page.
                { tag: "zero",     count: 0,  page: 1, sib: 1, out: [1] },
            ]
        }
        function test_pages_window(data) {
            pag.siblingCount = data.sib
            pag.count = data.count
            pag.page = data.page
            compare(pag._items, data.out)
        }

        // Previous is enabled only when page > 1; Next only when page < count.
        function test_prevnext_enabled() {
            pag.page = 1
            compare(pag._canPrev, false)
            compare(pag._canNext, true)
            pag.page = 5
            compare(pag._canPrev, true)
            compare(pag._canNext, true)
            pag.page = 10
            compare(pag._canPrev, true)
            compare(pag._canNext, false)
        }

        // _goto updates page, clamps into [1, count], and always emits
        // pageRequested with the clamped target.
        function test_pageRequested_signal() {
            pag.page = 5
            pag._goto(3)
            compare(pag.page, 3)
            compare(reqSpy.count, 1)
            compare(reqSpy.signalArguments[0][0], 3)

            // Over-run clamps to count.
            pag._goto(99)
            compare(pag.page, 10)
            compare(reqSpy.signalArguments[1][0], 10)

            // Under-run clamps to 1.
            pag._goto(-5)
            compare(pag.page, 1)
            compare(reqSpy.signalArguments[2][0], 1)
        }

        // The delegate matching the current page is active (outline); the others
        // are ghost, and ellipsis cells expose no visible button.
        function test_active_highlight() {
            pag.siblingCount = 1
            pag.count = 10
            pag.page = 5
            // _items = [1, "ellipsis", 4, 5, 6, "ellipsis", 10]
            var rep = pag._pagesRepeater
            compare(rep.count, 7)

            var active = rep.itemAt(3)          // page 5
            compare(active._active, true)
            compare(active._button.variant, Button.Outline)

            var other = rep.itemAt(2)           // page 4
            compare(other._active, false)
            compare(other._button.variant, Button.Ghost)

            var dots = rep.itemAt(1)            // "ellipsis"
            compare(dots._isEllipsis, true)
            compare(dots._button.visible, false)

            // Moving the current page moves the highlight. At page 4 the
            // window shifts to [1, "ellipsis", 3, 4, 5, "ellipsis", 10], so the
            // active page 4 now sits at index 3.
            pag.page = 4
            compare(rep.itemAt(3)._active, true)
            compare(rep.itemAt(3)._button.variant, Button.Outline)
            compare(rep.itemAt(2)._active, false)   // index 2 is page 3
        }

        // showPrevNext = false hides the Prev/Next controls but still lists pages.
        function test_pages_only() {
            compare(pagSimple._items, [1, 2, 3, 4, 5])
            compare(pagSimple._pagesRepeater.count, 5)
        }
    }
}
