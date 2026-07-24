import QtQuick
import QtTest
import Shadcn

// Card family unit tests. The card surface is the first child Rectangle of the
// Card Item, so its color / radius / border ARE the appearance and are asserted
// by reading them after render. Layout (padding, block gaps, header/footer
// stacking) is asserted from rendered geometry. Typography is read off the
// Text-derived CardTitle / CardDescription. Deterministic under offscreen
// (no animations); Theme.dark defaults to false so light-mode tokens apply.
Item {
    id: root
    width: 640
    height: 640

    // Default-size card with all three regions populated.
    Card {
        id: cardDefault
        width: 320
        CardHeader {
            id: header
            CardTitle { id: title; text: "Default Card" }
            CardDescription { id: desc; text: "This card uses the default size variant." }
        }
        CardContent {
            id: content
            Rectangle { id: contentChild; implicitWidth: 120; implicitHeight: 40; color: "#123456" }
        }
        CardFooter {
            id: footer
            Rectangle { id: footerA; implicitWidth: 60; implicitHeight: 30; color: "#aa0000" }
            Rectangle { id: footerB; implicitWidth: 40; implicitHeight: 30; color: "#00aa00" }
        }
    }

    // Small-size card: spacing derives from Card.Small.
    Card {
        id: cardSmall
        width: 320
        size: Card.Small
        CardContent {
            Rectangle { implicitWidth: 100; implicitHeight: 30; color: "#333333" }
        }
    }

    // Explicit cardSpacing override.
    Card {
        id: cardCustom
        width: 320
        cardSpacing: 24
        CardContent {
            Rectangle { implicitWidth: 100; implicitHeight: 30; color: "#444444" }
        }
    }

    // Edge-to-edge content: negative margins cancel the card inset.
    Card {
        id: cardEdge
        width: 320
        CardContent {
            id: edgeContent
            edgeToEdge: true
            Rectangle { implicitWidth: 100; implicitHeight: 30; color: "#555555" }
        }
    }

    TestCase {
        name: "Card"
        when: windowShown

        function surface(card) { return card.children[0] }

        // ---- Defaults & enum -------------------------------------------
        function test_defaults() {
            let c = Qt.createQmlObject("import Shadcn; Card {}", root)
            compare(c.size, Card.Default)
            compare(c.cardSpacing, Theme.space4)   // 16
            c.destroy()
        }

        function test_size_enum() {
            compare(Card.Default, 0)
            compare(Card.Small, 1)
        }

        // ---- Surface: bg-card, rounded-lg, ring-1 ----------------------
        function test_surface_colors() {
            let s = surface(cardDefault)
            compare(s.color, Theme.card)
            compare(s.radius, Theme.radiusLg)
            compare(s.border.width, Theme.overlayRingWidth)   // 1
            compare(s.border.color, Theme.overlayRing)
        }

        function test_surface_fills_card() {
            let s = surface(cardDefault)
            compare(s.width, cardDefault.width)
            compare(s.height, cardDefault.height)
        }

        // ---- Spacing derivation ----------------------------------------
        function test_spacing_default() {
            compare(cardDefault.cardSpacing, Theme.space4)   // 16
        }

        function test_spacing_small() {
            compare(cardSmall.cardSpacing, Theme.space3)     // 12
        }

        function test_spacing_custom() {
            compare(cardCustom.cardSpacing, 24)
        }

        // ---- Uniform padding: header sits inset by cardSpacing ---------
        function test_header_inset() {
            let p = header.mapToItem(cardDefault, 0, 0)
            fuzzyCompare(p.x, cardDefault.cardSpacing, 0.5)  // left px
            fuzzyCompare(p.y, cardDefault.cardSpacing, 0.5)  // top py
            // Header width fills between the two horizontal insets.
            fuzzyCompare(header.width, cardDefault.width - cardDefault.cardSpacing * 2, 0.5)
        }

        // ---- Header stacks title/description with gap-1 (4px) ----------
        function test_header_stacking() {
            compare(title.y, 0)
            fuzzyCompare(desc.y, title.height + Theme.space1, 0.5)
            verify(title.width > 0)
        }

        // ---- Vertical block gap between regions == cardSpacing ---------
        function test_block_gap() {
            let hBottom = header.mapToItem(cardDefault, 0, header.height).y
            let cTop = content.mapToItem(cardDefault, 0, 0).y
            fuzzyCompare(cTop - hBottom, cardDefault.cardSpacing, 0.5)
        }

        // ---- Content: inset by cardSpacing on the left by default ------
        // The Layout attached property cannot be read through an external
        // object reference, so assert the rendered result instead. (CardContent
        // sizes to its own content, so its left edge — not its width — carries
        // the inset.)
        function test_content_layout() {
            compare(content._inset, cardDefault.cardSpacing)  // reads parent margins
            let left = content.mapToItem(cardDefault, 0, 0).x
            fuzzyCompare(left, cardDefault.cardSpacing, 0.5)
            // Stays within the inset box (never wider than card minus both insets).
            verify(content.width <= cardDefault.width - cardDefault.cardSpacing * 2 + 0.5)
        }

        // ---- Edge-to-edge: negative margins cancel the left inset ------
        // Verified via the rendered position rather than the attached Layout
        // property (unreachable from here): edge-to-edge content starts at the
        // card's left edge (x≈0) instead of the default cardSpacing inset.
        function test_content_edge_to_edge() {
            compare(edgeContent.edgeToEdge, true)
            let left = edgeContent.mapToItem(cardEdge, 0, 0).x
            fuzzyCompare(left, 0, 0.5)
            // Contrast with the default (inset) content, which starts at cardSpacing.
            let insetLeft = content.mapToItem(cardDefault, 0, 0).x
            verify(left < insetLeft)
        }

        // ---- Footer: horizontal row with gap-2 (8px) -------------------
        function test_footer_layout() {
            verify(footerB.x > footerA.x)
            fuzzyCompare(footerB.x - (footerA.x + footerA.width), Theme.space2, 0.5)
        }

        // ---- Typography: title text-sm/medium, heading family ----------
        function test_title_typography() {
            compare(title.color, Theme.cardForeground)
            compare(title.font.pixelSize, Theme.textSm)   // 14
            compare(title.font.weight, Font.Medium)
            compare(title.font.family, Theme.fontHeading)
        }

        // ---- Typography: description muted, text-xs/relaxed ------------
        function test_description_typography() {
            compare(desc.color, Theme.mutedForeground)
            compare(desc.font.pixelSize, Theme.textXs)    // 12
            compare(desc.lineHeight, Theme.lineRelaxed)
            compare(desc.lineHeightMode, Text.ProportionalHeight)
        }
    }
}
