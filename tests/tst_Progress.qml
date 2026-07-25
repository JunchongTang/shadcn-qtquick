import QtQuick
import QtTest
import Shadcn

// Progress unit tests: the indicator width tracks the completed fraction of the
// track, clamps at the range ends, honors a custom from/to range, and paints the
// muted/primary tokens. Geometry is asserted by reading the rendered indicator
// and track rectangles. Deterministic and offscreen (no keyboard/pointer input).
Item {
    id: root
    width: 400
    height: 240

    Progress { id: p0;    value: 0 }
    Progress { id: p25;   value: 25 }
    Progress { id: p50;   value: 50 }
    Progress { id: p75;   value: 75 }
    Progress { id: p100;  value: 100 }
    Progress { id: pOver; value: 150 }           // clamps to 100%
    Progress { id: pUnder; value: -20 }          // clamps to 0%
    Progress { id: pRange; from: 0; to: 200; value: 50 }  // 25%

    TestCase {
        name: "Progress"
        when: windowShown

        function test_defaults() {
            compare(p0.value, 0)
            compare(p0.from, 0)
            compare(p0.to, 100)
            compare(p0.indeterminate, false)
            compare(p0.implicitHeight, 4)   // h-1
            compare(p0.implicitWidth, 200)
        }

        // Indicator width == fraction * track width (settled after the animation).
        function test_indicator_width_fraction_data() {
            return [
                { tag: "0%",   ctrl: p0,   frac: 0.0 },
                { tag: "25%",  ctrl: p25,  frac: 0.25 },
                { tag: "50%",  ctrl: p50,  frac: 0.5 },
                { tag: "75%",  ctrl: p75,  frac: 0.75 },
                { tag: "100%", ctrl: p100, frac: 1.0 },
            ]
        }
        function test_indicator_width_fraction(d) {
            var expected = d.ctrl.track.width * d.frac
            tryCompare(d.ctrl.indicator, "width", expected)
        }

        // The indicator fills the track height and uses the rounded-md radius.
        function test_indicator_height_and_radius() {
            compare(p50.indicator.height, p50.track.height)
            compare(p50.indicator.height, 4)
            compare(p50.track.radius, Theme.radiusMd)
            compare(p50.indicator.radius, Theme.radiusMd)
        }

        // Out-of-range values clamp: >to -> full, <from -> empty.
        function test_clamp() {
            tryCompare(pOver.indicator, "width", pOver.track.width)  // 150 -> 100%
            tryCompare(pUnder.indicator, "width", 0)                 // -20 -> 0%
            compare(pOver.position, 1.0)
            compare(pUnder.position, 0.0)
        }

        // Custom range: value 50 within [0, 200] is 25% of the track.
        function test_custom_from_to() {
            compare(pRange.position, 0.25)
            tryCompare(pRange.indicator, "width", pRange.track.width * 0.25)
        }

        // Color tokens: track = muted, indicator = primary.
        function test_color_tokens() {
            compare(p50.track.color, Theme.muted)
            compare(p50.indicator.color, Theme.primary)
        }
    }
}
