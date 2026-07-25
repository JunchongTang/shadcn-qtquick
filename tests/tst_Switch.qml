import QtQuick
import QtTest
import Shadcn

// Switch unit tests: API defaults, track geometry (28x17 default / 24x14 sm,
// capsule radius), checked/unchecked track color, thumb size + slide x position
// at both ends and both sizes, disabled opacity, and the invalid (aria-invalid)
// destructive border + ring. Appearance is asserted by reading rendered
// geometry/colors; animated color and thumb x use tryCompare.
// Deterministic under offscreen; runs in the default light theme (Theme.dark=false).
Item {
    id: root
    width: 320
    height: 320

    Switch { id: swDefault }                                 // unchecked, default size
    Switch { id: swChecked; checked: true }
    Switch { id: swSm; size: Switch.Sm }
    Switch { id: swSmChecked; size: Switch.Sm; checked: true }
    Switch { id: swDisabled; enabled: false }
    Switch { id: swInvalid; invalid: true }

    TestCase {
        name: "Switch"
        when: windowShown

        // Recursively locate a rendered child by objectName.
        function byName(node, n) {
            for (let i = 0; i < node.children.length; i++) {
                const c = node.children[i]
                if (c.objectName === n)
                    return c
                const r = byName(c, n)
                if (r)
                    return r
            }
            return null
        }

        function test_defaults() {
            compare(swDefault.checked, false)
            compare(swDefault.invalid, false)
            compare(swDefault.size, Switch.Default)
            compare(swDefault.focusPolicy, Qt.StrongFocus)
            compare(swDefault.opacity, 1.0)
        }

        // Default: 28x17 capsule track (radius = height/2).
        function test_geometry_default() {
            compare(swDefault.implicitWidth, 28)
            compare(swDefault.implicitHeight, 17)
            compare(swDefault.indicator.implicitWidth, 28)
            compare(swDefault.indicator.implicitHeight, 17)
            compare(swDefault.indicator.width, 28)
            compare(swDefault.indicator.height, 17)
            compare(swDefault.indicator.radius, 17 / 2)
        }

        // Sm: 24x14 capsule track.
        function test_geometry_sm() {
            compare(swSm.implicitWidth, 24)
            compare(swSm.implicitHeight, 14)
            compare(swSm.indicator.width, 24)
            compare(swSm.indicator.height, 14)
            compare(swSm.indicator.radius, 14 / 2)
        }

        // Thumb: circular, size-3.5 (14) default / size-3 (12) sm.
        function test_thumb_size() {
            const td = byName(swDefault.indicator, "thumb")
            verify(td !== null)
            compare(td.width, 14)
            compare(td.height, 14)
            compare(td.radius, 7)
            const ts = byName(swSm.indicator, "thumb")
            compare(ts.width, 12)
            compare(ts.height, 12)
        }

        // Thumb rests against the 1px track border: unchecked x=1,
        // checked x = width - thumb - 1 (13 default, 11 sm).
        function test_thumb_position_default() {
            const td = byName(swDefault.indicator, "thumb")
            compare(td.x, 1)
            const tc = byName(swChecked.indicator, "thumb")
            tryCompare(tc, "x", 28 - 14 - 1)   // 13
        }

        function test_thumb_position_sm() {
            const ts = byName(swSm.indicator, "thumb")
            compare(ts.x, 1)
            const tsc = byName(swSmChecked.indicator, "thumb")
            tryCompare(tsc, "x", 24 - 12 - 1)  // 11
        }

        // Unchecked (light): track fills with the input color, no destructive border.
        function test_unchecked_track_color() {
            compare(swDefault.indicator.color, Theme.input)
            compare(swDefault.indicator.border.color.a, 0)   // transparent border
        }

        // Checked: track settles to primary.
        function test_checked_track_color() {
            tryCompare(swChecked.indicator, "color", Theme.primary)
        }

        // Toggling animates the track color and slides the thumb both ways.
        function test_toggle() {
            const th = byName(swDefault.indicator, "thumb")
            swDefault.checked = true
            tryCompare(swDefault.indicator, "color", Theme.primary)
            tryCompare(th, "x", 28 - 14 - 1)
            swDefault.checked = false
            tryCompare(swDefault.indicator, "color", Theme.input)
            tryCompare(th, "x", 1)
        }

        // Disabled -> opacity 0.5.
        function test_disabled_opacity() {
            compare(swDisabled.opacity, 0.5)
            compare(swDefault.opacity, 1.0)
        }

        // Invalid: destructive track border and a visible destructive ring.
        function test_invalid() {
            const ring = byName(swInvalid.indicator, "invalidRing")
            verify(ring !== null)
            compare(ring.visible, true)
            compare(swInvalid.indicator.border.color, Theme.destructive)
            compare(ring.border.color, Theme.alpha(Theme.destructive, 0.2))
        }

        // Toggling invalid shows/hides the ring; a default switch has none.
        function test_invalid_ring_visibility() {
            const ring = byName(swDefault.indicator, "invalidRing")
            verify(ring !== null)
            compare(ring.visible, false)
            swDefault.invalid = true
            compare(ring.visible, true)
            swDefault.invalid = false
            compare(ring.visible, false)
        }
    }
}
