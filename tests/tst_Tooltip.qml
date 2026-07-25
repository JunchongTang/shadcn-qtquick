import QtQuick
import QtTest
import Shadcn

// Tooltip unit tests: locks the Side enum values (0/1/2/3) as a regression guard
// for issue #029, verifies default property values, per-side x/y positioning,
// and the surface + arrow styling.
//
// Tooltip derives from ToolTip (the Popup family). Even though a Popup is not an
// Item, the inherited Item.TransformOrigin members still flatten into the type's
// enum scope: a naive Side { Top, Right, Bottom, Left } was shadowed so that
// Tooltip.Top resolved to 1 (TransformOrigin.Top) instead of 0. Renaming the
// members to *Edge restores the intended 0..3, which test_enum_values_029 guards.
//
// The offscreen test platform delivers no real pointer events, so the tooltip is
// shown directly via open(); the enter transition means opened turns true
// asynchronously, hence tryVerify. A closed Popup does not apply its positioner,
// so positioning assertions open() the tooltip first. timeout is pinned so the
// bubble does not auto-hide mid-assertion.
Item {
    id: root
    width: 400
    height: 400

    // Trigger used for positioning; side is switched per test. Placed well inside
    // root so every side has room -- a Popup clamps to the overlay bounds, which
    // would otherwise shift a Top/Left bubble off its computed position.
    Item {
        id: posTrigger
        x: 150
        y: 150
        width: 100
        height: 40
        Tooltip {
            id: posTip
            text: "Add to library"
            timeout: 60000
            side: Tooltip.Side.TopEdge
        }
    }

    // Untouched tooltip for asserting default property values.
    Item {
        id: defTrigger
        width: 80
        height: 30
        Tooltip {
            id: defTip
            text: "Add to library"
        }
    }

    TestCase {
        id: testCase
        name: "Tooltip"
        when: windowShown

        function cleanup() {
            posTip.close()
            defTip.close()
            posTip.side = Tooltip.Side.TopEdge
        }

        function openTip(tip) {
            tip.open()
            tryVerify(function() { return tip.opened }, 2000)
        }

        // Locate the diamond arrow among the background's visual children.
        function findArrow(tip) {
            var bg = tip.background
            for (var i = 0; i < bg.children.length; i++) {
                if (bg.children[i].objectName === "tooltipArrow")
                    return bg.children[i]
            }
            return null
        }

        // ---- #029 regression guard: Side values must be sequential from 0 ----
        // If the inherited Item.TransformOrigin members leaked in, TopEdge's old
        // name Top would be 1, Right 5, Bottom 7, Left 3. Naming them *Edge keeps
        // these at 0/1/2/3.
        function test_enum_values_029() {
            compare(Tooltip.Side.TopEdge, 0)
            compare(Tooltip.Side.RightEdge, 1)
            compare(Tooltip.Side.BottomEdge, 2)
            compare(Tooltip.Side.LeftEdge, 3)
        }

        // ---- Default property values (untouched tooltip) ----
        function test_defaults() {
            compare(defTip.side, Tooltip.Side.TopEdge)
            compare(defTip.sideOffset, Theme.space1_5)   // 6
            compare(defTip.delay, 300)
            compare(defTip.kbd, "")
            compare(defTip.font.pixelSize, Theme.textXs)
            verify(!defTip.opened)
        }

        // ---- Top side: centered horizontally, above the trigger ----
        function test_position_top() {
            posTip.side = Tooltip.Side.TopEdge
            openTip(posTip)
            fuzzyCompare(posTip.x, (100 - posTip.width) / 2, 0.6)
            fuzzyCompare(posTip.y, -posTip.height - posTip.sideOffset, 0.6)
        }

        // ---- Bottom side: centered horizontally, below the trigger ----
        function test_position_bottom() {
            posTip.side = Tooltip.Side.BottomEdge
            openTip(posTip)
            fuzzyCompare(posTip.x, (100 - posTip.width) / 2, 0.6)
            fuzzyCompare(posTip.y, 40 + posTip.sideOffset, 0.6)  // triggerH + offset
        }

        // ---- Left side: to the left, centered vertically ----
        function test_position_left() {
            posTip.side = Tooltip.Side.LeftEdge
            openTip(posTip)
            fuzzyCompare(posTip.x, -posTip.width - posTip.sideOffset, 0.6)
            fuzzyCompare(posTip.y, (40 - posTip.height) / 2, 0.6)
        }

        // ---- Right side: to the right, centered vertically ----
        function test_position_right() {
            posTip.side = Tooltip.Side.RightEdge
            openTip(posTip)
            fuzzyCompare(posTip.x, 100 + posTip.sideOffset, 0.6)  // triggerW + offset
            fuzzyCompare(posTip.y, (40 - posTip.height) / 2, 0.6)
        }

        // ---- Surface: inverted foreground fill, rounded-md corners ----
        function test_surface_style() {
            var bg = posTip.background
            verify(bg !== null)
            compare(bg.color, Theme.foreground)
            compare(bg.radius, Theme.radiusMd)
        }

        // ---- Arrow: 10px diamond, foreground-coloured, centered on the edge ----
        function test_arrow_style() {
            openTip(posTip)
            var arrow = findArrow(posTip)
            verify(arrow !== null)
            compare(arrow.width, Theme.space2_5)   // size-2.5 = 10
            compare(arrow.height, Theme.space2_5)
            compare(arrow.rotation, 45)
            compare(arrow.color, Theme.foreground)
        }

        // ---- Arrow follows the side: on TopEdge it sits at the bottom edge ----
        function test_arrow_position_top() {
            posTip.side = Tooltip.Side.TopEdge
            openTip(posTip)
            var arrow = findArrow(posTip)
            var bg = posTip.background
            fuzzyCompare(arrow.x, (bg.width - arrow.width) / 2, 0.6)
            fuzzyCompare(arrow.y, bg.height - arrow.height / 2, 0.6)
        }

        // ---- Kbd padding: right padding tightens when a shortcut is set ----
        function test_kbd_padding() {
            compare(defTip.rightPadding, Theme.space3)   // no kbd -> px-3
            defTip.kbd = "S"
            compare(defTip.rightPadding, Theme.space1_5) // has kbd -> pr-1.5
            defTip.kbd = ""
        }
    }
}
