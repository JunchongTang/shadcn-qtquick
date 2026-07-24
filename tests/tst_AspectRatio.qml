import QtQuick
import QtTest
import Shadcn

// AspectRatio unit tests: verify height is derived from width via the ratio
// (height = width / ratio) after render, across a few ratios. Deterministic
// under offscreen since the math depends only on width and ratio, not layout.
Item {
    id: root
    width: 480
    height: 480

    AspectRatio { id: a169; width: 320; ratio: 16 / 9 }
    AspectRatio { id: a11;  width: 200; ratio: 1 / 1 }
    AspectRatio { id: a916; width: 180; ratio: 9 / 16 }

    TestCase {
        name: "AspectRatio"
        when: windowShown

        function test_defaults() {
            compare(a169.ratio, 16 / 9)
            compare(a169.radius, 0)
            compare(a169.color.a, 0)  // transparent by default
        }

        // Landscape 16:9 -> height = width / ratio.
        function test_ratio_16x9() {
            fuzzyCompare(a169.height, 320 / (16 / 9), 0.001)  // 180
        }

        // Square 1:1 -> height equals width.
        function test_ratio_1x1() {
            fuzzyCompare(a11.height, 200, 0.001)
        }

        // Portrait 9:16 -> height taller than width.
        function test_ratio_9x16() {
            fuzzyCompare(a916.height, 180 / (9 / 16), 0.001)  // 320
            verify(a916.height > a916.width)
        }

        // Height tracks width changes live.
        function test_reactive_width() {
            a169.width = 640
            fuzzyCompare(a169.height, 640 / (16 / 9), 0.001)  // 360
            a169.width = 320  // restore
        }

        // Ratio <= 0 is guarded to avoid an Infinity/NaN height.
        function test_guard_nonpositive_ratio() {
            var g = Qt.createQmlObject(
                'import Shadcn; AspectRatio { width: 100; ratio: 0 }', root)
            compare(g.height, 0)
            g.destroy()
        }
    }
}
