import QtQuick
import QtTest
import Shadcn

// Avatar unit tests: defaults, size scale (rendered dimensions), the circular
// shape (radius == diameter/2, and the RoundedImage cropped to the same
// radius), fallback text behaviour, and the 1px border ring. Geometry is read
// after render so regressions in sizing/rounding are caught deterministically.
Item {
    id: root
    width: 240
    height: 240

    Avatar { id: aDefault; fallback: "CN" }
    Avatar { id: aSm; size: Avatar.Sm; fallback: "CN" }
    Avatar { id: aLg; size: Avatar.Lg; fallback: "CN" }
    Avatar { id: aNoFallback }

    // The fallback is the only child exposing a string `text`.
    function fallbackItem(a) {
        for (var i = 0; i < a.children.length; i++)
            if (a.children[i].text !== undefined)
                return a.children[i]
        return null
    }

    // The RoundedImage exposes a `status` alias; the plain rects do not.
    function imageItem(a) {
        for (var i = 0; i < a.children.length; i++)
            if (a.children[i].status !== undefined)
                return a.children[i]
        return null
    }

    // The border ring is the transparent Rectangle with a 1px border.
    function borderItem(a) {
        for (var i = 0; i < a.children.length; i++) {
            var c = a.children[i]
            if (c.border !== undefined && c.border.width === 1)
                return c
        }
        return null
    }

    TestCase {
        name: "Avatar"
        when: windowShown

        function test_defaults() {
            compare(aDefault.size, Avatar.Default)
            compare(aDefault.implicitWidth, 32)
            compare(aDefault.implicitHeight, 32)
            compare(aDefault.color, Theme.muted)
            compare(aNoFallback.fallback, "")
        }

        // Compact size scale: sm 24 / default 32 / lg 40 (rendered dimensions).
        function test_sizes() {
            compare(aSm.width, 24)
            compare(aSm.height, 24)
            compare(aDefault.width, 32)
            compare(aDefault.height, 32)
            compare(aLg.width, 40)
            compare(aLg.height, 40)
        }

        // Shape is a perfect circle: radius == diameter / 2 at every size, and
        // the RoundedImage is cropped to the same radius (regression #007).
        function test_circular_shape() {
            compare(aSm.radius, 12)
            compare(aDefault.radius, 16)
            compare(aLg.radius, 20)
            compare(aDefault.radius, aDefault.width / 2)

            var img = imageItem(aDefault)
            verify(img !== null)
            compare(img.radius, aDefault.radius)
        }

        // Fallback text is shown when the image is not ready and carries the
        // configured string; text-sm (14) by default, text-xs (12) when sm.
        function test_fallback() {
            var fb = fallbackItem(aDefault)
            verify(fb !== null)
            compare(fb.text, "CN")
            compare(fb.visible, true)            // no source -> image not ready
            compare(fb.font.pixelSize, Theme.textSm)

            var fbSm = fallbackItem(aSm)
            compare(fbSm.font.pixelSize, Theme.textXs)
        }

        // A 1px border ring is drawn on top, matching after:border-border.
        function test_border_ring() {
            var b = borderItem(aDefault)
            verify(b !== null)
            compare(b.border.width, 1)
            compare(b.radius, aDefault.radius)
        }
    }
}
