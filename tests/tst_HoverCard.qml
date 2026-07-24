import QtQuick
import QtTest
import Shadcn

// HoverCard unit tests: locks the Side/Align enum values as a regression guard
// for issue #029 (inherited Item.TransformOrigin member-name collision would
// have silently shifted these), plus default property values, hover-driven
// open/close behaviour, and side/align positioning (asserted by reading the
// internal Popup's x/y). Open/close is exercised by driving the internal hover
// state directly, since the offscreen platform delivers no real pointer events.
// The Popup's positioner only applies x/y once it is open, so positioning
// assertions open the card first via openCard().
Item {
    id: root
    width: 600
    height: 600

    // Trigger for open/close behaviour; short delays keep the test fast.
    Item {
        id: trigger
        width: 120
        height: 40
        HoverCard {
            id: hc
            delay: 10
            closeDelay: 10
            cardWidth: 100
            Rectangle { width: hc.availableWidth; height: 40 }
        }
    }

    // Wide trigger for positioning; default side/align unless a test overrides.
    Item {
        id: posTrigger
        width: 300
        height: 50
        HoverCard {
            id: posCard
            delay: 10
            closeDelay: 10
            cardWidth: 100
            Rectangle { width: posCard.availableWidth; height: 30 }
        }
    }

    // Untouched card for asserting default property values.
    Item {
        id: defTrigger
        width: 80
        height: 30
        HoverCard {
            id: defCard
            Rectangle { width: 10; height: 10 }
        }
    }

    TestCase {
        id: testCase
        name: "HoverCard"
        when: windowShown

        // The internal Popup is attached to control.data; find it by the
        // properties only a Popup carries among the machinery items.
        function findPopup(card) {
            for (var i = 0; i < card.data.length; i++) {
                var o = card.data[i]
                if (o && o.closePolicy !== undefined && o.padding !== undefined
                        && o.contentWidth !== undefined)
                    return o
            }
            return null
        }

        // Drive the trigger hover state and wait until the card is open. The
        // Popup positioner only applies x/y once open.
        function openCard(card) {
            card._triggerHovered = true
            card._sync()
            tryVerify(function() { return card.opened }, 2000)
        }

        function cleanup() {
            hc._triggerHovered = false
            hc._contentHovered = false
            hc._sync()
            posCard._triggerHovered = false
            posCard._contentHovered = false
            posCard._sync()
            var ph = findPopup(hc)
            if (ph) ph.close()
            var pp = findPopup(posCard)
            if (pp) pp.close()
            // Restore positioning card to defaults.
            posCard.side = HoverCard.Side.BottomEdge
            posCard.align = HoverCard.Align.Middle
        }

        // ---- #029 regression guard: enum values must be sequential from 0 ----
        // If the inherited Item.TransformOrigin members leaked in, Top would be 1,
        // Center 4, etc. Renaming to *Edge / Middle keeps these correct.
        function test_enum_values_029() {
            compare(HoverCard.Side.TopEdge, 0)
            compare(HoverCard.Side.RightEdge, 1)
            compare(HoverCard.Side.BottomEdge, 2)
            compare(HoverCard.Side.LeftEdge, 3)
            compare(HoverCard.Align.Start, 0)
            compare(HoverCard.Align.Middle, 1)
            compare(HoverCard.Align.End, 2)
        }

        // ---- Default property values (untouched card) ----
        function test_defaults() {
            compare(defCard.side, HoverCard.Side.BottomEdge)
            compare(defCard.align, HoverCard.Align.Middle)
            compare(defCard.sideOffset, 4)
            compare(defCard.alignOffset, 4)
            compare(defCard.delay, 600)
            compare(defCard.closeDelay, 300)
            compare(defCard.cardWidth, 288)
            verify(!defCard.opened)
        }

        // ---- Hover-driven open then close ----
        function test_open_close() {
            verify(!hc.opened)
            hc._triggerHovered = true
            hc._sync()
            tryVerify(function() { return hc.opened }, 2000)
            hc._triggerHovered = false
            hc._sync()
            tryVerify(function() { return !hc.opened }, 2000)
        }

        // ---- Moving into the card keeps it open ----
        function test_content_hover_keeps_open() {
            hc._triggerHovered = true
            hc._sync()
            tryVerify(function() { return hc.opened }, 2000)
            // Pointer leaves trigger but enters card content.
            hc._contentHovered = true
            hc._triggerHovered = false
            hc._sync()
            wait(50)
            verify(hc.opened)
        }

        // ---- Bottom side, center align: below the trigger, horizontally centered ----
        function test_position_bottom_center() {
            var p = findPopup(posCard)
            verify(p !== null)
            posCard.side = HoverCard.Side.BottomEdge
            posCard.align = HoverCard.Align.Middle
            openCard(posCard)
            tryCompare(p, "x", (300 - 100) / 2)      // (triggerW - cardW) / 2 = 100
            tryCompare(p, "y", 50 + 4)               // triggerH + sideOffset = 54
        }

        // ---- Top side: above the trigger ----
        function test_position_top() {
            var p = findPopup(posCard)
            posCard.side = HoverCard.Side.TopEdge
            openCard(posCard)
            tryCompare(p, "y", -p.height - 4)        // -cardHeight - sideOffset
        }

        // ---- Left / Right sides ----
        function test_position_left_right() {
            var p = findPopup(posCard)
            openCard(posCard)
            posCard.side = HoverCard.Side.LeftEdge
            tryCompare(p, "x", -100 - 4)             // -cardW - sideOffset = -104
            posCard.side = HoverCard.Side.RightEdge
            tryCompare(p, "x", 300 + 4)              // triggerW + sideOffset = 304
        }

        // ---- Start / End align on a horizontal side apply alignOffset ----
        function test_align_start_end() {
            var p = findPopup(posCard)
            posCard.side = HoverCard.Side.BottomEdge
            openCard(posCard)
            posCard.align = HoverCard.Align.Start
            tryCompare(p, "x", 4)                    // alignOffset
            posCard.align = HoverCard.Align.End
            tryCompare(p, "x", 300 - 100 - 4)        // triggerW - cardW - alignOffset = 196
        }
    }
}
