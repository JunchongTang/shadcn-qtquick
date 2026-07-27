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
    }
}
