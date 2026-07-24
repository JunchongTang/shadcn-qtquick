import QtQuick
import QtQuick.Layouts
import QtTest
import Shadcn

// Collapsible unit tests: default open/closed state, toggle() flipping the
// expanded flag, and the content panel's animated height (0 when collapsed,
// > 0 when expanded). Geometry is read from the rendered "content" slot after
// layout. Deterministic under QT_QPA_PLATFORM=offscreen.
Item {
    id: root
    width: 480
    height: 480

    Collapsible {
        id: closed
        width: 320
        trigger: Text { text: "Header A" }
        Text { Layout.fillWidth: true; text: "Collapsible content that gives the panel a real height." }
    }

    Collapsible {
        id: opened
        width: 320
        expanded: true
        trigger: Text { text: "Header B" }
        Text { Layout.fillWidth: true; text: "Already expanded content." }
    }

    TestCase {
        name: "Collapsible"
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
            compare(closed.expanded, false)
            compare(opened.expanded, true)
            compare(closed.gap, Theme.space2)
            // No background by default.
            compare(closed.background.a, 0)
            compare(closed.radius, 0)
        }

        // Content region: collapsed height is 0, expanded height is > 0.
        function test_content_height() {
            const closedContent = byName(closed, "content")
            const openedContent = byName(opened, "content")
            verify(closedContent !== null)
            verify(openedContent !== null)
            compare(closedContent.height, 0)
            tryVerify(function() { return openedContent.height > 0 })
        }

        // toggle() flips expanded and animates the panel open, then closed.
        function test_toggle() {
            const content = byName(closed, "content")
            verify(content !== null)
            compare(closed.expanded, false)
            compare(content.height, 0)

            closed.toggle()
            compare(closed.expanded, true)
            tryVerify(function() { return content.height > 0 })

            closed.toggle()
            compare(closed.expanded, false)
            tryCompare(content, "height", 0)
        }

        // Setting expanded directly drives the same animation.
        function test_expanded_property() {
            const content = byName(opened, "content")
            verify(content !== null)
            opened.expanded = false
            tryCompare(content, "height", 0)
            opened.expanded = true
            tryVerify(function() { return content.height > 0 })
        }
    }
}
