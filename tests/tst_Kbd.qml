import QtQuick
import QtTest
import Shadcn

// Kbd / KbdGroup unit tests: key-cap surface (muted fill, rounded-xs, h-5,
// min-w-5, px-1 fit), label text/color/font, and KbdGroup gap-1 spacing.
// Geometry and colors are read after render; deterministic under offscreen.
// Theme.dark defaults to false, so the light-mode tokens apply.
Item {
    id: root
    width: 320
    height: 240

    // Explicit implicit-driven sizing so the cap has real geometry to assert.
    component K: Kbd {
        width: implicitWidth
        height: implicitHeight
    }

    K { id: kShort; text: "A" }
    K { id: kLong; text: "Ctrl + B" }

    KbdGroup {
        id: group
        Kbd { id: gA; text: "Ctrl" }
        Kbd { id: gB; text: "Shift" }
        Kbd { id: gC; text: "P" }
    }

    TestCase {
        name: "Kbd"
        when: windowShown

        // Cap surface: muted fill, rounded-xs (2px), h-5 (20px).
        function test_surface() {
            compare(kShort.color, Theme.muted)
            compare(kShort.radius, 2)          // rounded-xs (0.125rem)
            compare(kShort.implicitHeight, 20) // h-5
        }

        // min-w-5: a single narrow glyph is clamped to the 20px minimum width.
        function test_min_width() {
            compare(kShort.implicitWidth, 20)
        }

        // w-fit + px-1: a wider label grows the cap to text width + 8px (4px each side).
        function test_fit_width() {
            var label = kLong.children[0]
            verify(kLong.implicitWidth > 20)
            compare(kLong.implicitWidth, Math.max(20, label.implicitWidth + 8))
        }

        // Label text is exposed through the text alias.
        function test_text_alias() {
            compare(kLong.text, "Ctrl + B")
        }

        // Label styling: muted-foreground, 10px medium sans.
        function test_label_style() {
            var label = kShort.children[0]
            compare(label.color, Theme.mutedForeground)
            compare(label.font.pixelSize, 10)  // text-[0.625rem]
            compare(label.font.weight, Font.Medium)
            compare(label.font.family, Theme.fontSans)
        }

        // KbdGroup uses gap-1 (4px) between caps.
        function test_group_spacing() {
            compare(group.spacing, Theme.space1) // gap-1 == 4
        }

        // Caps are laid out left-to-right with the gap-1 gap between them.
        function test_group_layout() {
            compare(gB.x, gA.x + gA.width + group.spacing)
            compare(gC.x, gB.x + gB.width + group.spacing)
        }

        // Caps in a group share the same 20px cap height and are top-aligned.
        function test_group_alignment() {
            compare(gA.height, 20)
            compare(gA.y, gB.y)
            compare(gB.y, gC.y)
        }
    }
}
