import QtQuick
import QtTest
import Shadcn

// Typography unit tests: for each of the 13 prose types, lock the key
// typographic properties (pixelSize / weight / color) against the base-mira
// reference, plus a few structural checks (blockquote left border,
// inline-code background + radius, list bullets, table borders + zebra row).
//
// Wrapper types (H2, Blockquote, InlineCode, List, Table) expose only text /
// items / rows, so their inner Text and Rectangle children are reached by
// recursive traversal. Everything is read after render and is deterministic
// under the offscreen platform. Theme.dark defaults to false, so the
// light-mode tokens apply.
Item {
    id: root
    width: 480
    height: 640

    TypographyH1 { id: h1; text: "H1" }
    TypographyH2 { id: h2; width: 400; text: "H2" }
    TypographyH3 { id: h3; text: "H3" }
    TypographyH4 { id: h4; text: "H4" }
    TypographyP { id: p; text: "Paragraph" }
    TypographyBlockquote { id: bq; width: 400; text: "Quote" }
    TypographyInlineCode { id: code; text: "npm i" }
    TypographyLarge { id: large; text: "Large" }
    TypographyLead { id: lead; text: "Lead" }
    TypographyMuted { id: muted; text: "Muted" }
    TypographySmall { id: small; text: "Small" }
    TypographyList { id: list; width: 400; items: ["a", "b", "c"] }
    TypographyTable {
        id: table
        width: 400
        headers: ["H0", "H1"]
        rows: [["r0c0", "r0c1"], ["r1c0", "r1c1"], ["r2c0", "r2c1"]]
    }

    TestCase {
        name: "Typography"
        when: windowShown

        // --- traversal helpers -------------------------------------------

        // Collect every Text descendant (Text has both .font and string .text).
        function allTexts(item, acc) {
            acc = acc || []
            var kids = item.children
            if (!kids)
                return acc
            for (var i = 0; i < kids.length; i++) {
                var c = kids[i]
                if (c.font !== undefined && typeof c.text === "string")
                    acc.push(c)
                allTexts(c, acc)
            }
            return acc
        }

        // Collect every Rectangle descendant (Rectangle has a .border grouped
        // property; Text and layout items do not).
        function allRects(item, acc) {
            acc = acc || []
            var kids = item.children
            if (!kids)
                return acc
            for (var i = 0; i < kids.length; i++) {
                var c = kids[i]
                if (c.border !== undefined && c.radius !== undefined)
                    acc.push(c)
                allRects(c, acc)
            }
            return acc
        }

        function firstText(item) {
            var all = allTexts(item)
            verify(all.length > 0)
            return all[0]
        }

        // --- per-type typography -----------------------------------------

        function test_h1() {
            compare(h1.font.pixelSize, 36)            // text-4xl
            compare(h1.font.weight, Font.ExtraBold)   // font-extrabold
            // letterSpacing round-trips through single-precision storage, so
            // -0.9 (not exactly representable) needs a fuzzy compare.
            fuzzyCompare(h1.font.letterSpacing, -0.9, 0.02) // tracking-tight
            compare(h1.color, Theme.foreground)
        }

        function test_h2() {
            var label = firstText(h2)
            compare(label.font.pixelSize, 30)         // text-3xl
            compare(label.font.weight, Font.DemiBold) // font-semibold
            fuzzyCompare(label.font.letterSpacing, -0.75, 0.02)
            compare(label.color, Theme.foreground)
        }

        function test_h3() {
            compare(h3.font.pixelSize, 24)            // text-2xl
            compare(h3.font.weight, Font.DemiBold)
            fuzzyCompare(h3.font.letterSpacing, -0.6, 0.02)
            compare(h3.color, Theme.foreground)
        }

        function test_h4() {
            compare(h4.font.pixelSize, 20)            // text-xl
            compare(h4.font.weight, Font.DemiBold)
            fuzzyCompare(h4.font.letterSpacing, -0.5, 0.02)
            compare(h4.color, Theme.foreground)
        }

        function test_p() {
            compare(p.font.pixelSize, Theme.textBase) // text-base (16)
            compare(p.font.weight, Font.Normal)
            compare(p.lineHeight, 1.75)               // leading-7
            compare(p.color, Theme.foreground)
        }

        function test_large() {
            compare(large.font.pixelSize, Theme.textLg) // text-lg (18)
            compare(large.font.weight, Font.DemiBold)   // font-semibold
            compare(large.color, Theme.foreground)
        }

        function test_lead() {
            compare(lead.font.pixelSize, 20)            // text-xl
            compare(lead.font.weight, Font.Normal)
            compare(lead.color, Theme.mutedForeground)  // text-muted-foreground
        }

        function test_muted() {
            compare(muted.font.pixelSize, Theme.textSm) // text-sm (14)
            compare(muted.font.weight, Font.Normal)
            compare(muted.color, Theme.mutedForeground)
        }

        function test_small() {
            compare(small.font.pixelSize, Theme.textSm) // text-sm (14)
            compare(small.font.weight, Font.Medium)     // font-medium
            compare(small.lineHeight, 1.0)              // leading-none
            compare(small.color, Theme.foreground)
        }

        function test_inline_code_typography() {
            var t = firstText(code)
            compare(t.font.family, Theme.fontMono)      // font-mono
            compare(t.font.pixelSize, Theme.textSm)     // text-sm (14)
            compare(t.font.weight, Font.DemiBold)       // font-semibold
            compare(t.color, Theme.foreground)
        }

        // --- structural checks -------------------------------------------

        // Blockquote: 2px left border in the border token, full height.
        function test_blockquote_border() {
            var rects = allRects(bq)
            compare(rects.length, 1)
            var rule = rects[0]
            compare(rule.width, 2)                      // border-l-2
            compare(rule.color, Theme.border)
            compare(rule.height, bq.height)             // spans full height
        }

        // Inline code: muted rounded pill (bg-muted, rounded = 4px).
        function test_inline_code_chip() {
            compare(code.color, Theme.muted)            // bg-muted
            compare(code.radius, 4)                     // rounded
        }

        // List: one solid bullet per item, at the base text size.
        function test_list_bullets() {
            var bullets = allTexts(list).filter(function (t) { return t.text === "•" })
            compare(bullets.length, 3)                  // one per item
            compare(bullets[0].font.pixelSize, Theme.textBase)
            compare(bullets[0].color, Theme.foreground)
        }

        // Table: every cell has a 1px border in the border token, and only the
        // second body row (index 1) is shaded with the muted token.
        function test_table_borders_and_zebra() {
            var cells = allRects(table)
            // 2 header + 3 rows x 2 = 8 cells.
            compare(cells.length, 8)
            for (var i = 0; i < cells.length; i++) {
                compare(cells[i].border.width, 1)       // border
                compare(cells[i].border.color, Theme.border)
            }
            var mutedCount = 0
            var otherCount = 0
            for (var j = 0; j < cells.length; j++) {
                if (Qt.colorEqual(cells[j].color, Theme.muted))
                    mutedCount++
                else
                    otherCount++
            }
            compare(mutedCount, 2)                      // even:bg-muted -> body row index 1 (2 cells)
            compare(otherCount, 6)                      // header + rows 0 & 2 stay transparent
        }

        // Header cells are bold; body cells are not.
        function test_table_header_bold() {
            var texts = allTexts(table)
            var bold = texts.filter(function (t) { return t.font.weight === Font.Bold })
            compare(bold.length, 2)                     // th font-bold, one per header column
        }
    }
}
