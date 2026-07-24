import QtQuick
import QtQuick.Layouts
import QtTest
import Shadcn

// Item family unit tests. ShadItem's background surface is its first child
// Rectangle (children[0]), so its color / radius / border ARE the appearance
// and are asserted after render. The inner ColumnLayout (children[1]) holds the
// header zone, main row and footer zone in that order; layout (padding, slot
// routing, ordering) is asserted from rendered geometry and reparenting.
// Typography is read off the Text-derived ItemDescription and the inner Text of
// ItemTitle. Enum values are locked. Deterministic under offscreen (no
// animations); Theme.dark defaults to false so light-mode tokens apply.
Item {
    id: root
    width: 800
    height: 900

    // Fully populated default item: header + media(icon) + content(title+desc)
    // + actions + footer. Exercises slot routing in every direction.
    ShadItem {
        id: full
        width: 360
        ItemHeader {
            id: fullHeader
            Rectangle { implicitWidth: 80; implicitHeight: 16; color: "#111111" }
        }
        ItemMedia { id: fullMedia; variant: ItemMedia.Icon; iconName: "inbox" }
        ItemContent {
            id: fullContent
            ItemTitle { id: fullTitle; text: "Title" }
            ItemDescription { id: fullDesc; text: "A description providing context." }
        }
        ItemActions {
            id: fullActions
            Rectangle { id: fullActionBtn; implicitWidth: 60; implicitHeight: 28; color: "#aa0000" }
        }
        ItemFooter {
            id: fullFooter
            Rectangle { implicitWidth: 80; implicitHeight: 16; color: "#222222" }
        }
    }

    // Variant surfaces.
    ShadItem { id: itemDefault; width: 320; ItemContent { ItemTitle { text: "d" } } }
    ShadItem { id: itemOutline; width: 320; variant: ShadItem.Outline; ItemContent { ItemTitle { text: "o" } } }
    ShadItem { id: itemMuted;   width: 320; variant: ShadItem.Muted;   ItemContent { ItemTitle { text: "m" } } }

    // Size presets.
    ShadItem { id: itemXs; width: 320; size: ShadItem.Xs; ItemContent { ItemTitle { text: "xs" } } }
    ShadItem { id: itemSm; width: 320; size: ShadItem.Sm; ItemContent { ItemTitle { text: "sm" } } }

    // Image media at default and xs host sizes.
    ShadItem {
        id: imgHost; width: 320
        ItemMedia { id: imgMedia; variant: ItemMedia.Image }
        ItemContent { ItemTitle { text: "img" } }
    }
    ShadItem {
        id: imgHostXs; width: 320; size: ShadItem.Xs
        ItemMedia { id: imgMediaXs; variant: ItemMedia.Image }
        ItemContent { ItemTitle { text: "img" } }
    }

    // Two content columns: the second must not stretch (flex-none).
    ShadItem {
        id: twoContent; width: 360
        ItemContent { id: contentA; ItemTitle { text: "a" } }
        ItemContent { id: contentB; ItemTitle { text: "b" } }
    }

    // Link item (interactive).
    ShadItem { id: linkItem; width: 320; asLink: true; ItemContent { ItemTitle { text: "link" } } }

    // Groups: spacing adapts to the smallest contained size, and a separator
    // sits between rows.
    ItemGroup {
        id: grpDefault; width: 320
        ShadItem { id: g1; ItemContent { ItemTitle { text: "1" } } }
        ItemSeparator { id: sep }
        ShadItem { id: g2; ItemContent { ItemTitle { text: "2" } } }
    }
    ItemGroup {
        id: grpSm; width: 320
        ShadItem { size: ShadItem.Sm; ItemContent { ItemTitle { text: "1" } } }
        ShadItem { ItemContent { ItemTitle { text: "2" } } }
    }
    ItemGroup {
        id: grpXs; width: 320
        ShadItem { size: ShadItem.Xs; ItemContent { ItemTitle { text: "1" } } }
        ShadItem { size: ShadItem.Sm; ItemContent { ItemTitle { text: "2" } } }
    }

    TestCase {
        name: "Item"
        when: windowShown

        // Internal structure: surface Rectangle then the inner ColumnLayout,
        // whose children are [headerZone, mainRow, footerZone].
        function surface(it)    { return it.children[0] }
        function layoutCol(it)  { return it.children[1] }
        function headerZone(it) { return layoutCol(it).children[0] }
        function mainRow(it)    { return layoutCol(it).children[1] }
        function footerZone(it) { return layoutCol(it).children[2] }

        // ---- Enum values are locked ------------------------------------
        function test_variant_enum() {
            compare(ShadItem.Default, 0)
            compare(ShadItem.Outline, 1)
            compare(ShadItem.Muted, 2)
        }

        function test_size_enum() {
            // Size.Default shares value 0 with Variant.Default (kept first on
            // purpose so the shared 0 stays unambiguous); Sm/Xs are 1/2.
            compare(ShadItem.Sm, 1)
            compare(ShadItem.Xs, 2)
        }

        function test_media_variant_enum() {
            compare(ItemMedia.Default, 0)
            compare(ItemMedia.Icon, 1)
            compare(ItemMedia.Image, 2)
        }

        // ---- Defaults --------------------------------------------------
        function test_defaults() {
            let it = Qt.createQmlObject("import Shadcn; ShadItem {}", root)
            compare(it.variant, ShadItem.Default)
            compare(it.size, ShadItem.Default)
            compare(it.asLink, false)
            compare(it.itemSlot, "item")
            it.destroy()

            let m = Qt.createQmlObject("import Shadcn; ItemMedia {}", root)
            compare(m.variant, ItemMedia.Default)
            compare(m.iconName, "")
            compare(m.hostSize, 0)
            compare(m.topShift, false)
            m.destroy()

            let c = Qt.createQmlObject("import Shadcn; ItemContent {}", root)
            compare(c.contentFill, true)
            compare(c.hasDescription, false)
            c.destroy()
        }

        // ---- Slot tags -------------------------------------------------
        function test_slot_tags() {
            compare(fullMedia.itemSlot, "item-media")
            compare(fullContent.itemSlot, "item-content")
            compare(fullActions.itemSlot, "item-actions")
            compare(fullHeader.itemSlot, "item-header")
            compare(fullFooter.itemSlot, "item-footer")
            compare(fullTitle.itemSlot, "item-title")
            compare(fullDesc.itemSlot, "item-description")
            compare(sep.itemSlot, "item-separator")
            compare(grpDefault.itemSlot, "item-group")
        }

        // ---- Surface: default is transparent, no border, rounded-md ----
        function test_surface_default() {
            let s = surface(itemDefault)
            compare(s.radius, Theme.radiusMd)
            compare(s.border.width, 0)
            compare(s.color, Qt.color("transparent"))
        }

        // ---- Surface: outline draws a 1px border in the border token ---
        function test_surface_outline() {
            let s = surface(itemOutline)
            compare(s.border.width, 1)
            compare(s.border.color, Theme.border)
            compare(s.color, Qt.color("transparent"))
        }

        // ---- Surface: muted paints bg-muted/50, no border --------------
        function test_surface_muted() {
            let s = surface(itemMuted)
            compare(s.border.width, 0)
            compare(s.color, Theme.alpha(Theme.muted, 0.5))
        }

        // ---- Padding: default px-3 (12) / py-2.5 (10) ------------------
        function test_padding_default() {
            compare(itemDefault._padH, Theme.space3)     // 12
            compare(itemDefault._padV, Theme.space2_5)   // 10
            compare(itemDefault._gap, Theme.space2_5)    // gap-2.5
            let col = layoutCol(itemDefault)
            let p = col.mapToItem(itemDefault, 0, 0)
            fuzzyCompare(p.x, Theme.space3, 0.5)
            fuzzyCompare(p.y, Theme.space2_5, 0.5)
        }

        // ---- Padding: sm matches default in base-mira ------------------
        function test_padding_sm() {
            compare(itemSm._padH, Theme.space3)
            compare(itemSm._padV, Theme.space2_5)
        }

        // ---- Padding: xs px-2.5 (10) / py-2 (8) ------------------------
        function test_padding_xs() {
            compare(itemXs._padH, Theme.space2_5)   // 10
            compare(itemXs._padV, Theme.space2)     // 8
        }

        // ---- Header/footer are migrated out of the main row -----------
        function test_slot_routing() {
            compare(fullMedia.parent, mainRow(full))
            compare(fullContent.parent, mainRow(full))
            compare(fullActions.parent, mainRow(full))
            compare(fullHeader.parent, headerZone(full))
            compare(fullFooter.parent, footerZone(full))
        }

        // ---- Header sits above and footer below the main row ----------
        function test_zone_stacking() {
            let hy = fullHeader.mapToItem(full, 0, 0).y
            let my = fullMedia.mapToItem(full, 0, 0).y
            let fy = fullFooter.mapToItem(full, 0, 0).y
            verify(hy < my)
            verify(fy > my)
        }

        // ---- Main row ordering: media | content | actions -------------
        function test_main_row_order() {
            let mx = fullMedia.mapToItem(full, 0, 0).x
            let cx = fullContent.mapToItem(full, 0, 0).x
            let ax = fullActions.mapToItem(full, 0, 0).x
            verify(mx < cx)
            verify(cx < ax)
            // Content stretches, pushing actions to the right edge.
            let aRight = ax + fullActions.width
            verify(aRight > full.width * 0.6)
        }

        // ---- Host size + description flags are injected into children --
        function test_child_injection() {
            compare(fullMedia.hostSize, ShadItem.Default)
            compare(fullContent.hasDescription, true)
            compare(fullMedia.topShift, true)     // top-align beside a description
        }

        // ---- Media icon renders at size-4 (16) ------------------------
        function test_media_icon_size() {
            compare(fullMedia.implicitWidth, 16)
            compare(fullMedia.implicitHeight, 16)
        }

        // ---- Media image box: size-8 (32) default, size-6 (24) at xs --
        function test_media_image_box() {
            compare(imgMedia.hostSize, ShadItem.Default)
            compare(imgMedia.implicitWidth, 32)
            compare(imgMedia.implicitHeight, 32)
            compare(imgMediaXs.hostSize, ShadItem.Xs)
            compare(imgMediaXs.implicitWidth, 24)
            // No description here, so media stays vertically centred.
            compare(imgMedia.topShift, false)
            let box = imgMedia.children[0]     // rounded clipping Rectangle
            compare(box.radius, Theme.radiusSm)
            compare(box.width, 32)
        }

        // ---- Second content column does not stretch -------------------
        function test_second_content_flex_none() {
            compare(contentA.contentFill, true)
            compare(contentB.contentFill, false)
        }

        // ---- Content inner gap: gap-1 (4) default, gap-0.5 (2) at xs --
        function test_content_gap() {
            compare(fullContent.spacing, 4)
            let xsContent = Qt.createQmlObject(
                "import Shadcn; ItemContent { hostSize: 2 }", root)
            compare(xsContent.spacing, 2)
            xsContent.destroy()
        }

        // ---- Title typography: text-xs, medium weight -----------------
        function test_title_typography() {
            let label = fullTitle.children[0]    // built-in Text
            compare(label.text, "Title")
            compare(label.font.pixelSize, Theme.textXs)   // 12
            compare(label.font.weight, Font.Medium)
            compare(label.elide, Text.ElideRight)         // line-clamp-1
        }

        // ---- Description typography: muted, text-xs/relaxed, clamp-2 --
        function test_description_typography() {
            compare(fullDesc.color, Theme.mutedForeground)
            compare(fullDesc.font.pixelSize, Theme.textXs)      // 12
            compare(fullDesc.lineHeight, Theme.lineRelaxed)     // 1.625
            compare(fullDesc.lineHeightMode, Text.ProportionalHeight)
            compare(fullDesc.maximumLineCount, 2)               // line-clamp-2
            compare(fullDesc.font.weight, Font.Normal)
        }

        // ---- Link item is focusable and clickable ---------------------
        function test_link_item() {
            compare(linkItem.asLink, true)
            compare(linkItem.activeFocusOnTab, true)
            let fired = 0
            linkItem.clicked.connect(function() { fired++ })
            linkItem.clicked()
            compare(fired, 1)
        }

        // ---- Separator geometry: 1px line + my-2 (8px each side) ------
        function test_separator() {
            compare(sep.implicitHeight, 1 + Theme.space2 * 2)   // 17
        }

        // ---- Group spacing adapts to the smallest contained size ------
        function test_group_spacing() {
            compare(grpDefault.spacing, 16)   // gap-4
            compare(grpSm.spacing, 10)        // gap-2.5
            compare(grpXs.spacing, 8)         // gap-2
        }
    }
}
