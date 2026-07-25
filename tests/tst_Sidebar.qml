import QtQuick
import QtQuick.Layouts
import QtTest
import Shadcn

// Sidebar family unit tests. The Sidebar root is a Rectangle whose first child
// (children[0]) is the vertical ColumnLayout holding Header / Content / Footer
// in that order, and whose second child (children[1]) is the 1px right border.
// Appearance and layout are asserted from public properties and rendered
// geometry. Collapse/expand is driven purely through the API: the `collapsed`
// property and the SidebarTrigger's clicked() signal (never synthetic input),
// so it is deterministic under offscreen. Width, height and opacity animate via
// Behaviors, so animated properties are read with tryCompare (polls until the
// value settles). Theme.dark defaults to false so light-mode tokens apply.
Item {
    id: root
    width: 900
    height: 700

    Sidebar {
        id: sidebar
        height: 500

        SidebarHeader {
            id: header
            Rectangle { id: headerChild; implicitWidth: 80; implicitHeight: 20; color: "#111111" }
        }

        SidebarContent {
            id: content

            SidebarGroup {
                id: group
                SidebarGroupLabel { id: groupLabel; text: "Platform" }
                SidebarMenu {
                    id: menu
                    SidebarMenuItem {
                        id: menuItem1
                        SidebarMenuButton { id: menuBtn; iconName: "house"; text: "Home"; active: true }
                    }
                    SidebarMenuItem {
                        id: menuItem2
                        SidebarMenuButton { id: menuBtn2; iconName: "inbox"; text: "Inbox" }
                    }
                }
            }

            SidebarSeparator { id: sep }
        }

        SidebarFooter {
            id: footer
            Rectangle { id: footerChild; implicitWidth: 60; implicitHeight: 20; color: "#222222" }
        }
    }

    SidebarTrigger { id: trigger; sidebar: sidebar }
    SidebarRail { id: rail; sidebar: sidebar }

    TestCase {
        name: "Sidebar"
        when: windowShown

        // The Sidebar root's children: [ColumnLayout, border Rectangle].
        function stackCol()  { return sidebar.children[0] }
        function borderRect() { return sidebar.children[1] }

        // Reset to the expanded state before each test and let the width settle.
        function init() {
            sidebar.collapsed = false
            tryCompare(sidebar, "implicitWidth", sidebar.expandedWidth)
        }

        // ---- Defaults --------------------------------------------------
        function test_defaults() {
            compare(sidebar.collapsed, false)
            compare(sidebar.expandedWidth, 256)   // --sidebar-width 16rem
            compare(sidebar.iconWidth, 48)        // --sidebar-width-icon 3rem
            compare(sidebar._isSidebarRoot, true)
            compare(sidebar.color, Theme.sidebar)
            compare(sidebar.implicitWidth, 256)
        }

        // ---- Right border is 1px in sidebar-border --------------------
        function test_border() {
            let b = borderRect()
            compare(b.width, 1)
            compare(b.color, Theme.sidebarBorder)
            // Anchored to the right edge of the sidebar.
            fuzzyCompare(b.mapToItem(sidebar, 0, 0).x, sidebar.width - 1, 0.5)
        }

        // ---- Collapse / expand via the collapsed property -------------
        function test_collapse_expand_property() {
            sidebar.collapsed = true
            tryCompare(sidebar, "implicitWidth", sidebar.iconWidth)   // 48
            sidebar.collapsed = false
            tryCompare(sidebar, "implicitWidth", sidebar.expandedWidth) // 256
        }

        // ---- Trigger toggles the sidebar (via clicked signal) ---------
        function test_trigger_toggle() {
            compare(sidebar.collapsed, false)
            trigger.clicked()
            compare(sidebar.collapsed, true)
            tryCompare(sidebar, "implicitWidth", sidebar.iconWidth)
            trigger.clicked()
            compare(sidebar.collapsed, false)
        }

        // ---- Trigger geometry: ghost IconButton at icon-sm (24px) -----
        function test_trigger_size() {
            compare(trigger.variant, IconButton.Ghost)
            compare(trigger.size, IconButton.Small)   // icon-sm = size-6 = 24
            compare(trigger.iconName, "panel-left")
            compare(trigger.implicitHeight, 24)
            compare(trigger.implicitWidth, 24)
        }

        // ---- Rail geometry: 16px strip wired to the sidebar -----------
        function test_rail() {
            compare(rail.implicitWidth, 16)   // w-4
            compare(rail.sidebar, sidebar)
            // The hover line is a 2px centre rectangle.
            let line = rail.children[0]
            compare(line.width, 2)
        }

        // ---- Header / footer zones ordering and padding ---------------
        function test_header_footer_zones() {
            let col = stackCol()
            compare(header.parent, col)
            compare(content.parent, col)
            compare(footer.parent, col)
            // Header at top, footer at bottom, content between.
            let hy = header.mapToItem(sidebar, 0, 0).y
            let cy = content.mapToItem(sidebar, 0, 0).y
            let fy = footer.mapToItem(sidebar, 0, 0).y
            verify(hy < cy)
            verify(cy < fy)
            // p-2 (8px) top + bottom around a 20px child -> 36px tall.
            compare(header.implicitHeight, headerChild.implicitHeight + 16)
            compare(footer.implicitHeight, footerChild.implicitHeight + 16)
            verify(header.Layout.fillWidth)
            verify(footer.Layout.fillWidth)
        }

        // ---- Group: label above menu, py-1 padding --------------------
        function test_group_layout() {
            let ly = groupLabel.mapToItem(group, 0, 0).y
            let my = menu.mapToItem(group, 0, 0).y
            verify(ly < my)
            // py-1 (4px) top + bottom is added to the inner content height.
            let innerCol = group.children[0]
            compare(group.implicitHeight, innerCol.implicitHeight + 8)
        }

        // ---- Menu list ordering and spacing ---------------------------
        function test_menu_layout() {
            compare(menu.spacing, 1)   // gap-px
            let y1 = menuBtn.mapToItem(menu, 0, 0).y
            let y2 = menuBtn2.mapToItem(menu, 0, 0).y
            verify(y1 < y2)
        }

        // ---- Menu button: h-8, radius, foreground colours ------------
        function test_menu_button_appearance() {
            compare(menuBtn.implicitHeight, 32)   // h-8
            let bg = menuBtn.children[0]           // accent Rectangle
            compare(bg.radius, Theme.radiusMd)     // calc(radius-sm + 2px) = 8
            // Active entry uses the accent foreground and paints the accent bg.
            compare(menuBtn.active, true)
            compare(menuBtn._fg, Theme.sidebarAccentForeground)
            compare(bg.color, Theme.sidebarAccent)
            // Inactive, un-hovered entry uses the plain sidebar foreground.
            compare(menuBtn2.active, false)
            compare(menuBtn2._fg, Theme.sidebarForeground)
        }

        // ---- Menu button expands to fit icon + label -----------------
        function test_menu_button_expanded_width() {
            // Not collapsed: width tracks the row content + p-2 (16px).
            compare(menuBtn.collapsed, false)
            let row = menuBtn.children[1]
            tryCompare(menuBtn, "implicitWidth", row.implicitWidth + 16)
        }

        // ---- Menu button clicked() signal fires -----------------------
        function test_menu_button_click() {
            let fired = 0
            menuBtn.clicked.connect(function() { fired++ })
            menuBtn.clicked()
            compare(fired, 1)
        }

        // ---- Collapsed: button becomes 32x32, label hidden -----------
        function test_menu_button_collapsed() {
            sidebar.collapsed = true
            tryCompare(menuBtn, "collapsed", true)
            tryCompare(menuBtn, "implicitWidth", 32)   // size-8!
            let row = menuBtn.children[1]
            let label = row.children[1]                // Text after the icon
            tryCompare(label, "visible", false)
            sidebar.collapsed = false
            tryCompare(menuBtn, "collapsed", false)
            tryCompare(label, "visible", true)
        }

        // ---- Group label: h-8 when expanded, collapses to 0 ----------
        function test_group_label() {
            compare(groupLabel.text, "Platform")
            compare(groupLabel.collapsed, false)
            compare(groupLabel.implicitHeight, 32)   // h-8
            compare(groupLabel.opacity, 1)
            sidebar.collapsed = true
            tryCompare(groupLabel, "collapsed", true)
            tryCompare(groupLabel, "implicitHeight", 0)   // -mt-8 collapse
            tryCompare(groupLabel, "opacity", 0)
            sidebar.collapsed = false
            tryCompare(groupLabel, "implicitHeight", 32)
            tryCompare(groupLabel, "opacity", 1)
        }

        // ---- Separator: 1px line, mx-2 (8px) inset each side ---------
        function test_separator() {
            compare(sep.implicitHeight, 1)
            let line = sep.children[0]
            compare(line.height, 1)
            compare(line.color, Theme.sidebarBorder)
            fuzzyCompare(line.mapToItem(sep, 0, 0).x, 8, 0.5)          // mx-2 left
            fuzzyCompare(sep.width - line.width, 16, 0.5)             // 8px each side
        }
    }
}
