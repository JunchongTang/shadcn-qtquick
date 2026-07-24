import QtQuick
import QtTest
import Shadcn

// Carousel / CarouselItem unit tests: container defaults (orientation enum,
// currentIndex, spacing, count), next/prev navigation clamping at the ends,
// canScrollPrev/canScrollNext, and slide geometry derived from the viewport
// and basis for both axes. Geometry is asserted by reading the rendered
// items' sizes after layout. Deterministic under QT_QPA_PLATFORM=offscreen.
Item {
    id: root
    width: 640
    height: 640

    // Horizontal carousel: four full-width slides.
    Carousel {
        id: hz
        width: 300
        height: 200

        CarouselItem { id: hz0; Rectangle { anchors.fill: parent } }
        CarouselItem { id: hz1; Rectangle { anchors.fill: parent } }
        CarouselItem { id: hz2; Rectangle { anchors.fill: parent } }
        CarouselItem { id: hz3; Rectangle { anchors.fill: parent } }
    }

    // Horizontal carousel of half-width slides. basis-0.5 slides are narrow
    // enough that the leading one is realized at index 0, so its size can be
    // read (a full-width slide off-screen would never receive a ListView).
    Carousel {
        id: hzBasis
        width: 300
        height: 200

        CarouselItem { id: hbHalf; basis: 0.5; Rectangle { anchors.fill: parent } }
        CarouselItem { basis: 0.5; Rectangle { anchors.fill: parent } }
        CarouselItem { basis: 0.5; Rectangle { anchors.fill: parent } }
    }

    // Vertical carousel: two half-height slides.
    Carousel {
        id: vt
        orientation: Carousel.Vertical
        width: 300
        height: 270

        CarouselItem { id: vt0; basis: 0.5; Rectangle { anchors.fill: parent } }
        CarouselItem { id: vt1; basis: 0.5; Rectangle { anchors.fill: parent } }
    }

    TestCase {
        name: "Carousel"
        when: windowShown

        function test_enum_values() {
            // Horizontal/Vertical do not collide with inherited TransformOrigin.
            compare(Carousel.Horizontal, 0)
            compare(Carousel.Vertical, 1)
        }

        function test_defaults() {
            compare(hz.orientation, Carousel.Horizontal)
            compare(hz.currentIndex, 0)
            compare(hz.spacing, 16)
            compare(hz.count, 4)
            compare(hz.canScrollPrev, false)
            compare(hz.canScrollNext, true)
        }

        function test_next_prev_navigation() {
            hz.currentIndex = 0
            compare(hz.currentIndex, 0)

            hz.scrollNext()
            compare(hz.currentIndex, 1)
            compare(hz.canScrollPrev, true)

            hz.scrollNext()
            compare(hz.currentIndex, 2)

            hz.scrollPrev()
            compare(hz.currentIndex, 1)

            hz.scrollPrev()
            compare(hz.currentIndex, 0)
            // Reset for other tests.
            hz.currentIndex = 0
        }

        // scrollPrev at the first slide and scrollNext at the last are no-ops.
        function test_navigation_clamped() {
            hz.currentIndex = 0
            hz.scrollPrev()
            compare(hz.currentIndex, 0)

            hz.currentIndex = hz.count - 1
            compare(hz.canScrollNext, false)
            hz.scrollNext()
            compare(hz.currentIndex, hz.count - 1)

            hz.currentIndex = 0
        }

        // Horizontal: full-width slide fills the viewport width; height fills.
        function test_horizontal_geometry() {
            tryCompare(hz0, "width", 300)
            tryCompare(hz0, "height", 200)
            // basis 0.5 halves the width; height still fills the viewport.
            tryCompare(hbHalf, "width", 150)
            tryCompare(hbHalf, "height", 200)
        }

        // Vertical: half-height slide is half the viewport height; width fills.
        function test_vertical_geometry() {
            compare(vt.orientation, Carousel.Vertical)
            tryCompare(vt0, "height", 135)
            tryCompare(vt0, "width", 300)
        }
    }
}
