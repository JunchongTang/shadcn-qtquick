import QtQuick
import QtQuick.Layouts
import QtTest
import Shadcn

// Bubble unit tests: content padding/radius by variant, per-variant background
// and border colors, max-width capping, in-column alignment (self-start /
// self-end) and reaction pill placement. Appearance is asserted by reading the
// rendered BubbleContent rectangle's geometry/colors after layout, so the tests
// stay deterministic under the offscreen platform.
Item {
    id: root
    width: 480
    height: 480

    // ---- Sizing / padding / radius: muted (padded) vs ghost (no padding) ----
    ColumnLayout {
        id: col
        width: 400

        Bubble {
            id: bMuted
            variant: Bubble.Muted
            align: Bubble.Start
            BubbleContent { id: cMuted; text: "Hi" }
        }
        Bubble {
            id: bGhost
            variant: Bubble.Ghost
            align: Bubble.Start
            BubbleContent { id: cGhost; text: "Hi" }
        }
        Bubble {
            id: bDefault
            variant: Bubble.Default
            align: Bubble.End
            BubbleContent { id: cDefault; text: "Yo" }
        }
        Bubble {
            id: bOutline
            variant: Bubble.Outline
            align: Bubble.Start
            BubbleContent { id: cOutline; text: "Yo" }
        }
        Bubble {
            id: bDestructive
            variant: Bubble.Destructive
            align: Bubble.Start
            BubbleContent { id: cDestructive; text: "Yo" }
        }
        Bubble {
            id: bLong
            variant: Bubble.Default
            align: Bubble.Start
            BubbleContent {
                id: cLong
                text: "This is a very long message that must wrap and be capped to 80% of the column width."
            }
        }
    }

    // ---- Reactions placement ----
    ColumnLayout {
        id: rcol
        width: 400
        y: 300

        Bubble {
            id: bReactEnd
            variant: Bubble.Muted
            align: Bubble.Start
            BubbleContent { text: "React end/bottom" }
            BubbleReactions {
                id: rEnd
                side: BubbleReactions.Below
                align: Bubble.End
                Text { text: "OK" }
            }
        }
        Bubble {
            id: bReactStart
            variant: Bubble.Muted
            align: Bubble.Start
            BubbleContent { text: "React start/top" }
            BubbleReactions {
                id: rStart
                side: BubbleReactions.Above
                align: Bubble.Start
                Text { text: "OK" }
            }
        }
    }

    TestCase {
        name: "Bubble"
        when: windowShown

        function test_defaults() {
            compare(bDefault.variant, Bubble.Default)
            compare(bMuted.align, Bubble.Start)
            compare(bMuted.maxWidthRatio, 0.8)
            compare(rEnd.side, BubbleReactions.Below)
            compare(rEnd.align, Bubble.End)
            compare(rStart.side, BubbleReactions.Above)
        }

        // Ghost drops padding (px-2.5/py-1.5) and radius; muted keeps them.
        // Same text -> width differs by 2*space2_5, height by 2*space1_5.
        function test_padding_and_radius() {
            compare(cMuted.radius, Theme.radiusLg)
            compare(cGhost.radius, 0)
            fuzzyCompare(cMuted.implicitWidth - cGhost.implicitWidth, 2 * Theme.space2_5, 0.5)
            fuzzyCompare(cMuted.implicitHeight - cGhost.implicitHeight, 2 * Theme.space1_5, 0.5)
        }

        // Background color per variant (light theme, not hovered). tryCompare
        // rides out the transition-colors Behavior animation.
        function test_backgrounds() {
            tryCompare(cDefault, "color", Theme.primary)
            tryCompare(cMuted, "color", Theme.muted)
            tryCompare(cOutline, "color", Theme.background)
            tryCompare(cDestructive, "color", Theme.alpha(Theme.destructive, 0.1))
            tryCompare(cGhost.color, "a", 0)   // transparent (alpha 0)
        }

        // Only the outline variant paints a 1px border.
        function test_border() {
            compare(cOutline.border.width, 1)
            compare(cDefault.border.width, 0)
            compare(cMuted.border.width, 0)
            compare(cGhost.border.width, 0)
        }

        // Long content is capped to 80% of the column width.
        function test_max_width() {
            verify(cLong.implicitWidth <= col.width * 0.8 + 0.5)
            verify(cLong.implicitWidth > 0)
        }

        // In-column alignment: start -> left edge, end -> right edge.
        function test_alignment() {
            fuzzyCompare(bMuted.x, 0, 0.5)                              // self-start
            fuzzyCompare(bDefault.x, col.width - bDefault.width, 0.5)   // self-end
        }

        // Reaction pill placement relative to the parent Bubble box.
        function test_reactions_position() {
            // end/bottom: right-3 (12px from right), translate down 75% -> y = h - 0.25*rh.
            // Positioned relative to the reactions item's own parent (the bubble body).
            fuzzyCompare(rEnd.x, rEnd.parent.width - rEnd.width - Theme.space3, 0.5)
            fuzzyCompare(rEnd.y, rEnd.parent.height - 0.25 * rEnd.height, 0.5)
            // start/top: left-3 (12px), translate up 75% -> y = -0.75*rh
            fuzzyCompare(rStart.x, Theme.space3, 0.5)
            fuzzyCompare(rStart.y, -0.75 * rStart.height, 0.5)
        }
    }
}
