import QtQuick
import QtTest
import Shadcn

// Spinner unit tests: default glyph/size/color, the caller-overridable size and
// color (inherited from LucideIcon), square geometry, and the animate-spin
// rotation animation (present, running while visible, linear 0 -> 360 over 1s,
// looping forever). The live rotation value is mid-animation and thus
// non-deterministic, so the animation configuration is inspected via the `spin`
// alias; a single tryVerify confirms the rotation actually advances (the
// animation is live). Theme.dark defaults to false, so light-mode tokens apply.
Item {
    id: root
    width: 320
    height: 240

    Spinner { id: sDefault }                          // size-4, foreground
    Spinner { id: sLarge; size: 24 }                  // size-6 (Basic example)
    Spinner { id: sColored; color: Theme.primaryForeground } // e.g. inside a Button

    TestCase {
        name: "Spinner"
        when: windowShown

        // Default: loader-2 glyph, size-4 (16px), foreground color.
        function test_defaults() {
            compare(sDefault.name, "loader-2")
            compare(sDefault.size, 16)                // size-4
            compare(sDefault.color, Theme.foreground) // matches currentColor
        }

        // Geometry: LucideIcon binds implicit width/height to size -> square.
        function test_geometry() {
            compare(sDefault.implicitWidth, 16)
            compare(sDefault.implicitHeight, 16)
            compare(sDefault.width, 16)
            compare(sDefault.height, 16)
        }

        // size is caller-overridable (Basic example uses size-6 == 24px).
        function test_size_override() {
            compare(sLarge.size, 24)
            compare(sLarge.implicitWidth, 24)
            compare(sLarge.implicitHeight, 24)
        }

        // color is caller-overridable (e.g. a Button sets its own foreground).
        function test_color_override() {
            compare(sColored.color, Theme.primaryForeground)
        }

        // animate-spin: the rotation animation is present, running while
        // visible, spins 0 -> 360 over 1s, and loops forever. The from/to/
        // duration values come back as reals from the value-source animation,
        // so fuzzyCompare is used instead of the exact-number compare(). loops
        // is compared to the literal -1 (== Animation.Infinite) to avoid
        // depending on the enum symbol resolving in the test import scope.
        function test_spin_config() {
            verify(sDefault.spin !== null)
            verify(sDefault.spin.running)              // running: visible
            fuzzyCompare(sDefault.spin.from, 0, 0.5)   // starts at 0deg
            fuzzyCompare(sDefault.spin.to, 360, 0.5)   // full revolution
            fuzzyCompare(sDefault.spin.duration, 1000, 0.5) // spin 1s == 1000ms
            compare(sDefault.spin.loops, -1)           // Animation.Infinite
        }

        // A hidden spinner stops rotating (running is bound to visible).
        function test_spin_paused_when_hidden() {
            sDefault.visible = false
            verify(!sDefault.spin.running)
            sDefault.visible = true
            verify(sDefault.spin.running)
        }

        // The animation is live: rotation leaves its initial 0 value.
        function test_rotation_advances() {
            tryVerify(function() { return sLarge.rotation !== 0 }, 2000)
        }
    }
}
