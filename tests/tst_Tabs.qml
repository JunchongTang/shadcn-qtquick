import QtQuick
import QtQuick.Layouts
import QtTest
import Shadcn

// Tabs unit tests: defaults, tab switching (currentIndex + checked state), the
// active-tab pill geometry (including the vertical equal-width #005 guard), the
// tab-list background per variant, the line underline, and content switching via
// a StackLayout bound to currentIndex. Appearance is asserted by reading the
// rendered background rectangles. Deterministic and offscreen-friendly.
Item {
    id: root
    width: 480
    height: 320

    // Horizontal default strip.
    Tabs {
        id: hTabs
        TabButton { id: bOverview;  text: "Overview" }
        TabButton { id: bAnalytics; text: "Analytics" }
        TabButton { id: bReports;   text: "Reports" }
    }

    // Line variant.
    Tabs {
        id: lTabs
        variant: Tabs.Line
        y: 60
        TabButton { id: lOverview;  text: "Overview" }
        TabButton { id: lAnalytics; text: "Analytics" }
    }

    // Vertical strip with different-length labels (for the width guard).
    Tabs {
        id: vTabs
        vertical: true
        y: 120
        TabButton { id: vAccount;       text: "Account" }
        TabButton { id: vPassword;      text: "Password" }
        TabButton { id: vNotifications; text: "Notifications" }
    }

    // Horizontal strip stretched wider than its content (flex-1 fill), with
    // unequal-length labels to prove the equal-width distribution.
    Tabs {
        id: sTabs
        y: 180
        width: 400
        TabButton { id: sA; text: "Hi" }             // short (2 chars)
        TabButton { id: sB; text: "Notifications" }  // long
    }

    // Content follows the horizontal strip's currentIndex.
    StackLayout {
        id: stack
        y: 240
        currentIndex: hTabs.currentIndex
        Text { text: "panel 0" }
        Text { text: "panel 1" }
        Text { text: "panel 2" }
    }

    TestCase {
        name: "Tabs"
        when: windowShown

        function init() {
            hTabs.currentIndex = 0
            lTabs.currentIndex = 0
            vTabs.currentIndex = 0
        }

        function test_defaults() {
            compare(hTabs.variant, Tabs.Default)
            compare(hTabs.vertical, false)
            compare(hTabs.orientation, Tabs.Horizontal)
            compare(vTabs.orientation, Tabs.Vertical)
            compare(hTabs.count, 3)
            compare(hTabs.currentIndex, 0)
            compare(bOverview.checked, true)
            compare(hTabs.implicitHeight, 32)   // h-8
        }

        // Switching currentIndex moves the checked state to the matching trigger.
        function test_tab_switching() {
            hTabs.currentIndex = 1
            compare(bOverview.checked, false)
            compare(bAnalytics.checked, true)
            hTabs.setCurrentIndex(2)
            compare(bAnalytics.checked, false)
            compare(bReports.checked, true)
        }

        // The active trigger's pill fills the trigger, is rounded-md, and paints
        // the background color; inactive triggers keep a transparent pill.
        function test_active_pill_geometry() {
            hTabs.currentIndex = 0
            var pill = bOverview.background.children[0]
            verify(pill.visible)                       // default variant -> pill shown
            compare(pill.radius, Theme.radiusMd)
            compare(pill.width, bOverview.width)        // anchors.fill parent
            compare(pill.height, bOverview.height)
            tryCompare(pill, "color", Theme.background) // active -> bg-background

            var inactive = bAnalytics.background.children[0]
            compare(inactive.color.a, 0)                // transparent when inactive
        }

        // #005 guard: vertical triggers all stretch to the list width so the pill
        // and muted background stay aligned; binding uses ListView.view.width so
        // this must not loop. Widths are equal and exceed the narrow label's own.
        function test_vertical_width_guard() {
            tryCompare(vAccount, "width", vNotifications.width)
            compare(vPassword.width, vNotifications.width)
            // All triggers equal the content (ListView) width.
            compare(vAccount.width, vTabs.contentItem.width)
            // The short "Account" label was stretched beyond its intrinsic width.
            verify(vAccount.width > vAccount.implicitWidth)
        }

        // flex-1 fill: when the horizontal strip is stretched wider than its
        // content, unequal-length triggers become equal width and together fill
        // the list (independent of label length). The short "Hi" is padded out.
        function test_horizontal_stretch_equal_width() {
            tryCompare(sA, "width", sB.width)
            verify(sA.width > sA.implicitWidth)          // short label stretched out
            // The two triggers plus inter-item spacing fill the content width.
            var used = sA.width + sB.width + sTabs.spacing
            fuzzyCompare(used, sTabs.contentItem.width, 1)
        }

        // Default list: muted rounded-lg background; line list: transparent, square.
        function test_tab_list_background() {
            compare(hTabs.background.color, Theme.muted)
            compare(hTabs.background.radius, Theme.radiusLg)
            compare(lTabs.background.color.a, 0)        // bg-transparent
            compare(lTabs.background.radius, 0)         // rounded-none
        }

        // Line variant: pill hidden, underline shown and opaque when active.
        function test_line_underline() {
            lTabs.currentIndex = 0
            var pill = lOverview.background.children[0]
            var underline = lOverview.background.children[1]
            compare(pill.visible, false)                // no pill in line variant
            compare(underline.visible, true)
            tryCompare(underline, "opacity", 1)         // active -> fully shown
            // Inactive line trigger keeps the underline hidden (opacity 0).
            tryCompare(lAnalytics.background.children[1], "opacity", 0)
        }

        // Content switching: a StackLayout bound to currentIndex follows along.
        function test_content_switching() {
            hTabs.currentIndex = 0
            compare(stack.currentIndex, 0)
            hTabs.currentIndex = 2
            compare(stack.currentIndex, 2)
        }
    }
}
