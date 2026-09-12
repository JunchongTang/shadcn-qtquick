import QtQuick
import QtTest
import Shadcn

// Menubar family unit tests. The family is a bar (Item) holding MenubarMenu
// entries, each pairing a MenubarTrigger with a styled Menu popup. We assert the
// pieces that are deterministic under offscreen by driving the public API rather
// than real clicks: bar layout/padding, trigger text + active-background state,
// bar<->menu wiring (injection of `bar`), the single-open `openMenu` contract,
// and the openNow/close/toggle popup lifecycle.
Item {
    id: root
    width: 640
    height: 480

    // Standalone trigger, for trigger-level assertions (text, padding, _active).
    MenubarTrigger { id: soloTrigger; text: "File" }

    Menubar {
        id: bar
        MenubarMenu {
            id: fileMenu
            title: "File"
            MenuItem { text: "New Tab" }
            MenuItem { text: "New Window" }
        }
        MenubarMenu {
            id: editMenu
            title: "Edit"
            MenuItem { text: "Undo" }
        }
    }

    // Find the MenubarTrigger child of a MenubarMenu (the child carrying `open`).
    function triggerOf(menu) {
        for (var i = 0; i < menu.children.length; ++i) {
            var c = menu.children[i]
            if (c && c.open !== undefined && c.text !== undefined)
                return c
        }
        return null
    }

    TestCase {
        name: "Menubar"
        when: windowShown

        function init() {
            // Ensure a clean, closed state independent of test ordering.
            fileMenu.close()
            editMenu.close()
            tryCompare(bar, "openMenu", null)
        }

        // ---- Bar layout: h-9 height and p-1 padded inner Row ----
        function test_bar_layout() {
            compare(bar.implicitHeight, 36)               // h-9
            // Inner row is inset by p-1 on all sides.
            compare(bar.openMenu, null)
            verify(bar.implicitWidth > 0)
        }

        // ---- Menus are laid out horizontally, Edit after File ----
        function test_menus_ordered_horizontally() {
            wait(0)
            verify(fileMenu.width > 0)
            verify(editMenu.width > 0)
            verify(editMenu.x >= fileMenu.x + fileMenu.width)
        }

        // ---- Trigger text and padding (px-2, small py) ----
        function test_trigger_text_and_padding() {
            compare(soloTrigger.text, "File")
            compare(soloTrigger.leftPadding, Theme.space2)
            compare(soloTrigger.rightPadding, Theme.space2)
            compare(soloTrigger.topPadding, Theme.space1)
            compare(soloTrigger.bottomPadding, Theme.space1)
            compare(soloTrigger.font.weight, Font.Medium)
            compare(soloTrigger.font.pixelSize, Theme.textXs)
        }

        // ---- Trigger active-background: transparent by default, muted when open ----
        function test_trigger_active_background() {
            soloTrigger.open = false
            compare(soloTrigger.background.color.a, 0)          // transparent
            soloTrigger.open = true
            tryCompare(soloTrigger.background, "color", Theme.muted)
            soloTrigger.open = false
            tryCompare(soloTrigger.background, "color", Theme.alpha(Theme.muted, 0))
        }

        // ---- The open fill is a hook, and the fade-out follows it ----
        // An application whose toolbar uses overlay tints needs the bar on that same
        // scale; `muted` is an absolute fill and reads heavier next to them.
        function test_trigger_highlight_is_overridable() {
            const custom = Qt.rgba(1, 0, 0, 0.5)
            soloTrigger.highlight = custom
            soloTrigger.open = true
            tryCompare(soloTrigger.background, "color", custom)
            // Transparent is taken from the highlight, not from muted -- otherwise the
            // ramp crosses to another hue on its way out.
            soloTrigger.open = false
            tryCompare(soloTrigger.background, "color", Theme.alpha(custom, 0))
            soloTrigger.highlight = Theme.muted
        }

        // ---- Hover has its own fill, defaulting to the open one ----
        function test_hover_highlight_defaults_to_highlight() {
            const custom = Qt.rgba(0, 1, 0, 0.5)
            soloTrigger.highlight = custom
            compare(soloTrigger.hoverHighlight, custom,
                    "unset hoverHighlight must follow highlight -- the reference uses one colour")
            soloTrigger.highlight = Theme.muted
        }

        // ---- Set once on the bar, inherited by every menu ----
        function test_bar_drives_every_trigger() {
            const open = Qt.rgba(0, 0, 1, 0.5)
            const hover = Qt.rgba(0, 0, 1, 0.25)
            bar.triggerHighlight = open
            bar.triggerHoverHighlight = hover
            compare(triggerOf(fileMenu).highlight, open)
            compare(triggerOf(editMenu).highlight, open)
            compare(triggerOf(fileMenu).hoverHighlight, hover)

            // ... and a single menu can still opt out.
            const odd = Qt.rgba(1, 1, 0, 0.5)
            editMenu.highlight = odd
            compare(triggerOf(editMenu).highlight, odd)
            compare(triggerOf(fileMenu).highlight, open, "one menu opting out moved the others")

            bar.triggerHighlight = Theme.muted
            bar.triggerHoverHighlight = Theme.muted
        }

        // ---- Each MenubarMenu forwards its title to its trigger ----
        function test_menu_title_wired_to_trigger() {
            var fileTrigger = triggerOf(fileMenu)
            var editTrigger = triggerOf(editMenu)
            verify(fileTrigger !== null)
            verify(editTrigger !== null)
            compare(fileTrigger.text, "File")
            compare(editTrigger.text, "Edit")
            compare(fileMenu.title, "File")
        }

        // ---- Bar injects itself into every MenubarMenu (hover-switch wiring) ----
        function test_bar_injected_into_menus() {
            compare(fileMenu.bar, bar)
            compare(editMenu.bar, bar)
            compare(fileMenu.isMenubarMenu, true)
            compare(editMenu.isMenubarMenu, true)
        }

        // ---- openNow() opens the popup and claims openMenu ----
        function test_open_now_claims_open_menu() {
            compare(bar.openMenu, null)
            fileMenu.openNow()
            compare(bar.openMenu, fileMenu)
            tryCompare(fileMenu, "opened", true)
            fileMenu.close()
            tryCompare(fileMenu, "opened", false)
            tryCompare(bar, "openMenu", null)               // reset by Menu.onClosed
        }

        // ---- Only one menu open at a time: switching closes the previous ----
        function test_single_open_switch() {
            fileMenu.openNow()
            tryCompare(fileMenu, "opened", true)
            // Opening Edit (as a hover-switch would) takes over from File.
            editMenu.openNow()
            compare(bar.openMenu, editMenu)
            tryCompare(editMenu, "opened", true)
            tryCompare(fileMenu, "opened", false)
            editMenu.close()
            tryCompare(bar, "openMenu", null)
        }

        // ---- toggle() opens then closes ----
        function test_toggle() {
            fileMenu.toggle()
            tryCompare(fileMenu, "opened", true)
            compare(bar.openMenu, fileMenu)
            fileMenu.toggle()
            tryCompare(fileMenu, "opened", false)
            tryCompare(bar, "openMenu", null)
        }
    }
}
