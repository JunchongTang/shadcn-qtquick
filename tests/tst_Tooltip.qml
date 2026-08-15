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
            clampTip.close()
            topTip.close()
            rightTip.close()
            cornerTip.close()
            posTip.side = Tooltip.Side.TopEdge
            posTip.align = Tooltip.Align.Middle
            posTip.alignOffset = 0
            cornerTrigger.x = 200
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

        // ---- Flip: a bubble with no room on the requested edge moves to the opposite one,
        //      and the notch moves with it ----
        // Qt's positioner would flip the bubble on its own, but it moves the bubble alone:
        // the notch is traced by the component from the side it believes it is on, and a
        // tooltip on a trigger at the top of a window ended up below it with the notch still
        // cut into its bottom edge, pointing away at nothing.
        function test_flip_vertical_when_no_room() {
            openTip(topTip)
            compare(topTip.side, Tooltip.Side.TopEdge)              // the request is unchanged
            compare(topTip.effectiveSide, Tooltip.Side.BottomEdge)  // ... and honoured downward
            fuzzyCompare(topTip.y, 40 + topTip.sideOffset, 0.6)     // triggerH + offset

            // Still over the middle of the trigger, which is what the notch is cut at. The
            // canvas reads effectiveSide, so on BottomEdge it is cut into the top edge.
            fuzzyCompare(topTip.arrowCenterX, topTip.width / 2, 0.6)
            compare(topTip.background.side, Tooltip.Side.BottomEdge)
        }

        function test_flip_horizontal_when_no_room() {
            openTip(rightTip)
            compare(rightTip.effectiveSide, Tooltip.Side.LeftEdge)
            fuzzyCompare(rightTip.x, -rightTip.width - rightTip.sideOffset, 0.6)
            fuzzyCompare(rightTip.arrowCenterY, rightTip.height / 2, 0.6)
            compare(rightTip.background.side, Tooltip.Side.LeftEdge)
        }

        // ---- A bubble the positioner pushes back inside the window keeps its notch on the
        //      trigger, without this component computing the nudge itself ----
        // The other half of the collision problem, and the half Qt already handles: a bubble
        // is centred on its trigger, so a narrow control near the right edge carries one that
        // hangs over the window. The positioner slides it back and writes the corrected
        // position to Popup.x -- which is what arrowCenterX is measured from, so the notch
        // travels with it. Locked down here because that dependency is invisible in either
        // file on its own: it lives between the positioner and arrowCenterX.
        function test_positioner_shift_keeps_the_arrow_on_the_trigger() {
            openTip(cornerTip)  // opened first: the amount to overrun by depends on its width

            // Positioned so the centred bubble would overrun the right edge by exactly 10 --
            // enough to be pushed back, little enough that the notch can follow the whole way.
            const overrun = 10
            cornerTrigger.x = 400 - cornerTip.margins + overrun
                    - cornerTrigger.width / 2 - cornerTip.width / 2

            compare(cornerTip.effectiveSide, Tooltip.Side.TopEdge)  // room above: no flip
            // Inside the window by the padding, and no further in than that.
            fuzzyCompare(cornerTrigger.x + cornerTip.x + cornerTip.width,
                         400 - cornerTip.margins, 0.6)
            // The point of it: the notch is over the middle of the trigger.
            fuzzyCompare(cornerTrigger.x + cornerTip.x + cornerTip.arrowCenterX,
                         cornerTrigger.x + cornerTrigger.width / 2, 0.6)
        }

        // ---- The same at the other end, where the slide changes sign ----
        function test_positioner_shift_at_the_leading_edge() {
            openTip(cornerTip)
            const overrun = 10
            cornerTrigger.x = cornerTip.margins - overrun
                    - cornerTrigger.width / 2 + cornerTip.width / 2

            fuzzyCompare(cornerTrigger.x + cornerTip.x, cornerTip.margins, 0.6)
            fuzzyCompare(cornerTrigger.x + cornerTip.x + cornerTip.arrowCenterX,
                         cornerTrigger.x + cornerTrigger.width / 2, 0.6)
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
