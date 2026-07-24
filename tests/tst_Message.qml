import QtQuick
import QtQuick.Layouts
import QtTest
import Shadcn

// Message family unit tests: row alignment/mirroring (incoming vs outgoing),
// avatar slot sizing/anchoring, content-column align inheritance, the drawn
// content bubble (padding/radius/background/border by variant), header/footer
// visibility and colors, and the hover actions group. Appearance is asserted by
// reading rendered geometry/colors after layout, so the tests stay deterministic
// under the offscreen platform.
Item {
    id: root
    width: 640
    height: 900

    // Recursively find a descendant by objectName (QML TestCase has no findChild).
    function byName(node, name) {
        if (!node)
            return null
        const kids = node.children
        for (let i = 0; i < kids.length; ++i) {
            const c = kids[i]
            if (c.objectName === name)
                return c
            const found = byName(c, name)
            if (found)
                return found
        }
        return null
    }

    // ---- Incoming row (Start): avatar + muted bubble + header ----
    Message {
        id: rowStart
        width: 400
        y: 0
        MessageAvatar { id: avStart; fallback: "R" }
        MessageContent {
            id: contentStart
            header: "Olivia"
            text: "I already checked the logs."
            variant: MessageContent.Muted
        }
    }

    // ---- Outgoing row (End): avatar + default bubble + footer text ----
    Message {
        id: rowEnd
        width: 400
        y: 120
        align: Message.End
        MessageAvatar { id: avEnd; fallback: "ME" }
        MessageContent {
            id: contentEnd
            text: "It's a one-line change."
            variant: MessageContent.Default
            footer: "Delivered"
        }
    }

    // ---- Ghost variant (no padding / radius) ----
    Message {
        id: rowGhost
        width: 400
        y: 240
        MessageContent {
            id: contentGhost
            text: "It's a one-line change."
            variant: MessageContent.Ghost
        }
    }

    // ---- Outline variant (border) ----
    Message {
        id: rowOutline
        width: 400
        y: 320
        MessageContent {
            id: contentOutline
            text: "Outline bubble"
            variant: MessageContent.Outline
        }
    }

    // ---- Destructive footer + hover actions (actionsOnHover) ----
    Message {
        id: rowActions
        width: 400
        y: 400
        MessageContent {
            id: contentActions
            text: "Okay drop me a link."
            variant: MessageContent.Default
            footer: "Failed to send"
            footerDestructive: true
            IconButton { iconName: "refresh-ccw"; variant: IconButton.Ghost; size: IconButton.Small }
        }
    }

    // ---- Actions always shown (actionsOnHover = false) ----
    Message {
        id: rowShown
        width: 400
        y: 500
        MessageContent {
            id: contentShown
            text: "Copy me"
            actionsOnHover: false
            IconButton { iconName: "copy"; variant: IconButton.Ghost; size: IconButton.Small }
        }
    }

    // ---- Empty avatar slot (spacer) ----
    Message {
        id: rowEmpty
        width: 400
        y: 600
        MessageAvatar { id: avEmpty }
        MessageContent { id: contentEmpty; text: "hi" }
    }

    // ---- Dynamic align flip row ----
    Message {
        id: rowFlip
        width: 400
        y: 700
        MessageContent { id: contentFlip; text: "flip me" }
    }

    TestCase {
        name: "Message"
        when: windowShown

        function test_defaults() {
            compare(rowStart.align, Message.Start)
            compare(rowStart.isMessageRow, true)
            compare(rowStart.layoutDirection, Qt.LeftToRight)
            compare(rowEnd.align, Message.End)
            compare(rowEnd.layoutDirection, Qt.RightToLeft)
        }

        // MessageContent inherits align from the ancestor Message.
        function test_align_inheritance() {
            compare(contentStart.align, Message.Start)
            compare(contentStart._end, false)
            compare(contentStart._side, Qt.AlignLeft)
            compare(contentEnd.align, Message.End)
            compare(contentEnd._end, true)
            compare(contentEnd._side, Qt.AlignRight)
        }

        // Align changes at runtime propagate to the content column.
        function test_align_reactive() {
            compare(contentFlip.align, Message.Start)
            rowFlip.align = Message.End
            tryCompare(contentFlip, "align", Message.End)
            compare(contentFlip._end, true)
            rowFlip.align = Message.Start
            tryCompare(contentFlip, "align", Message.Start)
        }

        // Avatar slot: fixed 32px (min-w-8), bottom aligned (self-end).
        function test_avatar_slot() {
            compare(avStart.implicitWidth, Theme.space8)
            compare(avStart.implicitHeight, Theme.space8)
            compare(avStart.Layout.alignment, Qt.AlignBottom)
            compare(avStart._empty, false)   // has fallback
            compare(avEmpty._empty, true)     // no source, no fallback -> spacer
        }

        // Row mirroring: incoming avatar sits left of content; outgoing right of it.
        function test_row_mirroring() {
            // Map avatar/content centers into the row's coordinate space.
            var aS = avStart.mapToItem(rowStart, avStart.width / 2, 0).x
            var cS = contentStart.mapToItem(rowStart, contentStart.width / 2, 0).x
            verify(aS < cS)                    // Start: avatar on the left
            var aE = avEnd.mapToItem(rowEnd, avEnd.width / 2, 0).x
            var cE = contentEnd.mapToItem(rowEnd, contentEnd.width / 2, 0).x
            verify(aE > cE)                    // End: avatar on the right
        }

        // Bubble padding + radius: muted keeps px-2.5/py-1.5 + rounded-lg; ghost drops both.
        function test_bubble_padding_radius() {
            var bMuted = byName(contentStart, "bubble")
            var bGhost = byName(contentGhost, "bubble")
            verify(bMuted !== null)
            verify(bGhost !== null)
            compare(bMuted.radius, Theme.radiusLg)
            compare(bGhost.radius, 0)
            // Same-ish text; ghost is smaller by 2x the horizontal/vertical padding.
            var tMuted = byName(contentStart, "bubbleText")
            var tGhost = byName(contentGhost, "bubbleText")
            fuzzyCompare(bMuted.implicitWidth - tMuted.width, 2 * Theme.space2_5, 0.5)
            fuzzyCompare(bGhost.implicitWidth - tGhost.width, 0, 0.5)
        }

        // Bubble background color per variant (light theme).
        function test_bubble_backgrounds() {
            tryCompare(byName(contentStart, "bubble"), "color", Theme.muted)
            tryCompare(byName(contentEnd, "bubble"), "color", Theme.primary)
            tryCompare(byName(contentOutline, "bubble"), "color", Theme.background)
            compare(byName(contentGhost, "bubble").color.a, 0)  // transparent
        }

        // Only the outline variant paints a 1px border.
        function test_bubble_border() {
            compare(byName(contentOutline, "bubble").border.width, 1)
            compare(byName(contentStart, "bubble").border.width, 0)
            compare(byName(contentEnd, "bubble").border.width, 0)
        }

        // Header is visible with text, left-aligned; hidden when empty.
        function test_header() {
            var hStart = byName(contentStart, "messageHeader")
            var hEnd = byName(contentEnd, "messageHeader")
            verify(hStart.visible)
            compare(hStart.text, "Olivia")
            compare(hStart.Layout.alignment, Qt.AlignLeft)
            compare(hEnd.visible, false)   // no header text
        }

        // Footer visible when it has status text or actions; text color muted vs destructive.
        function test_footer() {
            var fStart = byName(contentStart, "messageFooter")
            var fEnd = byName(contentEnd, "messageFooter")
            var fAct = byName(contentActions, "messageFooter")
            compare(fStart.visible, false)         // no footer text, no actions
            verify(fEnd.visible)                    // "Delivered"
            compare(fEnd.text, "Delivered")
            compare(fEnd.destructive, false)
            verify(fAct.visible)
            compare(fAct.destructive, true)
        }

        // Footer aligns to the same side as the bubble.
        function test_footer_alignment() {
            var fEnd = byName(contentEnd, "messageFooter")
            compare(fEnd.Layout.alignment, Qt.AlignRight)
        }

        // Hover actions: hidden (opacity 0) when actionsOnHover and not hovered;
        // fully shown when actionsOnHover is false.
        function test_actions_visibility() {
            var aHover = byName(contentActions, "messageActions")
            var aShown = byName(contentShown, "messageActions")
            verify(aHover !== null)
            verify(aShown !== null)
            // actionsOnHover=true and not hovered under offscreen -> shown false, opacity 0.
            compare(aHover.shown, false)
            tryCompare(aHover, "opacity", 0)
            // actionsOnHover=false -> always shown, opacity 1.
            compare(aShown.shown, true)
            tryCompare(aShown, "opacity", 1)
            // The routed IconButton lands inside the actions group.
            compare(aShown.children.length, 1)
        }
    }
}
