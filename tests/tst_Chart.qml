import QtQuick
import QtTest
import Shadcn

// Chart family unit tests: defaults, enum values, color mapping (series/pie),
// legend item generation, the nice-number tick scale, tooltip value formatting
// and ChartTooltip defaults. The Canvas drawing itself is not asserted (pixel
// plot positions are non-deterministic); instead the deterministic data-plumbing
// and computed properties that feed the painters are checked. Deterministic
// under the offscreen platform. Theme.dark defaults to false.
Item {
    id: root
    width: 400
    height: 300

    property var barData: [
        { month: "January", desktop: 186, mobile: 80 },
        { month: "February", desktop: 305, mobile: 200 },
        { month: "March", desktop: 237, mobile: 120 },
        { month: "April", desktop: 73, mobile: 190 },
        { month: "May", desktop: 209, mobile: 130 },
        { month: "June", desktop: 214, mobile: 140 }
    ]
    property var barSeries: [
        { key: "desktop", label: "Desktop" },
        { key: "mobile", label: "Mobile" }
    ]
    property var pieData: [
        { browser: "chrome", visitors: 275 },
        { browser: "safari", visitors: 200 },
        { browser: "firefox", visitors: 287, color: "#123456" }
    ]

    Chart {
        id: cDefault
        width: 400; height: 300
    }

    Chart {
        id: cBar
        width: 400; height: 300
        type: Chart.Bar
        chartData: root.barData
        series: root.barSeries
    }

    Chart {
        id: cPie
        width: 400; height: 300
        type: Chart.Pie
        chartData: root.pieData
        nameKey: "browser"
        valueKey: "visitors"
    }

    Chart {
        id: cOverride
        width: 400; height: 300
        chartData: root.barData
        series: [ { key: "desktop", label: "Desktop", color: "#abcdef" } ]
    }

    ChartLegend {
        id: legend
        items: [ { label: "A", color: "#ff0000" }, { label: "B", color: "#00ff00" } ]
    }

    ChartTooltip {
        id: tip
        labelText: "January"
        items: [ { color: "#ff0000", label: "Desktop", value: "186" } ]
    }

    TestCase {
        name: "Chart"
        when: windowShown

        // ---- Defaults ----
        function test_defaults() {
            compare(cDefault.type, Chart.Bar)
            compare(cDefault.categoryKey, "month")
            compare(cDefault.nameKey, "name")
            compare(cDefault.valueKey, "value")
            compare(cDefault.showGrid, true)
            compare(cDefault.showXAxis, true)
            compare(cDefault.showYAxis, false)
            compare(cDefault.showLegend, false)
            compare(cDefault.stacked, false)
            compare(cDefault.horizontal, false)
            compare(cDefault.curved, true)
            compare(cDefault.tooltipEnabled, true)
            compare(cDefault.tooltipIndicator, ChartTooltip.Dot)
            compare(cDefault.barRadius, 8)
            compare(cDefault.areaFillOpacity, 0.4)
            compare(cDefault.implicitWidth, 320)
            compare(cDefault.implicitHeight, 250)
            compare(cDefault.hoverIndex, -1)
            compare(cDefault.hoverSeries, -1)
        }

        // ---- Enum values are stable API (referenced by name elsewhere) ----
        function test_type_enum_values() {
            compare(Chart.Bar, 0)
            compare(Chart.Line, 1)
            compare(Chart.Area, 2)
            compare(Chart.Pie, 3)
            compare(Chart.Radar, 4)
            compare(Chart.Radial, 5)
        }

        function test_tooltip_enum_values() {
            compare(ChartTooltip.Dot, 0)
            compare(ChartTooltip.Line, 1)
            compare(ChartTooltip.Dashed, 2)
        }

        // ---- seriesKeys derived from series ----
        function test_series_keys() {
            compare(cBar.seriesKeys.length, 2)
            compare(cBar.seriesKeys[0], "desktop")
            compare(cBar.seriesKeys[1], "mobile")
        }

        // ---- Color mapping: default palette Theme.chart1..5, cyclic ----
        function test_series_color_palette() {
            compare(cBar.seriesColor(0), Theme.chart1)
            compare(cBar.seriesColor(1), Theme.chart2)
            compare(cBar.seriesColor(4), Theme.chart5)
            compare(cBar.seriesColor(5), Theme.chart1)   // wraps mod 5
            compare(cBar.seriesColor(-1), Theme.chart5)  // negative wraps
        }

        // colorFor falls back to the palette when the series has no color.
        function test_color_for_default() {
            compare(cBar.colorFor(0), Theme.chart1)
            compare(cBar.colorFor(1), Theme.chart2)
        }

        // colorFor honors an explicit per-series color override.
        function test_color_for_override() {
            compare(cOverride.colorFor(0), "#abcdef")
        }

        // pieColor uses the row color if present, else the palette by index.
        function test_pie_color() {
            compare(cPie.pieColor(root.pieData[0], 0), Theme.chart1)
            compare(cPie.pieColor(root.pieData[2], 2), "#123456")
        }

        // ---- Legend items generated from series (cartesian) ----
        function test_legend_items_cartesian() {
            compare(cBar.legendItems.length, 2)
            compare(cBar.legendItems[0].label, "Desktop")
            compare(cBar.legendItems[0].color, Theme.chart1)
            compare(cBar.legendItems[1].label, "Mobile")
            compare(cBar.legendItems[1].color, Theme.chart2)
        }

        // ---- Legend items generated from chartData (pie, via nameKey) ----
        function test_legend_items_pie() {
            compare(cPie.legendItems.length, 3)
            compare(cPie.legendItems[0].label, "chrome")
            compare(cPie.legendItems[0].color, Theme.chart1)
            compare(cPie.legendItems[2].label, "firefox")
            compare(cPie.legendItems[2].color, "#123456")   // row override
        }

        // ---- Nice tick scale for a known dataset (non-stacked) ----
        // max(desktop)=305, max(mobile)=200 -> domain max 305 -> nice 400.
        function test_scale_non_stacked() {
            compare(cBar.stacked, false)
            compare(cBar._scale.max, 400)
            compare(cBar._scale.ticks.length, 5)   // 0,100,200,300,400
            compare(cBar._scale.ticks[0], 0)
            compare(cBar._scale.ticks[4], 400)
        }

        // ---- Nice tick scale stacks per-row sums ----
        // max row sum = Feb (305+200=505) -> nice 600.
        function test_scale_stacked() {
            cBar.stacked = true
            compare(cBar._scale.max, 600)
            compare(cBar._scale.ticks[cBar._scale.ticks.length - 1], 600)
            cBar.stacked = false
        }

        // ---- Value formatting: thousands grouping / passthrough / custom ----
        // Qt's Number.toLocaleString applies the locale's grouping AND (by
        // default) fractional digits, and both the grouping char and decimal
        // format are locale-dependent. So assert the intent rather than an exact
        // string: the digits are preserved in order and a large number gains
        // separators (its rendered form is longer than the bare digit string).
        function test_fmt_number_grouping() {
            var big = cDefault._fmtVal(1234567)
            verify(big.replace(/\D/g, "").indexOf("1234567") === 0)  // digits kept, in order
            verify(big.length > 7)                                   // grouping/formatting added

            var small = cDefault._fmtVal(5)
            verify(small.replace(/\D/g, "").indexOf("5") === 0)      // still renders the value
        }

        function test_fmt_string_passthrough() {
            compare(cDefault._fmtVal("N/A"), "N/A")
        }

        function test_fmt_custom_formatter() {
            cDefault.valueFormatter = function(v) { return "$" + v }
            compare(cDefault._fmtVal(50), "$50")
            cDefault.valueFormatter = null
        }

        // ---- ChartLegend ----
        function test_legend_defaults() {
            compare(legend.atTop, false)
            compare(legend.items.length, 2)
            verify(legend.implicitHeight > 0)
        }

        // ---- ChartTooltip defaults + data plumbing ----
        function test_tooltip_defaults() {
            compare(tip.showLabel, true)
            compare(tip.indicator, ChartTooltip.Dot)
            compare(tip.labelText, "January")
            compare(tip.items.length, 1)
            compare(tip.items[0].value, "186")
            verify(tip.implicitWidth >= 128)   // min-w-32
        }
    }
}
