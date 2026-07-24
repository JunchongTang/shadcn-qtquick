import QtQuick
import QtTest
import Shadcn

// Breadcrumb unit tests: separator/ellipsis glyph box sizes, list/item gaps,
// link + page text colors and font metrics, and the assembled-trail layout
// (horizontal ordering with gaps, vertical centering). Appearance is asserted
// by reading rendered geometry and directly-bound colors; all checks are
// relationship-based so they stay deterministic under the offscreen platform
// regardless of the fallback font's exact text metrics.
Item {
    id: root
    width: 480
    height: 240

    // Standalone instances for pure size/property checks.
    BreadcrumbSeparator { id: sep }
    BreadcrumbSeparator { id: sepDot; iconName: "dot" }
    BreadcrumbEllipsis { id: ell }
    BreadcrumbLink { id: linkStd; text: "Solo" }
    BreadcrumbPage { id: pageStd; text: "Solo" }

    // Assembled trail: Home (link) > sep > Breadcrumb (page).
    Breadcrumb {
        id: bc
        BreadcrumbItem {
            id: item0
            BreadcrumbLink { id: link; text: "Home" }
        }
        BreadcrumbSeparator { id: sep0 }
        BreadcrumbItem {
            id: item1
            BreadcrumbPage { id: page; text: "Breadcrumb" }
        }
    }

    SignalSpy { id: clickSpy; target: link; signalName: "clicked" }

    TestCase {
        name: "Breadcrumb"
        when: windowShown

        // gap-1.5 (6) between list entries; gap-1 (4) inside an item.
        function test_gaps() {
            compare(bc.spacing, Theme.space1_5)   // 6
            compare(item0.spacing, Theme.space1)  // 4
        }

        // Separator glyph box = svg size-3.5 -> 14x14; default chevron.
        function test_separator_size() {
            compare(sep.implicitWidth, 14)
            compare(sep.implicitHeight, 14)
            compare(sep.iconName, "chevron-right")
            compare(sepDot.iconName, "dot")   // custom separator variant
        }

        // Ellipsis container = size-4 -> 16x16.
        function test_ellipsis_size() {
            compare(ell.implicitWidth, 16)
            compare(ell.implicitHeight, 16)
        }

        // Link: muted-foreground by default, text-xs, relaxed line height.
        function test_link_appearance() {
            compare(linkStd.color, Theme.mutedForeground)
            compare(linkStd.font.pixelSize, Theme.textXs)   // 12
            compare(linkStd.lineHeight, Theme.lineRelaxed)
            compare(linkStd.lineHeightMode, Text.ProportionalHeight)
            verify(clickSpy.valid)   // clicked() signal is exposed
        }

        // Page: foreground color, font-normal weight, text-xs.
        function test_page_appearance() {
            compare(pageStd.color, Theme.foreground)
            compare(pageStd.font.weight, Font.Normal)
            compare(pageStd.font.pixelSize, Theme.textXs)   // 12
        }

        // Assembled trail lays out left-to-right with the list gap between
        // each entry, and the separator keeps its fixed 14px width.
        function test_trail_horizontal_layout() {
            compare(item0.x, 0)
            fuzzyCompare(sep0.x, item0.width + Theme.space1_5, 0.6)
            compare(sep0.width, 14)
            fuzzyCompare(item1.x, sep0.x + sep0.width + Theme.space1_5, 0.6)
            verify(page.text === "Breadcrumb")
            verify(link.text === "Home")
        }

        // items-center: every entry's vertical midpoint aligns with the list.
        function test_trail_vertical_centering() {
            var mid = bc.height / 2
            fuzzyCompare(item0.y + item0.height / 2, mid, 1.0)
            fuzzyCompare(sep0.y + sep0.height / 2, mid, 1.0)
            fuzzyCompare(item1.y + item1.height / 2, mid, 1.0)
        }
    }
}
