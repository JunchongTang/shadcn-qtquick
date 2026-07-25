import QtQuick
import QtTest
import Shadcn

// Sheet unit tests: the Side enum's locked numeric values, default property
// values, the side -> edge mapping for all four sides, the _horizontal
// derivation, width/height sizing rules (horizontal = min(3/4 window, 384) width
// and full height; vertical = full width and content-capped height), the inner
// border geometry per side, header/footer wiring, and open()/close() visibility.
// Being a modal popup, only what is assertable without real user interaction is
// covered.
//
// ENUM GOTCHA (see docs/issues #028/#029): Sheet derives from Drawer (Popup
// family), which carries NO Item.TransformOrigin enum, so its Side members do not
// collide with an inherited enum, and Side is the sole enum declared in the file
// so there is no in-file flattening clash. test_side_enum_values locks the raw
// integers so a future reorder or accidental collision is caught.
//
// NOTE: a QtQuick.Controls Drawer auto-reparents to the *window overlay*, not to
// the Item it is declared in, so _winW/_winH is the window size for every sheet
// regardless of nesting. Sizing expectations are written against the component's
// own resolved _winW/_winH rather than hardcoded pixels, keeping them
// deterministic under the offscreen platform whatever the window size.
Item {
    id: root
    width: 500
    height: 600

    // Default (right) sheet with header + footer wiring.
    Sheet {
        id: rightSheet
        title: "Edit profile"
        description: "Make changes to your profile here."
        footer: footerItem
    }

    Item {
        id: footerItem
        implicitHeight: 40
    }

    // One sheet per side to check the edge mapping / _horizontal / sizing / border.
    Sheet { id: topSheet; side: Sheet.TopEdge }
    Sheet { id: bottomSheet; side: Sheet.BottomEdge }
    Sheet { id: leftSheet; side: Sheet.LeftEdge }

    TestCase {
        id: testCase
        name: "Sheet"
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
            rightSheet.close()
            topSheet.close()
            bottomSheet.close()
            leftSheet.close()
        }

        function cleanup() {
            rightSheet.close()
            topSheet.close()
            bottomSheet.close()
            leftSheet.close()
        }

        // ---- Side enum values are locked (guards against reorder / collision) ----
        function test_side_enum_values() {
            compare(Sheet.TopEdge, 0)
            compare(Sheet.RightEdge, 1)
            compare(Sheet.BottomEdge, 2)
            compare(Sheet.LeftEdge, 3)
        }

        // ---- Defaults ----
        function test_defaults() {
            // Default side is checked on `rightSheet` which is left unset.
            compare(rightSheet.side, Sheet.RightEdge)
            compare(topSheet.showCloseButton, true)
            verify(rightSheet.modal)
            compare(rightSheet.padding, 0)
            compare(rightSheet.dragMargin, 0)
            compare(topSheet.title, "")
            compare(topSheet.description, "")
            compare(topSheet.footer, null)
        }

        function test_default_side_is_right() {
            // `rightSheet` never assigns side, so it must default to Sheet.RightEdge.
            compare(rightSheet.side, Sheet.RightEdge)
        }

        // ---- side -> edge mapping ----
        function test_edge_mapping() {
            compare(topSheet.edge, Qt.TopEdge)
            compare(rightSheet.edge, Qt.RightEdge)
            compare(bottomSheet.edge, Qt.BottomEdge)
            compare(leftSheet.edge, Qt.LeftEdge)
        }

        // ---- _horizontal derivation ----
        function test_horizontal_flag() {
            verify(rightSheet._horizontal)
            verify(leftSheet._horizontal)
            verify(!topSheet._horizontal)
            verify(!bottomSheet._horizontal)
        }

        // ---- Window overlay resolves (shared across sheets) ----
        function test_window_resolves() {
            verify(rightSheet._winW > 0)
            verify(rightSheet._winH > 0)
            compare(topSheet._winW, rightSheet._winW)
            compare(topSheet._winH, rightSheet._winH)
            compare(leftSheet._winW, rightSheet._winW)
            compare(leftSheet._winH, rightSheet._winH)
        }

        // ---- Horizontal sizing: min(3/4 window, 384) width, full height ----
        function test_horizontal_sizing() {
            compare(rightSheet.width, Math.min(rightSheet._winW * 0.75, 384))
            compare(leftSheet.width, Math.min(leftSheet._winW * 0.75, 384))
            // Never wider than the max-w-sm cap.
            verify(rightSheet.width <= 384)
            // Full window height.
            compare(rightSheet.height, rightSheet._winH)
            compare(leftSheet.height, leftSheet._winH)
        }

        // ---- Vertical sizing: full width, content-capped height ----
        function test_vertical_sizing() {
            compare(topSheet.width, topSheet._winW)
            compare(bottomSheet.width, bottomSheet._winW)
            // Height never exceeds the window height.
            verify(topSheet.height <= topSheet._winH)
            verify(bottomSheet.height <= bottomSheet._winH)
        }

        // ---- Inner border geometry follows the entry edge ----
        function test_border_geometry() {
            // The background's single child Rectangle is the inner border.
            function borderOf(sheet) {
                var bg = sheet.background
                for (var i = 0; i < bg.children.length; i++) {
                    var c = bg.children[i]
                    if (c.hasOwnProperty("color") && c.hasOwnProperty("x") && c.hasOwnProperty("y"))
                        return c
                }
                return null
            }
            var rb = borderOf(rightSheet)   // right -> left edge (x = 0), vertical strip
            verify(rb !== null)
            compare(rb.width, 1)
            compare(rb.x, 0)
            var lb = borderOf(leftSheet)    // left -> right edge (x = width - 1)
            verify(lb !== null)
            compare(lb.width, 1)
            compare(lb.x, leftSheet.background.width - 1)
            var tb = borderOf(topSheet)     // top -> bottom edge (y = height - 1), horizontal strip
            verify(tb !== null)
            compare(tb.height, 1)
            compare(tb.y, topSheet.background.height - 1)
            var bb = borderOf(bottomSheet)  // bottom -> top edge (y = 0)
            verify(bb !== null)
            compare(bb.height, 1)
            compare(bb.y, 0)
        }

        // ---- Footer reparented into the sheet body ----
        function test_footer_wiring() {
            // onFooterChanged moves the footer out of `root` into the footer layout.
            verify(rightSheet.footer === footerItem)
            verify(footerItem.parent !== null)
            verify(footerItem.parent !== root)
        }

        // ---- Header text wiring ----
        function test_header_wiring() {
            rightSheet.open()
            tryCompare(rightSheet, "visible", true)
            var title = findText(rightSheet.contentItem, rightSheet.title)
            var desc = findText(rightSheet.contentItem, rightSheet.description)
            verify(title !== null)
            verify(desc !== null)
            compare(title.color, Theme.foreground)
            compare(desc.color, Theme.mutedForeground)
        }

        // ---- open()/close() drive visibility ----
        function test_open_close() {
            // A Drawer is a Popup whose visibility settles through the exit
            // transition, so let any pending close from init()/a prior test
            // settle before asserting the closed state (tryCompare, not compare).
            tryCompare(rightSheet, "visible", false)
            rightSheet.open()
            tryCompare(rightSheet, "visible", true)
            rightSheet.close()
            tryCompare(rightSheet, "visible", false)
        }
    }
}
