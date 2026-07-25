import QtQuick
import QtTest
import Shadcn

// NavigationMenu family unit tests. The family is a RowLayout bar hosting
// NavigationMenuItem entries; each item pairs a NavigationMenuTrigger header
// with a NavigationMenuContent popover holding NavigationMenuLink rows. We
// assert what is deterministic under offscreen by driving the public API and
// container state rather than real hover: bar layout / single-open contract,
// trigger text + height + background state, content open/close lifecycle and
// positioning, and link styling / layout.
Item {
    id: root
    width: 800
    height: 600

    // Standalone trigger for trigger-level assertions (text, height, background).
    NavigationMenuTrigger {
        id: soloTrigger
        text: "Getting started"
    }

    // Standalone links for link-level styling assertions.
    NavigationMenuLink {
        id: plainLink
        text: "Introduction"
        description: "Re-usable components built with Tailwind CSS."
    }
    NavigationMenuLink {
        id: iconLink
        text: "Backlog"
        iconName: "circle-alert"
    }
    NavigationMenuLink {
        id: activeLink
        text: "Active"
        active: true
    }

    NavigationMenu {
        id: nav

        NavigationMenuItem {
            id: startItem
            text: "Getting started"
            contentWidth: 384
            NavigationMenuLink { text: "Introduction"; description: "desc a" }
            NavigationMenuLink { text: "Installation"; description: "desc b" }
        }
        NavigationMenuItem {
            id: compItem
            text: "Components"
            columns: 2
            contentWidth: 560
            NavigationMenuLink { text: "Alert Dialog"; description: "desc c" }
            NavigationMenuLink { text: "Hover Card"; description: "desc d" }
        }
        NavigationMenuItem {
            id: docsItem
            text: "Docs"
            asLink: true
            property int triggeredCount: 0
            onTriggered: triggeredCount++
        }
    }

    // Fetch the internal NavigationMenuContent popup of an item. The panel is a
    // Popup (non-visual, and reparented onto the trigger), so it lives in the
    // item's `data` list rather than `children`.
    function panelOf(navItem) {
        for (var i = 0; i < navItem.data.length; ++i) {
            var c = navItem.data[i]
            if (c && c.columns !== undefined && c.sideOffset !== undefined)
                return c
        }
        return null
    }

    // Fetch the internal NavigationMenuTrigger of an item.
    function triggerOf(navItem) {
        for (var i = 0; i < navItem.data.length; ++i) {
            var c = navItem.data[i]
            if (c && c.showChevron !== undefined && c.open !== undefined)
                return c
        }
        return null
    }

    TestCase {
        name: "NavigationMenu"
        when: windowShown

        function init() {
            // Clean, collapsed state independent of test ordering.
            nav.closeAll()
            tryCompare(nav, "openItem", null)
        }

        // ---- Bar: gap-0 and horizontal ordering (Components after Getting started) ----
        function test_bar_layout_and_order() {
            compare(nav.spacing, 0)                 // gap-0
            wait(0)
            verify(startItem.width > 0)
            verify(compItem.width > 0)
            verify(compItem.x >= startItem.x + startItem.width)
        }

        // ---- Single-open contract via requestOpen/requestClose/closeAll ----
        function test_single_open_contract() {
            nav.requestOpen(startItem)
            compare(nav.openItem, startItem)
            // Switching to another item takes over (only one open at a time).
            nav.requestOpen(compItem)
            compare(nav.openItem, compItem)
            // requestClose on a non-open item is a no-op.
            nav.requestClose(startItem)
            compare(nav.openItem, compItem)
            nav.requestClose(compItem)
            compare(nav.openItem, null)
            nav.requestOpen(startItem)
            nav.closeAll()
            compare(nav.openItem, null)
        }

        // ---- Trigger text, chevron presence, and h-9 height ----
        function test_trigger_text_and_height() {
            compare(soloTrigger.text, "Getting started")
            compare(soloTrigger.showChevron, true)
            compare(soloTrigger._minHeight, 36)
            compare(soloTrigger.implicitHeight, 36)   // h-9 enforced
            verify(soloTrigger.implicitWidth > 0)
        }

        // ---- Trigger background: transparent closed, muted/50 open ----
        function test_trigger_background_state() {
            // The backing Rectangle is the trigger's first visual child.
            var bg = soloTrigger.children[0]
            verify(bg !== null && bg.color !== undefined)
            soloTrigger.open = false
            tryCompare(bg, "color", Theme.alpha(Theme.muted, 0))       // transparent
            soloTrigger.open = true
            // Not hovered while open -> bg-muted/50.
            tryCompare(bg, "color", Theme.alpha(Theme.muted, 0.5))
            soloTrigger.open = false
            tryCompare(bg, "color", Theme.alpha(Theme.muted, 0))
        }

        // ---- Trigger drives its `open` from the container's openItem ----
        function test_trigger_open_follows_container() {
            var t = triggerOf(startItem)
            verify(t !== null)
            compare(t.open, false)
            nav.requestOpen(startItem)
            tryCompare(t, "open", true)
            nav.closeAll()
            tryCompare(t, "open", false)
        }

        // ---- A plain-link item emits triggered() and shows no chevron ----
        function test_plain_link_item() {
            var t = triggerOf(docsItem)
            verify(t !== null)
            compare(t.showChevron, false)              // asLink hides chevron
            compare(docsItem._hasContent, false)
            var before = docsItem.triggeredCount
            t.clicked()                                 // simulate activation
            compare(docsItem.triggeredCount, before + 1)
        }

        // ---- Content panel: columns/width wiring and open/close lifecycle ----
        function test_content_open_close() {
            var panel = panelOf(startItem)
            verify(panel !== null)
            compare(panel.columns, 1)
            compare(panel.width, 384)
            compare(panel.sideOffset, 8)

            nav.requestOpen(startItem)                  // Connections opens the panel
            tryCompare(panel, "opened", true)
            nav.closeAll()
            tryCompare(panel, "opened", false)
        }

        // ---- Content panel of the 2-column item reflects columns/contentWidth ----
        function test_content_columns_wiring() {
            var panel = panelOf(compItem)
            verify(panel !== null)
            compare(panel.columns, 2)
            compare(panel.width, 560)
        }

        // ---- Content sits below its trigger by sideOffset (positioning) ----
        function test_content_position() {
            var panel = panelOf(startItem)
            var t = triggerOf(startItem)
            verify(panel !== null && t !== null)
            compare(panel.x, 0)
            compare(panel.y, t.height + panel.sideOffset)
        }

        // ---- Link layout: p-2 padding and description grows the height ----
        function test_link_layout_padding() {
            compare(plainLink.implicitWidth, 180)
            // Height includes p-2 top+bottom (space2 * 2) beyond content.
            verify(plainLink.implicitHeight > Theme.space2 * 2)
            // A described link is taller than a title-only link.
            verify(plainLink.implicitHeight > activeLink.implicitHeight)
        }

        // ---- Link background: transparent by default, muted/50 when active ----
        function test_link_active_styling() {
            var bg = activeLink.children[0]             // backing Rectangle
            verify(bg !== null)
            compare(bg.radius, Theme.radiusMd)          // in-content rounded-md
            // active (not hovered) -> bg-muted/50.
            compare(bg.color, Theme.alpha(Theme.muted, 0.5))
            // A non-active, non-hovered link is transparent.
            compare(plainLink.children[0].color.a, 0)
        }

        // ---- Link with an icon exposes it; plain link does not ----
        function test_link_icon_presence() {
            compare(iconLink.iconName, "circle-alert")
            compare(plainLink.iconName, "")
        }
    }
}
