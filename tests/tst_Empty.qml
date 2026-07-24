import QtQuick
import QtQuick.Layouts
import QtTest
import Shadcn

// Empty family unit tests. Empty is a Rectangle whose color/radius ARE the
// surface appearance and are read after render. The declared children live in
// Empty's internal centered ColumnLayout (default alias -> inner.data), so
// padding (p-6), block gap (gap-4), header gap (gap-1 + media mb-2) and content
// gap (gap-2) are asserted from rendered geometry. Typography is read off the
// Text-derived EmptyTitle / EmptyDescription, and EmptyMedia's icon chip is read
// off its backing Rectangle. Deterministic under offscreen (no animations);
// Theme.dark defaults to false so light-mode tokens apply.
Item {
    id: root
    width: 640
    height: 640

    // Fully populated empty state, content-sized (no explicit width/height) so
    // the p-6 padding shows up as the inner column's centered inset.
    Empty {
        id: empty
        surface: "#123456"

        EmptyHeader {
            id: header
            EmptyMedia {
                id: media
                variant: EmptyMedia.Icon
                iconName: "folder"
            }
            EmptyTitle { id: title; text: "No projects yet" }
            EmptyDescription { id: desc; text: "You have not created any projects yet." }
        }
        EmptyContent {
            id: content
            Rectangle { id: actionA; implicitWidth: 120; implicitHeight: 32; color: "#aa0000"; Layout.alignment: Qt.AlignHCenter }
            Rectangle { id: actionB; implicitWidth: 120; implicitHeight: 32; color: "#00aa00"; Layout.alignment: Qt.AlignHCenter }
        }
    }

    // Outlined empty (dashed frame on).
    Empty {
        id: emptyOutline
        outline: true
        EmptyHeader { EmptyTitle { text: "Bordered" } }
    }

    // Standalone default-variant media sized to its content.
    EmptyMedia {
        id: mediaDefault
        Rectangle { implicitWidth: 48; implicitHeight: 48; color: "#333333" }
    }

    TestCase {
        name: "Empty"
        when: windowShown

        // Empty's internal centered ColumnLayout: Canvas is children[0], the
        // inner column is children[1].
        function innerCol(e) { return e.children[1] }
        function canvas(e) { return e.children[0] }

        // ---- Enum ------------------------------------------------------
        function test_media_variant_enum() {
            compare(EmptyMedia.Default, 0)
            compare(EmptyMedia.Icon, 1)
        }

        // ---- Defaults --------------------------------------------------
        function test_defaults() {
            let e = Qt.createQmlObject("import Shadcn; Empty {}", root)
            compare(e.outline, false)
            compare(e.surface, Qt.color("transparent"))
            compare(e.radius, Theme.radiusXl)      // rounded-xl = 14
            e.destroy()

            let h = Qt.createQmlObject("import Shadcn; EmptyHeader {}", root)
            compare(h.maxWidth, 384)               // max-w-sm
            h.destroy()

            let c = Qt.createQmlObject("import Shadcn; EmptyContent {}", root)
            compare(c.maxWidth, 384)
            c.destroy()

            let m = Qt.createQmlObject("import Shadcn; EmptyMedia {}", root)
            compare(m.variant, EmptyMedia.Default)
            compare(m.iconName, "")
            m.destroy()
        }

        // ---- Surface: color + rounded-xl -------------------------------
        function test_surface() {
            compare(empty.color, Qt.color("#123456"))
            compare(empty.radius, Theme.radiusXl)
        }

        // ---- Dashed frame follows outline ------------------------------
        function test_outline_canvas() {
            compare(canvas(empty).visible, false)          // surface only, no frame
            compare(canvas(emptyOutline).visible, true)    // dashed border on
        }

        // ---- Padding: inner column inset by p-6 (24) on all sides ------
        function test_padding_p6() {
            let col = innerCol(empty)
            let p = col.mapToItem(empty, 0, 0)
            fuzzyCompare(p.x, Theme.space6, 0.5)   // 24
            fuzzyCompare(p.y, Theme.space6, 0.5)
            // implicit size = inner + p-6 on both axes.
            fuzzyCompare(empty.width, col.width + Theme.space6 * 2, 0.5)
            fuzzyCompare(empty.height, col.height + Theme.space6 * 2, 0.5)
        }

        // ---- Block gap between header and content == gap-4 (16) --------
        function test_block_gap4() {
            let col = innerCol(empty)
            let hBottom = header.mapToItem(col, 0, header.height).y
            let cTop = content.mapToItem(col, 0, 0).y
            fuzzyCompare(cTop - hBottom, Theme.space4, 0.5)   // 16
        }

        // ---- Header: media -> title gap = mb-2 + gap-1 (12); ----------
        // ---- title -> description gap = gap-1 (4) ---------------------
        function test_header_gaps() {
            fuzzyCompare(title.y - (media.y + media.height),
                         Theme.space2 + Theme.space1, 0.5)    // 8 + 4 = 12
            fuzzyCompare(desc.y - (title.y + title.height), Theme.space1, 0.5)  // 4
        }

        // ---- Content: children stack with gap-2 (8) --------------------
        function test_content_gap2() {
            verify(actionB.y > actionA.y)
            fuzzyCompare(actionB.y - (actionA.y + actionA.height), Theme.space2, 0.5)  // 8
        }

        // ---- Header/content constrained to max-w-sm (384) --------------
        function test_max_width() {
            fuzzyCompare(header.width, 384, 0.5)
            fuzzyCompare(content.width, 384, 0.5)
        }

        // ---- Content is horizontally centered within the column --------
        function test_centered() {
            let col = innerCol(empty)
            let headerLeft = header.mapToItem(col, 0, 0).x
            let headerRight = col.width - (headerLeft + header.width)
            fuzzyCompare(headerLeft, headerRight, 1.0)
            compare(title.horizontalAlignment, Text.AlignHCenter)
            compare(desc.horizontalAlignment, Text.AlignHCenter)
        }

        // ---- Title typography: heading, text-sm, medium, tight --------
        function test_title_typography() {
            compare(title.color, Theme.foreground)
            compare(title.font.family, Theme.fontHeading)
            compare(title.font.pixelSize, Theme.textSm)     // 14
            compare(title.font.weight, Font.Medium)
            fuzzyCompare(title.font.letterSpacing, -0.35, 0.01)   // tracking-tight; tolerate float round-trip
        }

        // ---- Description typography: muted, text-xs/relaxed -----------
        function test_description_typography() {
            compare(desc.color, Theme.mutedForeground)
            compare(desc.font.pixelSize, Theme.textXs)      // 12
            compare(desc.lineHeight, Theme.lineRelaxed)     // 1.625
            compare(desc.lineHeightMode, Text.ProportionalHeight)
        }

        // ---- Icon media chip: size-8, rounded-md, bg-muted ------------
        function test_media_icon_chip() {
            compare(media.implicitWidth, 32)                // size-8
            compare(media.implicitHeight, 32)
            let chip = media.children[0]                    // backing Rectangle
            compare(chip.visible, true)
            compare(chip.radius, Theme.radiusMd)            // 8
            compare(chip.color, Theme.muted)
            compare(chip.width, 32)
            compare(chip.height, 32)
        }

        // ---- Default media sizes to its content -----------------------
        function test_media_default_size() {
            compare(mediaDefault.variant, EmptyMedia.Default)
            fuzzyCompare(mediaDefault.implicitWidth, 48, 0.5)
            fuzzyCompare(mediaDefault.implicitHeight, 48, 0.5)
            let chip = mediaDefault.children[0]             // chip hidden for default
            compare(chip.visible, false)
        }
    }
}
