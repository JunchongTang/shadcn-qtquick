import QtQuick
import QtTest
import Shadcn

// Slider unit tests: inherited API defaults, value->handle position mapping,
// the bg-primary indicator filled to the value fraction, track/handle geometry
// + colors, disabled opacity, and vertical orientation. Appearance is asserted
// by reading the rendered rectangles' geometry/colors so regressions are caught
// deterministically. Sizing is deterministic offscreen because each control sits
// outside any layout and adopts its implicit size (200x12 horizontal,
// 12x160 vertical).
Item {
    id: root
    width: 320
    height: 320

    // Bare instance: defaults to `from` (0), thumb at the start.
    Slider { id: sDefault }

    // Explicit horizontal value: three-quarters of the range.
    Slider { id: sValue; from: 0; to: 100; value: 75 }

    // Vertical slider at one-quarter.
    Slider {
        id: sVert
        orientation: Qt.Vertical
        from: 0; to: 100; value: 25
    }

    // Locate the bg-primary indicator rectangle inside a control's track.
    function rangeRect(ctrl) {
        var t = ctrl.background
        for (var i = 0; i < t.children.length; ++i)
            if (t.children[i].objectName === "range")
                return t.children[i]
        return null
    }

    TestCase {
        name: "Slider"
        when: windowShown

        // Inherited API defaults + implicit sizing.
        function test_defaults() {
            compare(sDefault.from, 0)
            compare(sDefault.to, 100)
            compare(sDefault.stepSize, 1)
            compare(sDefault.orientation, Qt.Horizontal)
            compare(sDefault.value, 0)        // defaults to `from`
            compare(sDefault.position, 0)
            compare(sDefault.implicitWidth, 200)
            compare(sDefault.implicitHeight, 12)
        }

        // value maps to a normalized position, updating dynamically.
        function test_position_mapping() {
            fuzzyCompare(sValue.position, 0.75, 0.001)

            sDefault.value = 40
            tryCompare(sDefault, "position", 0.40)
            sDefault.value = 0   // restore default for isolation
        }

        // Track: bg-muted, rounded-md, h-1 (4px), full available width.
        function test_track_geometry() {
            var t = sValue.background
            compare(t.height, 4)
            compare(t.width, sValue.availableWidth)
            compare(t.color, Theme.muted)
            compare(t.radius, Theme.radiusMd)
        }

        // Handle: size-3 (12px), white, 1px ring border, vertically centered,
        // positioned at visualPosition * (available - size).
        function test_handle_geometry() {
            compare(sValue.handle.width, 12)
            compare(sValue.handle.height, 12)
            compare(sValue.handle.color, Qt.color("#ffffff"))
            compare(sValue.handle.border.width, 1)
            compare(sValue.handle.border.color, Theme.ring)

            var span = sValue.availableWidth - 12   // 200 - 12 = 188
            fuzzyCompare(sValue.handle.x, 0.75 * span, 0.5)   // ~141
            // Vertically centered on the 12px control.
            compare(sValue.handle.y, 0)
        }

        // Indicator: bg-primary, filled horizontally to the value fraction.
        function test_filled_track_horizontal() {
            var r = rangeRect(sValue)
            verify(r !== null)
            compare(r.color, Theme.primary)
            var w = sValue.background.width
            compare(r.x, 0)                               // anchored at the start
            fuzzyCompare(r.width, 0.75 * w, 0.5)          // filled to the value
            compare(r.height, sValue.background.height)   // full track height
        }

        // Vertical: w-1 track, indicator fills bottom-up to the value fraction.
        function test_vertical() {
            compare(sVert.implicitWidth, 12)
            compare(sVert.implicitHeight, 160)
            var t = sVert.background
            compare(t.width, 4)                           // w-1
            compare(t.height, sVert.availableHeight)      // full available height

            fuzzyCompare(sVert.position, 0.25, 0.001)

            var r = rangeRect(sVert)
            verify(r !== null)
            compare(r.color, Theme.primary)
            compare(r.width, t.width)                     // full track width
            var h = t.height
            // height = position * h ; y = h - height (bottom-up fill).
            fuzzyCompare(r.height, 0.25 * h, 0.5)
            fuzzyCompare(r.y, h - 0.25 * h, 0.5)
        }

        // Disabled dims the whole control (data-disabled:opacity-50).
        function test_disabled_opacity() {
            sDefault.enabled = false
            compare(sDefault.opacity, 0.5)
            sDefault.enabled = true
            compare(sDefault.opacity, 1.0)
        }
    }
}
