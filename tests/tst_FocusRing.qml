import QtQuick
import QtTest
import Shadcn

// FocusRing unit tests: visibility gating, token-driven width/color, outward
// offset geometry, and corner-radius propagation (uniform + per-corner).
// Appearance is asserted by reading the rendered ring geometry and border,
// which is deterministic under the offscreen platform (no real focus needed).
Item {
    id: root
    width: 320
    height: 240

    // Host background with known geometry; the ring anchors-fills it and grows
    // outward by Theme.ringWidth on each side.
    component Host: Rectangle {
        width: 100
        height: 40
        radius: 8
    }

    Host {
        id: hInactive
        FocusRing { id: ringInactive; active: false; targetRadius: parent.radius }
    }

    Host {
        id: hActive
        FocusRing { id: ringActive; active: true; targetRadius: parent.radius }
    }

    // Square target: a 0 target radius must keep the ring corners square.
    Host {
        id: hSquare
        radius: 0
        FocusRing { id: ringSquare; active: true; targetRadius: 0 }
    }

    // Per-corner target radii: flattened top corners (0), rounded bottom (6).
    Host {
        id: hPerCorner
        FocusRing {
            id: ringPerCorner
            active: true
            targetRadius: 8
            targetTopLeft: 0
            targetTopRight: 0
            targetBottomLeft: 6
            targetBottomRight: 6
        }
    }

    TestCase {
        name: "FocusRing"
        when: windowShown

        // Visible strictly follows active.
        function test_visibility_gating() {
            compare(ringInactive.visible, false)
            compare(ringActive.visible, true)
        }

        function test_visibility_toggles_with_active() {
            ringInactive.active = true
            compare(ringInactive.visible, true)
            ringInactive.active = false
            compare(ringInactive.visible, false)
        }

        // Thickness and color are token-driven (not hardcoded).
        function test_width_and_color() {
            compare(ringActive.border.width, Theme.ringWidth)
            compare(ringActive.border.color, Theme.alpha(Theme.ring, Theme.ringOpacity))
            // Fill is transparent; only the border paints.
            compare(ringActive.color.a, 0)
        }

        // Ring sits behind the parent's own content.
        function test_z_order() {
            compare(ringActive.z, -1)
        }

        // No ring-offset: the ring grows outward by exactly ringWidth on each
        // side, hugging the target edge.
        function test_outward_offset_geometry() {
            compare(ringActive.x, -Theme.ringWidth)
            compare(ringActive.y, -Theme.ringWidth)
            compare(ringActive.width, hActive.width + 2 * Theme.ringWidth)
            compare(ringActive.height, hActive.height + 2 * Theme.ringWidth)
        }

        // Uniform radius: each corner is targetRadius + ringWidth so the stroke
        // stays equidistant from the rounded target edge.
        function test_uniform_radius_propagation() {
            var expected = 8 + Theme.ringWidth
            compare(ringActive.radius, expected)
            compare(ringActive.topLeftRadius, expected)
            compare(ringActive.topRightRadius, expected)
            compare(ringActive.bottomLeftRadius, expected)
            compare(ringActive.bottomRightRadius, expected)
        }

        // A square target keeps the ring corners square (0), not ringWidth.
        function test_square_target_stays_square() {
            compare(ringSquare.radius, 0)
            compare(ringSquare.topLeftRadius, 0)
            compare(ringSquare.bottomRightRadius, 0)
        }

        // Per-corner overrides: 0 -> square corner, 6 -> 6 + ringWidth. The
        // uniform radius still follows targetRadius (8 + ringWidth).
        function test_per_corner_radius_propagation() {
            compare(ringPerCorner.topLeftRadius, 0)
            compare(ringPerCorner.topRightRadius, 0)
            compare(ringPerCorner.bottomLeftRadius, 6 + Theme.ringWidth)
            compare(ringPerCorner.bottomRightRadius, 6 + Theme.ringWidth)
            compare(ringPerCorner.radius, 8 + Theme.ringWidth)
        }

        // Corners re-resolve when the target radius changes at runtime.
        function test_target_radius_reactive() {
            ringActive.targetRadius = 12
            compare(ringActive.topLeftRadius, 12 + Theme.ringWidth)
            compare(ringActive.radius, 12 + Theme.ringWidth)
            ringActive.targetRadius = 8   // restore for isolation
        }
    }
}
