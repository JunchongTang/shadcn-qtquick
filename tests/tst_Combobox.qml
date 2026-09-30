import QtQuick
import QtTest
import Shadcn

// Combobox unit tests: interface defaults / behavior (single-select toggle, multi-select toggle/remove, signals, clear) /
// model→row normalization / appearance (chips container padding symmetry, top padding == row spacing, regression guard).
// Appearance is verified by "reading child geometry after render + numeric comparison" (requires when: windowShown).
Item {
    id: root
    width: 420
    height: 640

    // —— Single-select instance ——
    Combobox {
        id: single
        width: 200
        model: [
            { value: "a", label: "Alpha" },
            { value: "b", label: "Beta" },
            { value: "c", label: "Gamma" }
        ]
    }

    // —— Grouped-model instance (tests _rows normalization) ——
    Combobox {
        id: grouped
        width: 220
        model: [
            { header: "G1" },
            "one", "two",
            { separator: true },
            { header: "G2" },
            "three"
        ]
    }

    // —— Multi-select instance (all 5 selected + narrow width → force wrapping, for the padding appearance test) ——
    Combobox {
        id: multi
        width: 200
        multiple: true
        model: ["Next.js", "SvelteKit", "Nuxt.js", "Remix", "Astro"]
        selectedValues: ["Next.js", "SvelteKit", "Nuxt.js", "Remix", "Astro"]
    }

    // —— Search-keyword instance: the label is not what the user types (a localized
    //    font family), so the canonical name has to be reachable through keywords ——
    Combobox {
        id: keyworded
        width: 220
        model: [
            { value: "PingFang SC", label: "苹方-简", keywords: ["PingFang SC", "苹方"] },
            { value: "Menlo", label: "Menlo", keywords: "Menlo Mono" },
            { value: "Alpha", label: "Alpha" }
        ]
    }

    // —— Custom label delegate instance ——
    Combobox {
        id: custom
        width: 220
        model: [
            { value: "b", label: "Beta", description: "second" },
            { value: "c", label: "Gamma" }
        ]
        // The gallery's cell delegates capture `parent` (the Loader) into a local
        // property; nested items cannot reach it directly.
        labelDelegate: Component {
            Item {
                id: customRoot
                implicitHeight: 40
                readonly property var slot: parent
                Text {
                    objectName: "cbCustomLabel"
                    text: customRoot.slot.label + "|" + customRoot.slot.value
                    font.family: "Courier"
                    font.pixelSize: 12
                }
                Text {
                    objectName: "cbCustomDesc"
                    anchors.top: parent.top
                    anchors.topMargin: 16
                    text: customRoot.slot.description
                    font.pixelSize: 11
                }
            }
        }
    }

    SignalSpy { id: singleSpy; target: single; signalName: "activated" }
    SignalSpy { id: multiSpy; target: multi; signalName: "activated" }

    TestCase {
        name: "Combobox"
        when: windowShown

        // Recursively find a visual child by objectName.
        function findByName(item, name) {
            if (!item)
                return null
            for (var i = 0; i < item.children.length; i++) {
                var c = item.children[i]
                if (c.objectName === name)
                    return c
                var f = findByName(c, name)
                if (f)
                    return f
            }
            return null
        }

        function init() {
            singleSpy.clear()
            multiSpy.clear()
        }

        // ---- Interface / defaults ----
        function test_defaults() {
            compare(single.multiple, false)
            compare(single.currentValue, "")
            compare(single.showClear, false)
            verify(single.placeholder.length > 0)      // already qsTr, non-empty default
            verify(single.emptyText.length > 0)
        }

        // ---- currentText derived from currentValue + model ----
        function test_currentText() {
            single.currentValue = "b"
            compare(single.currentText, "Beta")
            single.currentValue = "c"
            compare(single.currentText, "Gamma")
            single.currentValue = ""
            compare(single.currentText, "")
            single.currentValue = "nope"               // not in model
            compare(single.currentText, "")
            single.currentValue = ""
        }

        // ---- Single-select: select / reselect same value clears / activated signal ----
        function test_single_selectAndToggleClear() {
            single.currentValue = ""
            singleSpy.clear()
            single._choose("a")
            compare(single.currentValue, "a")
            compare(singleSpy.count, 1)
            compare(singleSpy.signalArguments[0][0], "a")
            single._choose("a")                        // reselect same value → clear
            compare(single.currentValue, "")
            compare(singleSpy.count, 2)
            compare(singleSpy.signalArguments[1][0], "")
            single.currentValue = ""
        }

        // ---- Multi-select: toggle add/remove, _remove, activated ----
        function test_multiple_toggleAndRemove() {
            multi.selectedValues = []
            multiSpy.clear()
            multi._choose("Remix")
            compare(multi.selectedValues.length, 1)
            compare(multi.selectedValues[0], "Remix")
            multi._choose("Astro")
            compare(multi.selectedValues.length, 2)
            multi._choose("Remix")                     // toggle again → remove
            compare(multi.selectedValues.length, 1)
            compare(multi.selectedValues[0], "Astro")
            multi._remove("Astro")
            compare(multi.selectedValues.length, 0)
            verify(multiSpy.count >= 4)
            // Restore to all-selected (for the appearance test)
            multi.selectedValues = ["Next.js", "SvelteKit", "Nuxt.js", "Remix", "Astro"]
        }

        // ---- model→_rows normalization: header appears only when it has matching items, no trailing separator ----
        function test_rows_normalization() {
            var rows = grouped._rows
            verify(rows.length > 0)
            // First row should be group header G1
            compare(rows[0].type, "header")
            compare(rows[0].label, "G1")
            // Should not end with a separator
            compare(rows[rows.length - 1].type, "item")
            // Count: two headers, one sep, three items
            var h = 0, s = 0, it = 0
            for (var i = 0; i < rows.length; i++) {
                if (rows[i].type === "header") h++
                else if (rows[i].type === "sep") s++
                else if (rows[i].type === "item") it++
            }
            compare(h, 2)
            compare(it, 3)
            compare(s, 1)
        }

        // ---- Keyboard highlight _step: down/up movement + wrap; from empty highlight, Down goes to first item, Up to last item ----
        function test_step_navigationAndWrap() {
            single._highlight = -1
            single._step(1)                            // Down from none → first item
            compare(single._highlight, 0)
            single._step(1)
            compare(single._highlight, 1)
            single._step(1)
            compare(single._highlight, 2)
            single._step(1)                            // wrap forward → first
            compare(single._highlight, 0)
            single._step(-1)                           // wrap backward → last
            compare(single._highlight, 2)
            single._highlight = -1
            single._step(-1)                           // Up from none → last item (fix: was off-by-one)
            compare(single._highlight, 2)
            single._highlight = -1
        }

        // ---- Keyboard highlight _step: skip non-item rows such as header / separator ----
        function test_step_skipsNonItems() {
            // grouped._rows: [header, item, item, sep, header, item]
            var rows = grouped._rows
            compare(rows[0].type, "header")
            grouped._highlight = -1
            grouped._step(1)                           // skip leading header → first item
            compare(rows[grouped._highlight].type, "item")
            verify(grouped._highlight >= 1)
            grouped._highlight = -1
            grouped._step(-1)                          // Up from none → last item
            compare(grouped._highlight, rows.length - 1)
            compare(rows[grouped._highlight].type, "item")
            grouped._highlight = -1
        }

        // ---- Appearance: multi-select chips container padding symmetric, and top padding == row spacing (reproduces the padding bug) ----
        function test_chips_padding_symmetry() {
            multi.selectedValues = ["Next.js", "SvelteKit", "Nuxt.js", "Remix", "Astro"]
            wait(0)                                     // let the layout polish

            var flow = findByName(multi, "cbChipsFlow")
            var trig = findByName(multi, "cbChipsTrigger")
            verify(flow !== null)
            verify(trig !== null)
            // Confirm it actually wrapped (otherwise this case is meaningless)
            verify(flow.height > 25)                    // single line is ~19, clearly taller after wrapping

            var topInset = flow.y
            var bottomInset = trig.height - (flow.y + flow.height)
            // Top/bottom symmetric
            verify(Math.abs(topInset - bottomInset) <= 1)
            // Key: top padding == row spacing (previously padding used space0_5=2 while spacing was space1=4, unequal → would fail)
            verify(Math.abs(topInset - flow.spacing) <= 1)
        }

        // ---- keywordsRole: an entry stays findable by a name that is not its label ----
        /*!
            The popup is a QObject, not an Item, so it lives in `data` rather than
            `children` — and its content is reparented to the window overlay, so the
            rows are not children of the Combobox either. Walking `data` reaches both.
        */
        function findObject(item, name) {
            if (!item || !item.data)
                return null
            for (var i = 0; i < item.data.length; i++) {
                var c = item.data[i]
                if (c.objectName === name)
                    return c
                var f = findObject(c, name)
                if (f)
                    return f
            }
            return null
        }

        /*!
            Find something inside one Combobox's *own* popup. Scoping matters: several
            instances in this file each build a list with the same objectName, and a
            search from the window root would just return whichever comes first.
        */
        function findInPopup(cb, name) {
            var popup = findObject(cb, "cbPopup")
            verify(popup !== null, "popup not found")
            return popup.contentItem ? findObject(popup.contentItem, name) : null
        }

        /*!
            Open a popup and type a query into the trigger.

            **不能靠 `input.forceActiveFocus()` 打开** —— offscreen 平台下窗口不是
            active,`activeFocus` 永远拿不到,那条 `onActiveFocusChanged` 分支不会跑。
            所以要拿到 Popup 直接 `open()`。

            **`opened` 要等入场动画跑完才变 true**(它是"完全打开",跟 `visible` 不是
            一回事),而过滤和 delegate 都挂在 `opened` 上 —— `_effQuery` 的第一句就是它。
            所以这里的等待必须用 `tryCompare` 轮询,`wait(0)` 不够。

            `_typed` 直接赋值而不是 `input.textEdited()`:后者是 C++ 信号,从测试里发不
            出来;而这个标志就是"用户在打字"这件事本身。
        */
        function type(cb, text) {
            var popup = findObject(cb, "cbPopup")
            verify(popup !== null, "popup not found")
            if (!popup.opened)
                popup.open()
            tryCompare(popup, "opened", true, 1000)
            var input = findByName(cb, "cbInput")
            verify(input !== null)
            cb._typed = true
            input.text = text
            wait(0)
        }

        function test_keywordsRoleMatchesKeywords() {
            type(keyworded, "pingfang")                 // a keyword array entry
            compare(keyworded._rows.length, 1)
            compare(keyworded._rows[0].value, "PingFang SC")

            type(keyworded, "苹方")                      // still the keyword array
            compare(keyworded._rows.length, 1)
            compare(keyworded._rows[0].value, "PingFang SC")

            type(keyworded, "mono")                     // a plain string keyword
            compare(keyworded._rows.length, 1)
            compare(keyworded._rows[0].value, "Menlo")

            type(keyworded, "alpha")                    // the label still matches
            compare(keyworded._rows.length, 1)
            compare(keyworded._rows[0].value, "Alpha")

            type(keyworded, "")                         // empty query shows everything
            compare(keyworded._rows.length, 3)
        }

        // ---- An entry without keywords keeps the old label-only behaviour ----
        function test_keywordsRoleIsOptional() {
            type(keyworded, "hiragana")                 // nowhere in any label or keyword
            compare(keyworded._rows.length, 0)
            type(keyworded, "")
        }

        // ---- labelDelegate replaces the row content and sees the row context ----
        function test_labelDelegateContext() {
            verify(custom.labelDelegate !== null)

            type(custom, "")
            wait(0)

            var lbl = findInPopup(custom, "cbCustomLabel")
            var desc = findInPopup(custom, "cbCustomDesc")
            verify(lbl !== null, "the custom label delegate was not built")
            verify(desc !== null, "the custom description delegate was not built")
            compare(lbl.text, "Beta|b")                 // parent.label + parent.value
            compare(desc.text, "second")                // parent.description
            compare(lbl.font.family, "Courier")         // the delegate owns the font
        }

        // ---- A delegate taller than the default row grows the row ----
        function test_labelDelegateDrivesRowHeight() {
            type(custom, "")
            wait(0)

            var list = findInPopup(custom, "cbList")
            verify(list !== null)
            verify(list.visible)
            var row = list.itemAtIndex(0)
            verify(row !== null, "no row was instantiated")
            compare(row.height, 40)                     // the delegate's implicitHeight
        }

        // ---- Without a delegate the default content still drives the height ----
        function test_defaultRowHeightUnchanged() {
            type(single, "")
            wait(0)

            var list = findInPopup(single, "cbList")
            verify(list !== null)
            var row = list.itemAtIndex(0)               // { value:"a", label:"Alpha" }
            verify(row !== null, "no row was instantiated")
            compare(row.height, 28)                     // no description → 28, as before
        }

        // ---- The control font reaches the trigger input (a host renders the trigger
        //      in a chosen font with this; the explicit pixelSize must survive) ----
        function test_fontPropagatesToTrigger() {
            var input = findByName(single, "cbInput")
            verify(input !== null)
            var wasFamily = single.font.family
            var wasPixelSize = input.font.pixelSize

            single.font.family = "Courier"
            compare(input.font.family, "Courier")
            compare(input.font.pixelSize, wasPixelSize)

            single.font.family = wasFamily
            compare(input.font.family, wasFamily)
        }
    }
}
