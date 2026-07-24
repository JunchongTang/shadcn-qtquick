import QtQuick
import QtTest
import Shadcn

// Accordion / AccordionItem unit tests: container defaults and border,
// item defaults, trigger background (transparent -> bg-muted/50 when open),
// chevron rotation, content expand/collapse geometry, separator visibility,
// and the disabled (dimmed) trigger. Appearance is asserted by reading the
// rendered rectangles' geometry/colors after layout. Deterministic under
// QT_QPA_PLATFORM=offscreen.
Item {
    id: root
    width: 480
    height: 480

    Accordion {
        id: acc
        width: 420

        AccordionItem {
            id: itemOpen
            title: "Open by default"
            expanded: true
            Text { text: "Some content that gives the panel a real height." }
        }
        AccordionItem {
            id: itemClosed
            title: "Closed"
            Text { text: "More content here." }
        }
        AccordionItem {
            id: itemDisabled
            title: "Disabled"
            enabled: false
            last: true
            Text { text: "Unavailable." }
        }
    }

    Accordion {
        id: accPlain
        bordered: false
        width: 420
        AccordionItem { title: "x"; last: true }
    }

    TestCase {
        name: "Accordion"
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

        function test_accordion_defaults() {
            compare(acc.bordered, true)
            compare(acc.implicitWidth, 400)
            compare(acc.background.radius, Theme.radiusMd)
            compare(acc.background.border.width, 1)
            compare(acc.background.border.color, Theme.border)
            // Transparent fill; only the border is visible.
            compare(acc.background.color.a, 0)
        }

        // bordered:false removes the outer frame.
        function test_bordered_off() {
            compare(accPlain.bordered, false)
            compare(accPlain.background.border.width, 0)
        }

        function test_item_defaults() {
            compare(itemClosed.title, "Closed")
            compare(itemClosed.expanded, false)
            compare(itemClosed.last, false)
            // Fixed compact trigger height.
            compare(itemClosed.background.height, 34)
            compare(itemDisabled.last, true)
        }

        // Trigger background: transparent when closed, bg-muted/50 when open.
        function test_trigger_background() {
            compare(itemClosed.background.color.a, 0)
            compare(itemOpen.background.color, Theme.alpha(Theme.muted, 0.5))
            // Collapsing switches the fill straight back to transparent (not animated).
            itemOpen.expanded = false
            compare(itemOpen.background.color.a, 0)
            itemOpen.expanded = true
            compare(itemOpen.background.color, Theme.alpha(Theme.muted, 0.5))
        }

        // Chevron rotates 0 -> 180 as the item opens (animated).
        function test_chevron_rotation() {
            const chOpen = byName(itemOpen, "chevron")
            const chClosed = byName(itemClosed, "chevron")
            verify(chOpen !== null)
            verify(chClosed !== null)
            tryCompare(chOpen, "rotation", 180)
            compare(chClosed.rotation, 0)
        }

        // Content region: collapsed height is 0, expanded height is > 0.
        function test_content_expand() {
            const closed = byName(itemClosed, "content")
            const open = byName(itemOpen, "content")
            verify(closed !== null)
            verify(open !== null)
            compare(closed.height, 0)
            tryVerify(function() { return open.height > 0 })
            // Opening a closed item animates its height above 0.
            itemClosed.expanded = true
            tryVerify(function() { return closed.height > 0 })
            itemClosed.expanded = false
            tryCompare(closed, "height", 0)
        }

        // Separator hidden only on the last item.
        function test_separator() {
            const sepMid = byName(itemClosed, "separator")
            const sepLast = byName(itemDisabled, "separator")
            verify(sepMid !== null)
            verify(sepLast !== null)
            compare(sepMid.visible, true)
            compare(sepMid.height, 1)
            compare(sepMid.color, Theme.border)
            compare(sepLast.visible, false)
        }

        // Disabled item dims the trigger to 50% and blocks toggling.
        function test_disabled() {
            compare(itemDisabled.enabled, false)
            compare(itemDisabled.background.opacity, 0.5)
            compare(itemClosed.background.opacity, 1.0)
        }
    }
}
