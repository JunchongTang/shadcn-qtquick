import QtQuick
import QtTest
import Shadcn

// Drawer unit tests: default property values, the side -> edge mapping for all
// four sides, the _vertical derivation, width/height sizing rules (vertical =
// full viewport width; horizontal = min(24rem, viewport) width and full height),
// rounded-corner selection, title/description/footer wiring, and open()/close()
// visibility. Being a modal popup, only what is assertable without real user
// interaction is covered.
//
// NOTE: a QtQuick.Controls Drawer auto-reparents to the *window overlay*, not to
// the Item it is declared in, so _viewportW/H is the window size for every drawer
// regardless of nesting. Sizing expectations are therefore written against the
// component's own resolved _viewportW/H rather than hardcoded pixel values, which
// keeps them deterministic under the offscreen platform whatever the window size.
Item {
    id: root
    width: 500
    height: 600

    // Default (bottom) drawer with header + footer wiring.
    Drawer {
        id: bottom
        title: "Move Goal"
        description: "Set your daily activity goal."
        footer: footerItem
    }

    Item {
        id: footerItem
        implicitHeight: 40
    }

    // One drawer per side to check the edge mapping / _vertical / sizing.
    Drawer { id: topDrawer; side: "top" }
    Drawer { id: leftDrawer; side: "left" }
    Drawer { id: rightDrawer; side: "right" }

    TestCase {
        id: testCase
        name: "Drawer"
        when: windowShown

        // Recursive lookup of a visible Text whose text matches the given string.
        function findText(item, str) {
            if (!item)
                return null
            for (var i = 0; i < item.children.length; i++) {
                var c = item.children[i]
                if (c.hasOwnProperty("visible") && c.visible === false)
                    continue
                if (c.hasOwnProperty("text") && c.text === str && c.hasOwnProperty("wrapMode"))
                    return c
                var f = findText(c, str)
                if (f)
                    return f
            }
            return null
        }

        function init() {
            bottom.close()
            topDrawer.close()
            leftDrawer.close()
            rightDrawer.close()
        }

        function cleanup() {
            bottom.close()
            topDrawer.close()
            leftDrawer.close()
            rightDrawer.close()
        }

        // ---- Defaults ----
        function test_defaults() {
            // side default is checked on `bottom` which is left unset.
            compare(rightDrawer.side, "right")
            compare(bottom.showHandle, true)
            verify(bottom.modal)
            compare(bottom.padding, 0)
            compare(rightDrawer.title, "")
            compare(rightDrawer.description, "")
            compare(rightDrawer.footer, null)
        }

        function test_default_side_is_bottom() {
            // `bottom` never assigns side, so it must default to "bottom".
            compare(bottom.side, "bottom")
        }

        // ---- side -> edge mapping ----
        function test_edge_mapping() {
            compare(bottom.edge, Qt.BottomEdge)
            compare(topDrawer.edge, Qt.TopEdge)
            compare(leftDrawer.edge, Qt.LeftEdge)
            compare(rightDrawer.edge, Qt.RightEdge)
        }

        function test_edge_fallback_for_unknown_side() {
            // Any unrecognised side falls through to Qt.BottomEdge.
            topDrawer.side = "nonsense"
            compare(topDrawer.edge, Qt.BottomEdge)
            topDrawer.side = "top"
            compare(topDrawer.edge, Qt.TopEdge)
        }

        // ---- _vertical derivation ----
        function test_vertical_flag() {
            verify(bottom._vertical)
            verify(topDrawer._vertical)
            verify(!leftDrawer._vertical)
            verify(!rightDrawer._vertical)
        }

        // ---- Viewport resolves (to the shared window overlay, not the Item) ----
        function test_viewport_resolves() {
            // A Drawer parents to the window overlay, so the viewport is positive
            // (the parent-null fallback is not hit) ...
            verify(bottom._viewportW > 0)
            verify(bottom._viewportH > 0)
            // ... and identical for every drawer regardless of where it is declared.
            compare(topDrawer._viewportW, bottom._viewportW)
            compare(topDrawer._viewportH, bottom._viewportH)
            compare(rightDrawer._viewportW, bottom._viewportW)
            compare(rightDrawer._viewportH, bottom._viewportH)
        }

        // ---- Vertical sizing: full width, height capped at viewport - 6rem ----
        function test_vertical_sizing() {
            compare(bottom.width, bottom._viewportW)
            compare(topDrawer.width, topDrawer._viewportW)
            // Height never exceeds the viewport minus 6rem (96px).
            verify(bottom.height <= bottom._viewportH - 96)
        }

        // ---- Horizontal sizing: 24rem width (capped to viewport), full height ----
        function test_horizontal_sizing() {
            // Width is the 24rem (384) fixed value, clamped to the viewport width.
            compare(rightDrawer.width, Math.min(384, rightDrawer._viewportW))
            compare(leftDrawer.width, Math.min(384, leftDrawer._viewportW))
            // Make the branch concrete: a viewport >= 24rem yields the fixed 384,
            // otherwise it is clamped to the viewport width.
            if (rightDrawer._viewportW >= 384)
                compare(rightDrawer.width, 384)
            else
                compare(rightDrawer.width, rightDrawer._viewportW)
            // Horizontal drawers span the full viewport height.
            compare(rightDrawer.height, rightDrawer._viewportH)
            compare(leftDrawer.height, leftDrawer._viewportH)
        }

        // ---- Rounded-corner selection follows the entry edge ----
        function test_corner_radii() {
            // Bottom drawer: only the top corners (facing into the viewport) round.
            compare(bottom.background.topLeftRadius, Theme.radiusXl)
            compare(bottom.background.topRightRadius, Theme.radiusXl)
            compare(bottom.background.bottomLeftRadius, 0)
            compare(bottom.background.bottomRightRadius, 0)
            // Right drawer: only the left corners round.
            compare(rightDrawer.background.topLeftRadius, Theme.radiusXl)
            compare(rightDrawer.background.bottomLeftRadius, Theme.radiusXl)
            compare(rightDrawer.background.topRightRadius, 0)
            compare(rightDrawer.background.bottomRightRadius, 0)
        }

        // ---- Footer reparented into the drawer body ----
        function test_footer_wiring() {
            // onFooterChanged moves the footer out of `root` into the footer holder.
            verify(bottom.footer === footerItem)
            verify(footerItem.parent !== null)
            verify(footerItem.parent !== root)
        }

        // ---- Header text wiring + alignment (vertical => centered) ----
        function test_header_wiring() {
            bottom.open()
            tryCompare(bottom, "visible", true)
            var title = findText(bottom.contentItem, bottom.title)
            var desc = findText(bottom.contentItem, bottom.description)
            verify(title !== null)
            verify(desc !== null)
            // Vertical drawer centers its header text.
            compare(title.horizontalAlignment, Text.AlignHCenter)
            compare(desc.horizontalAlignment, Text.AlignHCenter)
            compare(title.color, Theme.foreground)
            compare(desc.color, Theme.mutedForeground)
        }

        // ---- Horizontal header is left-aligned ----
        function test_horizontal_header_alignment() {
            rightDrawer.title = "Left aligned"
            rightDrawer.open()
            tryCompare(rightDrawer, "visible", true)
            var title = findText(rightDrawer.contentItem, "Left aligned")
            verify(title !== null)
            compare(title.horizontalAlignment, Text.AlignLeft)
            rightDrawer.close()
            rightDrawer.title = ""
        }

        // ---- open()/close() drive visibility ----
        function test_open_close() {
            compare(bottom.visible, false)
            bottom.open()
            tryCompare(bottom, "visible", true)
            bottom.close()
            tryCompare(bottom, "visible", false)
        }
    }
}
