import QtQuick
import QtTest
import Shadcn

// Combobox 单元测试:接口默认值 / 行为(单选切换、多选切换/移除、信号、清除)/
// 模型→行归一化 / 外观(chips 容器内边距对称、上留白==行间距,防复发)。
// 外观用「渲染后读子项几何 + 数值比对」来校验(需 when: windowShown)。
Item {
    id: root
    width: 420
    height: 640

    // —— 单选实例 ——
    Combobox {
        id: single
        width: 200
        model: [
            { value: "a", label: "Alpha" },
            { value: "b", label: "Beta" },
            { value: "c", label: "Gamma" }
        ]
    }

    // —— 分组模型实例(测 _rows 归一化)——
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

    // —— 多选实例(全选 5 项 + 窄宽度 → 强制换行,用于内边距外观测试)——
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

        // 递归按 objectName 找可视子项。
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

        // ---- 接口 / 默认值 ----
        function test_defaults() {
            compare(single.multiple, false)
            compare(single.currentValue, "")
            compare(single.showClear, false)
            verify(single.placeholder.length > 0)      // 已 qsTr,非空默认
            verify(single.emptyText.length > 0)
        }

        // ---- currentText 由 currentValue + model 推导 ----
        function test_currentText() {
            single.currentValue = "b"
            compare(single.currentText, "Beta")
            single.currentValue = "c"
            compare(single.currentText, "Gamma")
            single.currentValue = ""
            compare(single.currentText, "")
            single.currentValue = "nope"               // 不在 model 中
            compare(single.currentText, "")
            single.currentValue = ""
        }

        // ---- 单选:选择 / 再选同值清空 / activated 信号 ----
        function test_single_selectAndToggleClear() {
            single.currentValue = ""
            singleSpy.clear()
            single._choose("a")
            compare(single.currentValue, "a")
            compare(singleSpy.count, 1)
            compare(singleSpy.signalArguments[0][0], "a")
            single._choose("a")                        // 再选同值 → 清空
            compare(single.currentValue, "")
            compare(singleSpy.count, 2)
            compare(singleSpy.signalArguments[1][0], "")
            single.currentValue = ""
        }

        // ---- 多选:切换加入/移除、_remove、activated ----
        function test_multiple_toggleAndRemove() {
            multi.selectedValues = []
            multiSpy.clear()
            multi._choose("Remix")
            compare(multi.selectedValues.length, 1)
            compare(multi.selectedValues[0], "Remix")
            multi._choose("Astro")
            compare(multi.selectedValues.length, 2)
            multi._choose("Remix")                     // 再切换 → 移除
            compare(multi.selectedValues.length, 1)
            compare(multi.selectedValues[0], "Astro")
            multi._remove("Astro")
            compare(multi.selectedValues.length, 0)
            verify(multiSpy.count >= 4)
            // 复原为全选(供外观测试)
            multi.selectedValues = ["Next.js", "SvelteKit", "Nuxt.js", "Remix", "Astro"]
        }

        // ---- 模型→_rows 归一化:header 仅在有匹配项时出现、无尾部分隔线 ----
        function test_rows_normalization() {
            var rows = grouped._rows
            verify(rows.length > 0)
            // 首行应为分组标题 G1
            compare(rows[0].type, "header")
            compare(rows[0].label, "G1")
            // 不应以分隔线结尾
            compare(rows[rows.length - 1].type, "item")
            // 统计:两个 header、一个 sep、三个 item
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

        // ---- 外观:多选 chips 容器内边距对称,且上留白 == 行间距(复现 padding bug)----
        function test_chips_padding_symmetry() {
            multi.selectedValues = ["Next.js", "SvelteKit", "Nuxt.js", "Remix", "Astro"]
            wait(0)                                     // 让布局 polish

            var flow = findByName(multi, "cbChipsFlow")
            var trig = findByName(multi, "cbChipsTrigger")
            verify(flow !== null)
            verify(trig !== null)
            // 确认确实换行了(否则该用例无意义)
            verify(flow.height > 25)                    // 单行约 19,换行后明显更高

            var topInset = flow.y
            var bottomInset = trig.height - (flow.y + flow.height)
            // 上下对称
            verify(Math.abs(topInset - bottomInset) <= 1)
            // 关键:上留白 == 行间距(此前 padding 用 space0_5=2 而间距 space1=4,不等 → 会失败)
            verify(Math.abs(topInset - flow.spacing) <= 1)
        }
    }
}
