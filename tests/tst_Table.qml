import QtQuick
import QtTest
import Shadcn

// Table(TableView 版)单测:列定义 / 列宽计算(固定+fill+min/max)/ fill 兜底铺满 / 行数 / 选择。
// 外观类断言:渲染后读内部 _widths 数组做数值比对。
Item {
    id: root
    width: 760
    height: 400

    // 固定 + fill + 固定
    Table {
        id: t1
        width: 600
        columns: [
            { title: "A", key: "a", width: 150 },
            { title: "B", key: "b" },                    // 无 width → fill
            { title: "C", key: "c", width: 120 }
        ]
        model: [ { a: "1", b: "2", c: "3" }, { a: "4", b: "5", c: "6" } ]
    }

    // 全固定,和 < 表宽 → 末列兜底吸收
    Table {
        id: t2
        width: 500
        columns: [ { title: "A", key: "a", width: 100 }, { title: "B", key: "b", width: 120 } ]
        model: [ { a: "x", b: "y" } ]
    }

    // min/max 夹取
    Table {
        id: t3
        width: 600
        columns: [ { title: "A", key: "a", fillWidth: true, maxWidth: 200 }, { title: "B", key: "b", width: 100 } ]
        model: [ { a: "x", b: "y" } ]
    }

    // 声明式列(columnItems + TableColumn)—— 与 JS columns 等价。
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

    // 动态切列:columns 由属性驱动,运行时增减列。用于回归「派生列集合滞后」错位 bug。
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

        // 固定列保持;fill 列 = 剩余;总宽铺满。
        function test_widths_fixed_and_fill() {
            wait(0)
            compare(t1._widths[0], 150)
            compare(t1._widths[2], 120)
            verify(Math.abs(t1._widths[1] - (600 - 150 - 120)) <= 1)
            var sum = t1._widths[0] + t1._widths[1] + t1._widths[2]
            verify(Math.abs(sum - 600) <= 1)
        }

        // 无 fill 列也兜底铺满:末列吸收剩余,首列不变。
        function test_fill_safety_net() {
            wait(0)
            compare(t2._widths[0], 100)
            verify(t2._widths[1] >= 120)
            var sum = t2._widths[0] + t2._widths[1]
            verify(Math.abs(sum - 500) <= 1)
        }

        // maxWidth 夹取 fill 列;仍兜底铺满(末列 B 吸收超出部分)。
        function test_minmax_clamp() {
            wait(0)
            verify(t3._widths[0] <= 200 + 1)             // A 被 maxWidth 夹到 ≤200
            var sum = t3._widths[0] + t3._widths[1]
            verify(Math.abs(sum - 600) <= 1)
        }

        // JS 数组 → 内部 TableModel → 行数正确。
        function test_model_rows() {
            wait(0)
            compare(t1.view.rows, 2)
        }

        function test_selectedRows() {
            t1.selectedRows = [0, 1]
            compare(t1.selectedRows.length, 2)
        }

        // 声明式 columnItems 等价 JS columns:固定/fill 宽解析与行数一致。
        function test_declarative_columns() {
            wait(0)
            compare(t4.view.rows, 2)
            compare(t4._widths[0], 150)
            compare(t4._widths[2], 120)
            verify(Math.abs(t4._widths[1] - (600 - 150 - 120)) <= 1)
        }

        // 回归:动态切列后,内部模型列数 / _widths 长度必须与当前列集合同步(修复前会滞后一步 → 错位)。
        function test_dynamic_column_change() {
            wait(0)
            compare(t5.view.columns, 3)
            compare(t5._widths.length, 3)
            root.showMiddle = false                 // 去掉中间列 → 2 列
            wait(0)
            compare(t5.view.columns, 2)
            compare(t5._widths.length, 2)
            root.showMiddle = true                  // 再加回 → 3 列
            wait(0)
            compare(t5.view.columns, 3)
            compare(t5._widths.length, 3)
        }
    }
}
