import QtQuick
import QtTest
import Shadcn

// Separator unit tests: a 1px divider filled with the border token.
// Horizontal is 1px tall and spans its (explicit) width; vertical is 1px wide
// and spans its (explicit) height. Geometry and colors are read after render;
// deterministic under offscreen. Theme.dark defaults to false, so the
// light-mode border token applies.
Item {
    id: root
    width: 320
    height: 240

    // Horizontal rule given a real width to span (mirrors w-full in a layout).
    Separator {
        id: hSep
        width: 200
        orientation: Separator.Horizontal
    }

    // Vertical rule given a real height to span (mirrors self-stretch).
    Separator {
        id: vSep
        height: 40
        orientation: Separator.Vertical
    }

    // Bare separator to lock the default orientation and implicit sizing.
    Separator { id: defSep }

    TestCase {
        name: "Separator"
        when: windowShown

        // The flattened enum values stay 0 / 1 (no Item.TransformOrigin clash).
        function test_enum_values() {
            compare(Separator.Horizontal, 0)
            compare(Separator.Vertical, 1)
        }

        // Default orientation is Horizontal.
        function test_default_orientation() {
            compare(defSep.orientation, Separator.Horizontal)
        }

        // Horizontal: 1px tall, full (explicit) width, filled with border token.
        function test_horizontal_geometry() {
            compare(hSep.height, 1)          // h-px
            compare(hSep.implicitHeight, 1)
            compare(hSep.width, 200)         // spans the width it was given (w-full)
            compare(hSep.implicitWidth, 100) // default long-axis length
            compare(hSep.color, Theme.border)
        }

        // Vertical: 1px wide, full (explicit) height, filled with border token.
        function test_vertical_geometry() {
            compare(vSep.width, 1)            // w-px
            compare(vSep.implicitWidth, 1)
            compare(vSep.height, 40)          // spans the height it was given (self-stretch)
            compare(vSep.implicitHeight, 100) // default long-axis length
            compare(vSep.color, Theme.border)
        }
    }
}
