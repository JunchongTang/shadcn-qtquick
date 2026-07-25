import QtQuick
import QtTest
import Shadcn

// Skeleton unit tests: .cn-skeleton surface (bg-muted fill, rounded-md corner),
// caller-driven geometry, radius override for circular placeholders, and the
// animate-pulse opacity animation (present, infinite, 1 -> 0.5 -> 1 over 2s).
// The live opacity value is not asserted (it is mid-animation and thus
// non-deterministic); the animation configuration is inspected via the `pulse`
// alias instead. Theme.dark defaults to false, so light-mode tokens apply.
Item {
    id: root
    width: 320
    height: 240

    Skeleton {
        id: line
        width: 150
        height: 16
    }

    Skeleton {
        id: avatar
        width: 40
        height: 40
        radius: width / 2
    }

    TestCase {
        name: "Skeleton"
        when: windowShown

        // Surface: bg-muted fill and rounded-md (radiusMd == 8) corner.
        function test_surface() {
            compare(line.color, Theme.muted)
            compare(line.radius, Theme.radiusMd)
            compare(Theme.radiusMd, 8) // rounded-md == calc(radius - 2px)
        }

        // The caller sizes the skeleton; the given geometry is honored verbatim.
        function test_geometry() {
            compare(line.width, 150)
            compare(line.height, 16)
        }

        // radius is not readonly: callers override it for circular placeholders
        // (size-10 rounded-full -> radius == width/2).
        function test_radius_override() {
            compare(avatar.radius, 20)
        }

        // animate-pulse: the pulse animation is present, running while visible,
        // and loops forever.
        function test_pulse_present() {
            verify(line.pulse !== null)
            // running is bound to visible; tryCompare tolerates the value-source
            // starting up right after windowShown rather than exactly at it.
            tryCompare(line.pulse, "running", true)     // running: visible
            // Animation.Infinite == -1. Compare to the literal so the assertion
            // does not depend on the Animation enum resolving in this scope.
            compare(line.pulse.loops, -1)
        }

        // Pulse steps: opacity fades 1 -> 0.5 then 0.5 -> 1, 1000ms each (2s cycle).
        function test_pulse_steps() {
            var steps = line.pulse.animations
            compare(steps.length, 2)
            compare(steps[0].from, 1.0)
            compare(steps[0].to, 0.5)
            compare(steps[0].duration, 1000)
            compare(steps[1].from, 0.5)
            compare(steps[1].to, 1.0)
            compare(steps[1].duration, 1000)
        }

        // A hidden skeleton stops pulsing (running is bound to visible).
        function test_pulse_stops_when_hidden() {
            line.visible = false
            verify(!line.pulse.running)
            line.visible = true
            verify(line.pulse.running)
        }
    }
}
