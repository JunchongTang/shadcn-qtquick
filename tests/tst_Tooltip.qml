import QtQuick
import QtTest
import Shadcn

// Tooltip unit tests: locks the Side and Align enum values as a regression guard
// for issue #029, verifies default property values, per-side x/y positioning,
// align/alignOffset, and the arrow's anchor-tracking + corner clamp.
//
// Tooltip derives from ToolTip (the Popup family). Even though a Popup is not an
// Item, the inherited Item.TransformOrigin members still flatten into the type's
// enum scope: a naive Side { Top, Right, Bottom, Left } was shadowed so that
// Tooltip.Top resolved to 1 (TransformOrigin.Top) instead of 0. Renaming the
// members to *Edge restores the intended 0..3, which test_enum_values_029 guards.
// The same trap catches Center (TransformOrigin value 4), which is why Align
// uses Start/Middle/End -- test_align_enum_values guards that.
//
// The surface + arrow are traced as a single Canvas path (not a discrete arrow
// child Item) so the fade/zoom transition never desyncs the two into a visibly
// split diamond (see Tooltip.qml's class docs); arrow position is asserted via
// the control's own arrowCenterX/Y rather than reaching into the background.
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

    // Wide trigger + a short-text (narrow) tooltip, align Start: the trigger's
    // centre in the bubble's local coordinates falls far past the bubble's own
    // right edge, forcing arrowCenterX to clamp against arrowPadding instead of
    // tracking the (out-of-range) anchor.
    Item {
        id: clampTrigger
        x: 10
        y: 300
        width: 300
        height: 30
        Tooltip {
            id: clampTip
            text: "Hi"
            timeout: 60000
            side: Tooltip.Side.TopEdge
            align: Tooltip.Align.Start
        }
    }

    TestCase {
        id: testCase
        name: "Tooltip"
        when: windowShown

        function cleanup() {
            posTip.close()
            defTip.close()
            clampTip.close()
            posTip.side = Tooltip.Side.TopEdge
            posTip.align = Tooltip.Align.Middle
            posTip.alignOffset = 0
        }

        function openTip(tip) {
            tip.open()
            tryVerify(function() { return tip.opened }, 2000)
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

        // ---- #029 regression guard, Align: Center would collide with the
        // inherited Item.TransformOrigin.Center (value 4); Start/Middle/End
        // must stay sequential from 0. ----
        function test_align_enum_values() {
            compare(Tooltip.Align.Start, 0)
            compare(Tooltip.Align.Middle, 1)
            compare(Tooltip.Align.End, 2)
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

        // ---- Surface: inverted foreground fill, rounded-md corners (Canvas
        // mirror properties, since the pill+arrow are one traced path, not a
        // styleable Rectangle) ----
        function test_surface_style() {
            var bg = posTip.background
            verify(bg !== null)
            compare(bg.fillColor, Theme.foreground)
            compare(bg.cornerRadius, Theme.radiusMd)
        }

        // ---- Arrow: 10px notch, defaults to Theme.radiusMd padding from the
        // rounded corners ----
        function test_arrow_defaults() {
            compare(defTip.arrowSize, Theme.space2_5)   // size-2.5 = 10
            compare(defTip.arrowPadding, Theme.radiusMd)
        }

        // ---- Arrow half-width/poke-out depth: base-mira's diamond sits 2px
        // off-centre (translate-y-[calc(-50%-2px)]), not bisected through its
        // middle, so this is arrowSize/sqrt(2) - 2, not arrowSize/2. ----
        function test_arrow_half_width() {
            fuzzyCompare(defTip.arrowHalfWidth, Theme.space2_5 / Math.SQRT2 - 2, 0.01)
        }

        // ---- Arrow centres on the trigger by default (align Middle): on
        // TopEdge/BottomEdge that means the box's own horizontal centre ----
        function test_arrow_position_top() {
            posTip.side = Tooltip.Side.TopEdge
            openTip(posTip)
            fuzzyCompare(posTip.arrowCenterX, posTip.width / 2, 0.6)
        }

        // ---- Align Start: bubble's leading edge flush with the trigger's ----
        function test_align_start() {
            posTip.side = Tooltip.Side.TopEdge
            posTip.align = Tooltip.Align.Start
            openTip(posTip)
            fuzzyCompare(posTip.x, 0, 0.6)
        }

        // ---- Align End: bubble's trailing edge flush with the trigger's ----
        function test_align_end() {
            posTip.side = Tooltip.Side.TopEdge
            posTip.align = Tooltip.Align.End
            openTip(posTip)
            fuzzyCompare(posTip.x, 100 - posTip.width, 0.6)
        }

        // ---- alignOffset nudges along the cross axis on top of align ----
        function test_align_offset() {
            posTip.side = Tooltip.Side.TopEdge
            posTip.alignOffset = 10
            openTip(posTip)
            fuzzyCompare(posTip.x, (100 - posTip.width) / 2 + 10, 0.6)
        }

        // ---- Arrow tracks the trigger's centre (Radix Popper arrow()
        // middleware model): with align Start the bubble's own centre moves
        // away from the trigger, but the arrow should still point at the
        // trigger's actual centre (half its 100px width) converted into the
        // bubble's local coordinates, not the bubble's own midpoint. ----
        function test_arrow_tracks_anchor_with_align() {
            posTip.side = Tooltip.Side.TopEdge
            posTip.align = Tooltip.Align.Start
            openTip(posTip)
            fuzzyCompare(posTip.arrowCenterX, 50, 0.6)
        }

        // ---- Arrow never slides into a rounded corner: a wide trigger with a
        // narrow (short-text) tooltip pushes the desired anchor position past
        // the bubble's own edge, so arrowCenterX clamps to arrowPadding
        // instead of following it out of bounds. ----
        function test_arrow_padding_clamp() {
            openTip(clampTip)
            var upperBound = clampTip.width - clampTip.arrowPadding - clampTip.arrowHalfWidth
            fuzzyCompare(clampTip.arrowCenterX, upperBound, 0.6)
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
