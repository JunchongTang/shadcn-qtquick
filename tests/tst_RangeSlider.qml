import QtQuick
import QtTest
import Shadcn

// RangeSlider unit tests: defaults (full-range fallback), value->position
// mapping for both handles, the bg-primary range filled between the thumbs,
// and track/handle geometry + colors. Appearance is asserted by reading the
// rendered rectangles' geometry/colors so regressions are caught deterministically.
// Sizing is deterministic offscreen because each control sits outside any layout
// and therefore adopts its implicit size (200x12 horizontal, 12x160 vertical).
Item {
    id: root
    width: 320
    height: 320

    // Bare instance: should span the full range (see defaults fix).
    RangeSlider { id: rDefault }

    // Explicit horizontal range: quarter..three-quarters.
    RangeSlider { id: rRange; from: 0; to: 100; first.value: 25; second.value: 75 }

    // Vertical range: fifth..four-fifths.
    RangeSlider {
        id: rVert
        orientation: Qt.Vertical
        from: 0; to: 100; first.value: 20; second.value: 80
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
        name: "RangeSlider"
        when: windowShown

        // Full-range fallback + inherited API defaults.
        function test_defaults() {
            compare(rDefault.from, 0)
            compare(rDefault.to, 100)
            compare(rDefault.stepSize, 1)
            compare(rDefault.orientation, Qt.Horizontal)
            compare(rDefault.first.value, 0)     // defaults to `from`
            compare(rDefault.second.value, 100)  // defaults to `to`
            compare(rDefault.implicitWidth, 200)
            compare(rDefault.implicitHeight, 12)
        }

        // Both handles map value -> normalized position independently.
        function test_position_mapping() {
            fuzzyCompare(rRange.first.position, 0.25, 0.001)
            fuzzyCompare(rRange.second.position, 0.75, 0.001)

            // Dynamic update: moving a handle updates its position.
            rDefault.first.value = 30
            rDefault.second.value = 90
            tryCompare(rDefault.first, "position", 0.30)
            tryCompare(rDefault.second, "position", 0.90)
            // Restore full-range default for isolation.
            rDefault.first.value = 0
            rDefault.second.value = 100
        }

        // Handles are size-3 (12px), white with a 1px ring border, vertically
        // centered, and positioned at visualPosition * (available - size).
        function test_handle_geometry() {
            compare(rRange.first.handle.width, 12)
            compare(rRange.first.handle.height, 12)
            compare(rRange.first.handle.color, Qt.color("#ffffff"))
            compare(rRange.first.handle.border.width, 1)
            compare(rRange.first.handle.border.color, Theme.ring)

            var span = rRange.availableWidth - 12   // 200 - 12 = 188
            fuzzyCompare(rRange.first.handle.x, 0.25 * span, 0.5)   // ~47
            fuzzyCompare(rRange.second.handle.x, 0.75 * span, 0.5)  // ~141
            // Vertically centered on the 12px control.
            compare(rRange.first.handle.y, 0)
        }

        // Track: bg-muted, rounded-md, h-1 (4px), full available width.
        function test_track_geometry() {
            var t = rRange.background
            compare(t.height, 4)
            compare(t.width, rRange.availableWidth)
            compare(t.color, Theme.muted)
            compare(t.radius, Theme.radiusMd)
        }

        // Range: bg-primary, spanning horizontally from first to second.
        function test_filled_range_horizontal() {
            var r = rangeRect(rRange)
            verify(r !== null)
            compare(r.color, Theme.primary)
            var w = rRange.background.width
            fuzzyCompare(r.x, 0.25 * w, 0.5)              // starts at first
            fuzzyCompare(r.width, 0.50 * w, 0.5)          // spans first..second
            compare(r.height, rRange.background.height)   // full track height
        }

        // Vertical range fills bottom-up between the two handles.
        function test_filled_range_vertical() {
            compare(rVert.implicitWidth, 12)
            compare(rVert.implicitHeight, 160)
            var t = rVert.background
            compare(t.width, 4)                           // w-1
            compare(t.height, rVert.availableHeight)      // full available height

            fuzzyCompare(rVert.first.position, 0.20, 0.001)
            fuzzyCompare(rVert.second.position, 0.80, 0.001)

            var r = rangeRect(rVert)
            verify(r !== null)
            compare(r.color, Theme.primary)
            compare(r.width, t.width)                     // full track width
            var h = t.height
            // height = (second - first) * h ; y = h - second * h (bottom-up).
            fuzzyCompare(r.height, 0.60 * h, 0.5)
            fuzzyCompare(r.y, h - 0.80 * h, 0.5)
        }

        // Disabled dims the whole control (data-disabled:opacity-50).
        function test_disabled_opacity() {
            rDefault.enabled = false
            compare(rDefault.opacity, 0.5)
            rDefault.enabled = true
            compare(rDefault.opacity, 1.0)
        }
    }
}
