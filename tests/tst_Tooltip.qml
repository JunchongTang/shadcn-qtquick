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

    // Flush against the top of the window: a TopEdge bubble has nowhere to go but down.
    Item {
        id: topTrigger
        x: 150
        y: 0
        width: 100
        height: 40
        Tooltip {
            id: topTip
            text: "Add to library"
            timeout: 60000
            side: Tooltip.Side.TopEdge
        }
    }

    // Flush against the right of the window, for the same case on the other axis.
    Item {
        id: rightTrigger
        x: 380
        y: 150
        width: 20
        height: 40
        Tooltip {
            id: rightTip
            text: "Add to library"
            timeout: 60000
            side: Tooltip.Side.RightEdge
        }
    }

    // A narrow control in the top-right corner, like the last button in a title bar: the
    // bubble above it is centred on it and so overruns the window, and has to slide along
    // its edge to stay inside. Moved into place by the tests, which know the bubble's width.
    Item {
        id: cornerTrigger
        x: 200
        y: 120
        width: 24
        height: 24
        Tooltip {
            id: cornerTip
            text: "Add to library"
            timeout: 60000
            side: Tooltip.Side.TopEdge
        }
    }

    TestCase {
        id: testCase
        name: "Tooltip"
        when: windowShown

        function cleanup() {
            posTip.close()
            defTip.close()
            topTip.close()
            rightTip.close()
            cornerTip.close()
            posTip.side = Tooltip.Side.TopEdge
            cornerTrigger.x = 200
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

        // ---- Flip: no room on the requested edge moves the bubble to the opposite one ----
        // A trigger at the top of the window cannot carry a bubble above it. Qt's positioner
        // flips the bubble there on its own, but it does not know about the arrow, which is
        // this component's; before effectiveSide existed the bubble hung below the trigger
        // with the arrow still on its underside, pointing at nothing.
        function test_flip_vertical_when_no_room() {
            openTip(topTip)
            compare(topTip.side, Tooltip.Side.TopEdge)              // the request is unchanged
            compare(topTip.effectiveSide, Tooltip.Side.BottomEdge)  // ... and honoured downward
            fuzzyCompare(topTip.y, 40 + topTip.sideOffset, 0.6)     // triggerH + offset

            // The arrow moved with it: on BottomEdge it straddles the top edge, pointing up.
            var arrow = findArrow(topTip)
            fuzzyCompare(arrow.y, -arrow.height / 2, 0.6)
            fuzzyCompare(arrow.x, (topTip.background.width - arrow.width) / 2, 0.6)
        }

        function test_flip_horizontal_when_no_room() {
            openTip(rightTip)
            compare(rightTip.effectiveSide, Tooltip.Side.LeftEdge)
            fuzzyCompare(rightTip.x, -rightTip.width - rightTip.sideOffset, 0.6)

            var arrow = findArrow(rightTip)
            fuzzyCompare(arrow.x, rightTip.background.width - arrow.width / 2, 0.6)
        }

        // ---- Shift: a bubble that would overrun the window slides along its edge, and the
        //      arrow slides back so it still points at the trigger ----
        // The corner case the flip does not cover. A bubble is centred on its trigger, so a
        // narrow control near the right edge carries one that hangs over it; Qt pushes it
        // back inside on its own and leaves the arrow in the middle of a bubble that is no
        // longer in the middle of anything.
        function test_shift_keeps_the_arrow_on_the_trigger() {
            openTip(cornerTip)  // opened first: the amount to overrun by depends on its width

            // Positioned so the centred bubble would overrun the right edge by exactly 10 --
            // enough to be pushed back, little enough that the arrow can follow the whole way.
            const overrun = 10
            cornerTrigger.x = 400 - cornerTip.margins + overrun
                    - cornerTrigger.width / 2 - cornerTip.width / 2
            cornerTip.updatePlacement()   // a trigger that moves under a bubble has to say so

            compare(cornerTip.effectiveSide, Tooltip.Side.TopEdge)  // room above: no flip
            fuzzyCompare(cornerTip.shift, -overrun, 0.6)

            // Inside the window by the padding, and no further in than that.
            fuzzyCompare(cornerTrigger.x + cornerTip.x + cornerTip.width,
                         400 - cornerTip.margins, 0.6)

            // The point of all of it: the arrow is over the middle of the trigger.
            var arrow = findArrow(cornerTip)
            const arrowCentre = cornerTrigger.x + cornerTip.x + arrow.x + arrow.width / 2
            fuzzyCompare(arrowCentre, cornerTrigger.x + cornerTrigger.width / 2, 0.6)
        }

        // ---- The same at the other end, where the nudge and the slide both change sign ----
        function test_shift_at_the_leading_edge() {
            openTip(cornerTip)
            const overrun = 10
            cornerTrigger.x = cornerTip.margins - overrun
                    - cornerTrigger.width / 2 + cornerTip.width / 2
            cornerTip.updatePlacement()

            fuzzyCompare(cornerTip.shift, overrun, 0.6)   // pushed right, not further left
            fuzzyCompare(cornerTrigger.x + cornerTip.x, cornerTip.margins, 0.6)

            var arrow = findArrow(cornerTip)
            const arrowCentre = cornerTrigger.x + cornerTip.x + arrow.x + arrow.width / 2
            fuzzyCompare(arrowCentre, cornerTrigger.x + cornerTrigger.width / 2, 0.6)
        }

        // ---- The slide stops at the corners, where a diamond has nothing flat to sit on ----
        function test_arrow_stays_off_the_rounded_corner() {
            openTip(cornerTip)
            // Hard against the edge: the bubble is pushed much further than the arrow can
            // follow, so the arrow should stop rather than ride out over the corner.
            cornerTrigger.x = 400 - cornerTrigger.width
            cornerTip.updatePlacement()

            var arrow = findArrow(cornerTip)
            var bg = cornerTip.background
            verify(cornerTip.shift < -20)   // the bubble really did move a long way
            // The diamond's own half-diagonal plus the corner radius, measured from the far
            // edge of the bubble: past this it would overlap the rounded corner.
            const reach = arrow.x + arrow.width / 2 + arrow.width * Math.SQRT2 / 2
            verify(reach <= bg.width - bg.radius + 0.6)
            verify(arrow.x > (bg.width - arrow.width) / 2)   // ... but it did slide
        }

        // ---- No flip when the requested edge has room: side is not a suggestion ----
        function test_no_flip_when_room() {
            posTip.side = Tooltip.Side.TopEdge
            openTip(posTip)
            compare(posTip.effectiveSide, Tooltip.Side.TopEdge)
            compare(defTip.effectiveSide, defTip.side)   // never opened: still the request
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
