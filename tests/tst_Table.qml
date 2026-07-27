import QtQuick
import QtTest
import Shadcn

// Table (TableView version) unit tests: column definitions / column-width computation (fixed+fill+min/max) / fill safety-net filling / row count / selection.
// Appearance assertions: read the internal _widths array after render for numeric comparison.
Item {
    id: root
    width: 760
    height: 400

    // fixed + fill + fixed
    Table {
        id: t1
        width: 600
        columns: [
            { title: "A", key: "a", width: 150 },
            { title: "B", key: "b" },                    // no width → fill
            { title: "C", key: "c", width: 120 }
        ]
        model: [ { a: "1", b: "2", c: "3" }, { a: "4", b: "5", c: "6" } ]
    }

    // all fixed, sum < table width → last column absorbs the remainder as a safety net
    Table {
        id: t2
        width: 500
        columns: [ { title: "A", key: "a", width: 100 }, { title: "B", key: "b", width: 120 } ]
        model: [ { a: "x", b: "y" } ]
    }

    // min/max clamping
    Table {
        id: t3
        width: 600
        columns: [ { title: "A", key: "a", fillWidth: true, maxWidth: 200 }, { title: "B", key: "b", width: 100 } ]
        model: [ { a: "x", b: "y" } ]
    }

    // Declarative columns (columnItems + TableColumn) — equivalent to JS columns.
    Table {
        id: t4
        width: 600
        columnItems: [
            TableColumn { title: "A"; key: "a"; width: 150 },
            TableColumn { title: "B"; key: "b" },
            TableColumn { title: "C"; key: "c"; width: 120 }
        ]
        model: [ { a: "1", b: "2", c: "3" }, { a: "4", b: "5", c: "6" } ]
    }

    // Dynamic column switching: columns driven by a property, adding/removing columns at runtime. Regression test for the "derived column set lags" misalignment bug.
    property bool showMiddle: true
    Table {
        id: t5
        width: 600
        columns: {
            var c = [ { title: "A", key: "a", width: 100 } ]
            if (root.showMiddle) c.push({ title: "B", key: "b", width: 100 })
            c.push({ title: "C", key: "c", width: 100 })
            return c
        }
        model: [ { a: "1", b: "2", c: "3" } ]
    }

    TestCase {
        name: "Table"
        when: windowShown

        function test_columns_defaults() {
            compare(t1.columns.length, 3)
            compare(t1.rowHeight, 40)
        }

        // fixed columns preserved; fill column = remainder; total width fills.
        function test_widths_fixed_and_fill() {
            wait(0)
            compare(t1._widths[0], 150)
            compare(t1._widths[2], 120)
            verify(Math.abs(t1._widths[1] - (600 - 150 - 120)) <= 1)
            var sum = t1._widths[0] + t1._widths[1] + t1._widths[2]
            verify(Math.abs(sum - 600) <= 1)
        }

        // even with no fill column it fills as a safety net: last column absorbs the remainder, first column unchanged.
        function test_fill_safety_net() {
            wait(0)
            compare(t2._widths[0], 100)
            verify(t2._widths[1] >= 120)
            var sum = t2._widths[0] + t2._widths[1]
            verify(Math.abs(sum - 500) <= 1)
        }

        // maxWidth clamps the fill column; still fills as a safety net (last column B absorbs the excess).
        function test_minmax_clamp() {
            wait(0)
            verify(t3._widths[0] <= 200 + 1)             // A clamped by maxWidth to ≤200
            var sum = t3._widths[0] + t3._widths[1]
            verify(Math.abs(sum - 600) <= 1)
        }

        // JS array → internal TableModel → correct row count.
        function test_model_rows() {
            wait(0)
            compare(t1.view.rows, 2)
        }

        function test_selectedRows() {
            t1.selectedRows = [0, 1]
            compare(t1.selectedRows.length, 2)
        }

        // Declarative columnItems equivalent to JS columns: fixed/fill width resolution and row count match.
        function test_declarative_columns() {
            wait(0)
            compare(t4.view.rows, 2)
            compare(t4._widths[0], 150)
            compare(t4._widths[2], 120)
            verify(Math.abs(t4._widths[1] - (600 - 150 - 120)) <= 1)
        }

        // Regression: after dynamic column switching, the internal model column count / _widths length must stay in sync with the current column set (before the fix it lagged by one step → misalignment).
        function test_dynamic_column_change() {
            wait(0)
            compare(t5.view.columns, 3)
            compare(t5._widths.length, 3)
            root.showMiddle = false                 // remove the middle column → 2 columns
            wait(0)
            compare(t5.view.columns, 2)
            compare(t5._widths.length, 2)
            root.showMiddle = true                  // add it back → 3 columns
            wait(0)
            compare(t5.view.columns, 3)
            compare(t5._widths.length, 3)
        }
    }
}
