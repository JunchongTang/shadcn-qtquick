import QtQuick
import QtTest
import Shadcn

// Popover unit tests: locks the Align enum values (0/1/2) as a regression guard,
// verifies default property values, open/close behaviour, and horizontal
// positioning per align (asserted by reading the Popup's x once open).
//
// Popover derives from Popup (not Item), so unlike HoverCard it carries no
// inherited Item.TransformOrigin members — the Align members Start/Center/End
// cannot be shadowed (issue #029 does not apply here). There is also only one
// enum on the type, so no same-file name collision is possible (issue #028).
//
// The offscreen test platform delivers no real pointer events, so open/close is
// driven directly via open()/close(); the enter transition means opened turns
// true asynchronously, hence tryVerify. A closed Popup does not apply its
// positioner, so positioning assertions open() the popover first.
Item {
    id: root
    width: 600
    height: 600

    // Wide trigger for positioning; the popover is narrower than the trigger so
    // Start/Center/End produce distinct x values.
    Item {
        id: posTrigger
        width: 300
        height: 50
        Popover {
            id: posPop
            width: 100
        }
    }

    // Untouched popover for asserting default property values.
    Item {
        id: defTrigger
        width: 80
        height: 30
        Popover {
            id: defPop
            Rectangle { width: 10; height: 10 }
        }
    }

    // Dedicated popover for open/close behaviour.
    Item {
        id: ocTrigger
        width: 120
        height: 40
        Popover {
            id: ocPop
            width: 100
        }
    }

    TestCase {
        id: testCase
        name: "Popover"
        when: windowShown

        function cleanup() {
            posPop.close()
            ocPop.close()
            defPop.close()
            // Restore positioning popover to defaults.
            posPop.align = Popover.Align.Center
        }

        function openPop(pop) {
            pop.open()
            tryVerify(function() { return pop.opened }, 2000)
        }

        // ---- Enum value guard: Align must be sequential from 0 ----
        // Popup is not an Item, so no TransformOrigin.Center collision can shift
        // these. Also guards against a future second enum reordering values (#028).
        function test_enum_values() {
            compare(Popover.Align.Start, 0)
            compare(Popover.Align.Center, 1)
            compare(Popover.Align.End, 2)
        }

        // ---- Default property values (untouched popover) ----
        function test_defaults() {
            compare(defPop.align, Popover.Align.Center)
            compare(defPop.sideOffset, 4)
            compare(defPop.width, 288)
            compare(defPop.modal, false)
            compare(defPop.dim, false)
            verify(!defPop.opened)
        }

        // ---- Open then close ----
        function test_open_close() {
            verify(!ocPop.opened)
            ocPop.open()
            tryVerify(function() { return ocPop.opened }, 2000)
            ocPop.close()
            tryVerify(function() { return !ocPop.opened }, 2000)
        }

        // ---- y is always trigger height + sideOffset (opens below) ----
        function test_position_y() {
            openPop(posPop)
            tryCompare(posPop, "y", 50 + 4)          // triggerH + sideOffset = 54
        }

        // ---- Center align: horizontally centered over the trigger ----
        function test_align_center() {
            posPop.align = Popover.Align.Center
            openPop(posPop)
            tryCompare(posPop, "x", (300 - 100) / 2) // (triggerW - width) / 2 = 100
        }

        // ---- Start align: left edges flush ----
        function test_align_start() {
            posPop.align = Popover.Align.Start
            openPop(posPop)
            tryCompare(posPop, "x", 0)
        }

        // ---- End align: right edges flush ----
        function test_align_end() {
            posPop.align = Popover.Align.End
            openPop(posPop)
            tryCompare(posPop, "x", 300 - 100)       // triggerW - width = 200
        }
    }
}
