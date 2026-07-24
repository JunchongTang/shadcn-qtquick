import QtQuick

/*!
    \qmltype Chart
    \inqmlmodule Shadcn
    \inherits Item
    \brief A data-driven chart, styled after shadcn's base-mira chart family.

    Chart is a Canvas-drawn port of shadcn/ui's chart components (which wrap
    Recharts). One type covers six shapes selected by \l type: \c Bar, \c Line,
    \c Area, \c Pie, \c Radar and \c Radial. Data is supplied through \l chartData
    (an array of row objects) plus, for cartesian and radar charts, a \l series
    list of \c {{ key, label, color }} descriptors. Series colors default to the
    theme palette \c Theme.chart1..chart5.

    It renders dashed gridlines, axis tick text, rounded bars, smoothed
    line/area paths, pie/donut sectors, polar grids and radial arcs, and hosts an
    embedded \l ChartLegend and a hover \l ChartTooltip.

    Because \c data and \c scale are built-in \l Item properties, the data field
    is named \l chartData and the internal tick scale \c _scale.

    Simplifications relative to Recharts:
    \list
    \li Cartesian Y uses a zero-based "nice" tick scale (Recharts lines default
        to an auto domain; a zero baseline renders more predictably here).
    \li Lines use Catmull-Rom smoothing when \l curved is \c true, straight
        segments otherwise.
    \li Radar uses the same zero-based nice scale for its radius.
    \li Radial round caps approximate \c cornerRadius; a single value fills the
        track while multiple rings use a nice upper bound; the sweep is clamped
        to 360 degrees (shadcn slightly over-wraps to 470).
    \endlist
*/
Item {
    id: root

    /*!
        \qmlproperty enumeration Chart::type
        The chart shape to draw.
        \value Chart.Bar Grouped or stacked bars (see \l stacked, \l horizontal).
        \value Chart.Line Smoothed or straight line series.
        \value Chart.Area Filled area series.
        \value Chart.Pie Pie or donut (\l innerRadius > 0).
        \value Chart.Radar Polar radar polygons.
        \value Chart.Radial Radial (arc) bars.
    */
    enum Type { Bar, Line, Area, Pie, Radar, Radial }

    // ==== Data and series ====
    /*! \qmlproperty int Chart::type \brief The chart shape; see \l Type. Defaults to \c Chart.Bar. */
    property int type: Chart.Bar
    /*!
        \qmlproperty list Chart::chartData
        The rows to plot. Cartesian/radar: \c {{ <categoryKey>: ..., key1: ..., key2: ... }};
        pie/radial: \c {{ <nameKey>: ..., <valueKey>: ..., color? }}. Defaults to \c [].
    */
    property var chartData: []
    /*!
        \qmlproperty list Chart::series
        The cartesian/radar series descriptors, each \c {{ key, label, color? }}
        where \c key names the field in \l chartData, \c label the display name and
        \c color an optional override (else the theme palette). Defaults to \c [].
    */
    property var series: []
    /*! \qmlproperty string Chart::categoryKey \brief The x-axis category field. Defaults to \c "month". */
    property string categoryKey: "month"
    /*! \qmlproperty string Chart::nameKey \brief The name field for pie/radial rows. Defaults to \c "name". */
    property string nameKey: "name"
    /*! \qmlproperty string Chart::valueKey \brief The value field for pie/radial rows. Defaults to \c "value". */
    property string valueKey: "value"

    // ==== Display toggles ====
    /*! \qmlproperty bool Chart::showGrid \brief Whether to draw gridlines. Defaults to \c true. */
    property bool showGrid: true
    /*! \qmlproperty bool Chart::showXAxis \brief Whether to draw x-axis tick labels. Defaults to \c true. */
    property bool showXAxis: true
    /*! \qmlproperty bool Chart::showYAxis \brief Whether to draw y-axis tick labels. Defaults to \c false. */
    property bool showYAxis: false
    /*! \qmlproperty bool Chart::showLegend \brief Whether to show the embedded \l ChartLegend. Defaults to \c false. */
    property bool showLegend: false
    /*! \qmlproperty bool Chart::legendTop \brief Whether the legend sits above the plot. Defaults to \c false (below). */
    property bool legendTop: false
    /*! \qmlproperty bool Chart::stacked \brief Whether bar/area/radial series stack. Defaults to \c false. */
    property bool stacked: false
    /*! \qmlproperty bool Chart::horizontal \brief Bar charts only: lay bars horizontally. Defaults to \c false. */
    property bool horizontal: false
    /*! \qmlproperty bool Chart::curved \brief Line/area: smooth the path. Defaults to \c true. */
    property bool curved: true
    /*! \qmlproperty bool Chart::showDots \brief Line/radar: draw a dot at each data point. Defaults to \c false. */
    property bool showDots: false
    /*! \qmlproperty bool Chart::showBarLabels \brief Draw value labels on bars / radial rings. Defaults to \c false. */
    property bool showBarLabels: false
    /*! \qmlproperty real Chart::barRadius \brief Corner radius of bars in px. Defaults to \c 8. */
    property real barRadius: 8
    /*! \qmlproperty real Chart::areaFillOpacity \brief Fill opacity of area series. Defaults to \c 0.4. */
    property real areaFillOpacity: 0.4
    /*! \qmlproperty real Chart::innerRadius \brief Pie/radial inner radius in px (pie > 0 makes a donut). Defaults to \c 0. */
    property real innerRadius: 0
    /*! \qmlproperty real Chart::padAngleDeg \brief Pie: gap angle between sectors, in degrees. Defaults to \c 0. */
    property real padAngleDeg: 0

    // ==== Polar: Radar ====
    /*! \qmlproperty bool Chart::polarGridCircle \brief Radar grid shape: \c true circle, \c false polygon. Defaults to \c false. */
    property bool polarGridCircle: false
    /*! \qmlproperty bool Chart::polarRadialLines \brief Radar: draw spokes from center to each vertex. Defaults to \c true. */
    property bool polarRadialLines: true
    /*! \qmlproperty real Chart::radarFillOpacity \brief Radar polygon fill opacity (0 = stroke only). Defaults to \c 0.6. */
    property real radarFillOpacity: 0.6

    // ==== Polar: Radial bars ====
    /*! \qmlproperty real Chart::outerRadius \brief Radial outer radius in px (0 = auto-fit). Defaults to \c 0. */
    property real outerRadius: 0
    /*! \qmlproperty real Chart::radialStartDeg \brief Radial start angle in screen degrees (0 = top, clockwise positive). Defaults to \c 0. */
    property real radialStartDeg: 0
    /*! \qmlproperty real Chart::radialEndDeg \brief Radial end angle in screen degrees. Defaults to \c 360. */
    property real radialEndDeg: 360
    /*! \qmlproperty bool Chart::radialBackground \brief Draw a muted track behind each radial ring. Defaults to \c false. */
    property bool radialBackground: false
    /*! \qmlproperty real Chart::radialCornerRadius \brief Radial: > 0 uses round end caps. Defaults to \c 0. */
    property real radialCornerRadius: 0
    /*! \qmlproperty string Chart::centerText \brief Radial: primary center text (e.g. a total). Defaults to \c "". */
    property string centerText: ""
    /*! \qmlproperty string Chart::centerSubtext \brief Radial: secondary center text. Defaults to \c "". */
    property string centerSubtext: ""
    /*! \qmlproperty int Chart::centerValueSize \brief Pixel size of \l centerText. Defaults to \c Theme.text4xl. */
    property int centerValueSize: Theme.text4xl
    /*! \qmlproperty real Chart::centerYOffset \brief Vertical nudge of the center text in px. Defaults to \c 0. */
    property real centerYOffset: 0

    // ==== Tooltip / cursor ====
    /*! \qmlproperty bool Chart::tooltipEnabled \brief Whether hovering shows a \l ChartTooltip. Defaults to \c true. */
    property bool tooltipEnabled: true
    /*! \qmlproperty bool Chart::hideTooltipLabel \brief Hide the tooltip heading line. Defaults to \c false. */
    property bool hideTooltipLabel: false
    /*! \qmlproperty int Chart::tooltipIndicator \brief Tooltip swatch style; see \l ChartTooltip::Indicator. Defaults to \c ChartTooltip.Dot. */
    property int tooltipIndicator: ChartTooltip.Dot
    /*! \qmlproperty bool Chart::tooltipCursor \brief Draw a cursor highlight under the hovered point. Defaults to \c true. */
    property bool tooltipCursor: true

    /*! \qmlproperty var Chart::xTickFormatter \brief Optional \c {function(value) -> string} for x tick labels; \c null uses the raw value. */
    property var xTickFormatter: null
    /*! \qmlproperty var Chart::valueFormatter \brief Optional \c {function(value) -> string} for tooltip values; \c null uses thousands grouping. */
    property var valueFormatter: null

    implicitWidth: 320
    implicitHeight: 250

    readonly property bool _horizontalBar: type === Chart.Bar && horizontal
    readonly property bool _cartesian: type === Chart.Bar || type === Chart.Line || type === Chart.Area
    readonly property bool _polar: type === Chart.Radar || type === Chart.Radial

    // ==== Geometry (relative to the plotArea size) ====
    readonly property real _padTop: 8
    readonly property real _padRight: 8
    readonly property real _padBottom: _polar ? 8 : (_horizontalBar ? 8 : (showXAxis ? 24 : 8))
    readonly property real _padLeft: _polar ? 8 : (_horizontalBar ? 46 : (showYAxis ? 38 : 8))
    readonly property real plotX0: _padLeft
    readonly property real plotX1: plotArea.width - _padRight
    readonly property real plotY0: _padTop
    readonly property real plotY1: plotArea.height - _padBottom

    // ==== Colors ====
    function seriesColor(i) {
        var arr = [Theme.chart1, Theme.chart2, Theme.chart3, Theme.chart4, Theme.chart5]
        return arr[((i % 5) + 5) % 5]
    }
    function colorFor(j) {
        var s = series[j]
        return (s && s.color !== undefined) ? s.color : seriesColor(j)
    }
    function pieColor(d, i) {
        return (d && d.color !== undefined) ? d.color : seriesColor(i)
    }

    readonly property var seriesKeys: {
        var a = []
        for (var i = 0; i < series.length; i++) a.push(series[i].key)
        return a
    }

    // ==== Value domain (nice tick scale) ====
    function _niceNum(range, round) {
        if (range <= 0) return 1
        var exp = Math.floor(Math.log(range) / Math.LN10)
        var frac = range / Math.pow(10, exp)
        var nf
        if (round) nf = frac < 1.5 ? 1 : (frac < 3 ? 2 : (frac < 7 ? 5 : 10))
        else nf = frac <= 1 ? 1 : (frac <= 2 ? 2 : (frac <= 5 ? 5 : 10))
        return nf * Math.pow(10, exp)
    }
    readonly property var _scale: {
        var mx = 0
        for (var i = 0; i < chartData.length; i++) {
            var row = chartData[i]
            if (stacked) {
                var sum = 0
                for (var k = 0; k < seriesKeys.length; k++) sum += Number(row[seriesKeys[k]]) || 0
                mx = Math.max(mx, sum)
            } else {
                for (var j = 0; j < seriesKeys.length; j++) mx = Math.max(mx, Number(row[seriesKeys[j]]) || 0)
            }
        }
        if (mx <= 0) mx = 1
        var step = _niceNum(mx / 4, true)
        var niceMax = Math.ceil(mx / step) * step
        var ticks = []
        for (var t = 0; t <= niceMax + step * 0.001; t += step) ticks.push(t)
        return { "max": niceMax, "ticks": ticks }
    }

    // ==== Coordinate mapping ====
    function catCenterX(i) {
        var n = chartData.length
        if (type === Chart.Line || type === Chart.Area)
            return n > 1 ? plotX0 + i / (n - 1) * (plotX1 - plotX0) : (plotX0 + plotX1) / 2
        var band = (plotX1 - plotX0) / Math.max(1, n)      // bar band
        return plotX0 + (i + 0.5) * band
    }
    function catCenterY(i) {
        var n = chartData.length
        var band = (plotY1 - plotY0) / Math.max(1, n)
        return plotY0 + (i + 0.5) * band
    }
    function valToY(v) { return plotY1 - (v / _scale.max) * (plotY1 - plotY0) }
    function valToX(v) { return plotX0 + (v / _scale.max) * (plotX1 - plotX0) }

    // ==== Legend entries ====
    readonly property var legendItems: {
        var a = []
        if (type === Chart.Pie || (type === Chart.Radial && !stacked)) {
            for (var i = 0; i < chartData.length; i++) {
                var d = chartData[i]
                a.push({ "label": d.label !== undefined ? d.label : d[nameKey], "color": pieColor(d, i) })
            }
        } else {
            for (var j = 0; j < series.length; j++)
                a.push({ "label": series[j].label !== undefined ? series[j].label : series[j].key, "color": colorFor(j) })
        }
        return a
    }

    function _fmtVal(v) {
        if (valueFormatter) return valueFormatter(v)
        return (typeof v === "number") ? v.toLocaleString(Qt.locale("en_US")) : String(v)
    }

    // ==== Hover state ====
    property int hoverIndex: -1
    property int hoverSeries: -1            // pie/radial: hovered sector/ring

    onWidthChanged: cv.requestPaint()
    onHeightChanged: cv.requestPaint()
    onChartDataChanged: cv.requestPaint()
    onSeriesChanged: cv.requestPaint()
    onTypeChanged: cv.requestPaint()
    onStackedChanged: cv.requestPaint()
    onHorizontalChanged: cv.requestPaint()
    onShowGridChanged: cv.requestPaint()
    onHoverIndexChanged: cv.requestPaint()
    onHoverSeriesChanged: cv.requestPaint()
    onInnerRadiusChanged: cv.requestPaint()
    onOuterRadiusChanged: cv.requestPaint()
    onRadialStartDegChanged: cv.requestPaint()
    onRadialEndDegChanged: cv.requestPaint()
    onRadialBackgroundChanged: cv.requestPaint()
    onRadialCornerRadiusChanged: cv.requestPaint()
    onPolarGridCircleChanged: cv.requestPaint()
    onPolarRadialLinesChanged: cv.requestPaint()
    onRadarFillOpacityChanged: cv.requestPaint()
    onShowDotsChanged: cv.requestPaint()
    Connections { target: Theme; function onDarkChanged() { cv.requestPaint() } }

    // ==== Legend (top or bottom) ====
    ChartLegend {
        id: legend
        visible: root.showLegend
        atTop: root.legendTop
        items: root.legendItems
        width: root.width
        height: visible ? implicitHeight : 0
        anchors.top: root.legendTop ? parent.top : undefined
        anchors.bottom: root.legendTop ? undefined : parent.bottom
    }

    // ==== Plot area ====
    Item {
        id: plotArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: (root.showLegend && root.legendTop) ? legend.bottom : parent.top
        anchors.bottom: (root.showLegend && !root.legendTop) ? legend.top : parent.bottom

        Canvas {
            id: cv
            anchors.fill: parent
            onWidthChanged: requestPaint()
            onHeightChanged: requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                if (width <= 0 || height <= 0) return
                if (root.type === Chart.Pie) { root._paintPie(ctx); return }
                if (root.type === Chart.Radar) { root._paintRadar(ctx); return }
                if (root.type === Chart.Radial) { root._paintRadial(ctx); return }
                root._paintGrid(ctx)
                root._paintCursor(ctx)
                if (root.type === Chart.Bar) root._paintBars(ctx)
                else root._paintLineArea(ctx)
            }
        }

        // ---- x-axis tick labels (vertical charts) ----
        Repeater {
            model: (root._cartesian && root.showXAxis && !root._horizontalBar) ? root.chartData : []
            delegate: Text {
                required property int index
                required property var modelData
                text: root.xTickFormatter ? root.xTickFormatter(modelData[root.categoryKey])
                                          : (modelData[root.categoryKey] !== undefined ? String(modelData[root.categoryKey]) : "")
                color: Theme.mutedForeground
                font.pixelSize: Theme.textXs
                x: root.catCenterX(index) - width / 2
                y: root.plotY1 + 6
            }
        }

        // ---- Category labels (horizontal bars: left side) ----
        Repeater {
            model: root._horizontalBar ? root.chartData : []
            delegate: Text {
                required property int index
                required property var modelData
                text: root.xTickFormatter ? root.xTickFormatter(modelData[root.categoryKey])
                                          : (modelData[root.categoryKey] !== undefined ? String(modelData[root.categoryKey]) : "")
                color: Theme.mutedForeground
                font.pixelSize: Theme.textXs
                x: root.plotX0 - 10 - width
                y: root.catCenterY(index) - height / 2
            }
        }

        // ---- y-axis tick labels (optional) ----
        Repeater {
            model: (root._cartesian && root.showYAxis && !root._horizontalBar) ? root._scale.ticks : []
            delegate: Text {
                required property int index
                required property var modelData
                text: root._fmtVal(modelData)
                color: Theme.mutedForeground
                font.pixelSize: Theme.textXs
                x: root.plotX0 - 8 - width
                y: root.valToY(modelData) - height / 2
            }
        }

        // ==== Hover interaction ====
        MouseArea {
            id: hover
            anchors.fill: parent
            hoverEnabled: root.tooltipEnabled
            acceptedButtons: Qt.NoButton

            onPositionChanged: (m) => root._updateHover(m.x, m.y)
            onExited: { root.hoverIndex = -1; root.hoverSeries = -1; tip.visible = false }
        }

        // ==== Center text (radial text/shape/stacked variants) ====
        Column {
            visible: root.type === Chart.Radial && (root.centerText !== "" || root.centerSubtext !== "")
            spacing: 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: root.centerYOffset
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.centerText
                visible: text !== ""
                color: Theme.foreground
                font.pixelSize: root.centerValueSize
                font.weight: Font.Bold
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.centerSubtext
                visible: text !== ""
                color: Theme.mutedForeground
                font.pixelSize: Theme.textSm
                horizontalAlignment: Text.AlignHCenter
            }
        }

        // ==== tooltip ====
        ChartTooltip {
            id: tip
            visible: false
            indicator: root.tooltipIndicator
            showLabel: !root.hideTooltipLabel
            z: 10
        }
    }

    // ================= Painting =================
    function _paintGrid(ctx) {
        if (!showGrid) return
        ctx.save()
        ctx.strokeStyle = Theme.alpha(Theme.border, 0.5)
        ctx.lineWidth = 1
        ctx.setLineDash([3, 3])
        if (_horizontalBar) {
            for (var i = 0; i < _scale.ticks.length; i++) {
                var x = Math.round(valToX(_scale.ticks[i])) + 0.5
                ctx.beginPath(); ctx.moveTo(x, plotY0); ctx.lineTo(x, plotY1); ctx.stroke()
            }
        } else {
            for (var j = 0; j < _scale.ticks.length; j++) {
                var y = Math.round(valToY(_scale.ticks[j])) + 0.5
                ctx.beginPath(); ctx.moveTo(plotX0, y); ctx.lineTo(plotX1, y); ctx.stroke()
            }
        }
        ctx.restore()
    }

    function _paintCursor(ctx) {
        if (!tooltipCursor || hoverIndex < 0) return
        ctx.save()
        if (type === Chart.Bar) {
            ctx.fillStyle = Theme.alpha(Theme.muted, Theme.dark ? 0.5 : 0.6)
            if (_horizontalBar) {
                var band = (plotY1 - plotY0) / Math.max(1, chartData.length)
                ctx.fillRect(plotX0, plotY0 + hoverIndex * band, plotX1 - plotX0, band)
            } else {
                var bandx = (plotX1 - plotX0) / Math.max(1, chartData.length)
                ctx.fillRect(plotX0 + hoverIndex * bandx, plotY0, bandx, plotY1 - plotY0)
            }
        } else {
            var cx = Math.round(catCenterX(hoverIndex)) + 0.5
            ctx.strokeStyle = Theme.border
            ctx.lineWidth = 1
            ctx.beginPath(); ctx.moveTo(cx, plotY0); ctx.lineTo(cx, plotY1); ctx.stroke()
        }
        ctx.restore()
    }

    function _roundedTopRect(ctx, x, y, w, h, r) {
        r = Math.max(0, Math.min(r, w / 2, h))
        ctx.beginPath()
        ctx.moveTo(x, y + h)
        ctx.lineTo(x, y + r)
        ctx.arcTo(x, y, x + r, y, r)
        ctx.lineTo(x + w - r, y)
        ctx.arcTo(x + w, y, x + w, y + r, r)
        ctx.lineTo(x + w, y + h)
        ctx.closePath()
    }
    function _roundedRightRect(ctx, x, y, w, h, r) {
        r = Math.max(0, Math.min(r, h / 2, w))
        ctx.beginPath()
        ctx.moveTo(x, y)
        ctx.lineTo(x + w - r, y)
        ctx.arcTo(x + w, y, x + w, y + r, r)
        ctx.lineTo(x + w, y + h - r)
        ctx.arcTo(x + w, y + h, x + w - r, y + h, r)
        ctx.lineTo(x, y + h)
        ctx.closePath()
    }

    function _paintBars(ctx) {
        var n = chartData.length
        var s = seriesKeys.length
        if (n === 0 || s === 0) return

        if (_horizontalBar) {
            var band = (plotY1 - plotY0) / n
            var groupH = band * 0.68
            var barH = stacked ? groupH : groupH / s
            for (var i = 0; i < n; i++) {
                var gy0 = plotY0 + i * band + (band - groupH) / 2
                var accX = plotX0
                for (var j = 0; j < s; j++) {
                    var v = Number(chartData[i][seriesKeys[j]]) || 0
                    var len = (v / _scale.max) * (plotX1 - plotX0)
                    ctx.fillStyle = colorFor(j)
                    if (stacked) {
                        var topmost = (j === s - 1)
                        if (topmost) _roundedRightRect(ctx, accX, gy0, len, barH, barRadius)
                        else { ctx.beginPath(); ctx.rect(accX, gy0, len, barH) }
                        ctx.fill()
                        accX += len
                    } else {
                        _roundedRightRect(ctx, plotX0, gy0 + j * barH, len, barH, barRadius)
                        ctx.fill()
                    }
                }
            }
            return
        }

        var bandx = (plotX1 - plotX0) / n
        var groupW = bandx * 0.68
        var barW = stacked ? groupW : groupW / s
        var barGap = stacked ? 0 : Math.min(4, barW * 0.15)
        var drawW = stacked ? groupW : (barW - barGap)
        for (var ci = 0; ci < n; ci++) {
            var gx0 = plotX0 + ci * bandx + (bandx - groupW) / 2
            var accY = plotY1
            for (var sj = 0; sj < s; sj++) {
                var val = Number(chartData[ci][seriesKeys[sj]]) || 0
                var hgt = (val / _scale.max) * (plotY1 - plotY0)
                ctx.fillStyle = colorFor(sj)
                if (stacked) {
                    var top = (sj === s - 1)
                    if (top) _roundedTopRect(ctx, gx0, accY - hgt, groupW, hgt, barRadius)
                    else { ctx.beginPath(); ctx.rect(gx0, accY - hgt, groupW, hgt) }
                    ctx.fill()
                    accY -= hgt
                } else {
                    var bx = gx0 + sj * barW + barGap / 2
                    _roundedTopRect(ctx, bx, plotY1 - hgt, drawW, hgt, barRadius)
                    ctx.fill()
                    if (showBarLabels) {
                        ctx.save()
                        ctx.fillStyle = Theme.mutedForeground
                        ctx.font = "12px '" + Theme.fontSans + "'"
                        ctx.textAlign = "center"
                        ctx.textBaseline = "bottom"
                        ctx.fillText(_fmtVal(val), bx + drawW / 2, plotY1 - hgt - 6)
                        ctx.restore()
                    }
                }
            }
        }
    }

    function _smoothPath(ctx, pts) {
        if (pts.length === 0) return
        ctx.moveTo(pts[0].x, pts[0].y)
        if (pts.length < 3 || !curved) {
            for (var i = 1; i < pts.length; i++) ctx.lineTo(pts[i].x, pts[i].y)
            return
        }
        for (var k = 0; k < pts.length - 1; k++) {
            var p0 = pts[k - 1] || pts[k]
            var p1 = pts[k]
            var p2 = pts[k + 1]
            var p3 = pts[k + 2] || p2
            var cp1x = p1.x + (p2.x - p0.x) / 6
            var cp1y = p1.y + (p2.y - p0.y) / 6
            var cp2x = p2.x - (p3.x - p1.x) / 6
            var cp2y = p2.y - (p3.y - p1.y) / 6
            ctx.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, p2.x, p2.y)
        }
    }

    function _paintLineArea(ctx) {
        var n = chartData.length
        var s = seriesKeys.length
        if (n === 0 || s === 0) return

        // Stacked cumulative baseline (bottom-up)
        var cum = []
        for (var c = 0; c < n; c++) cum.push(0)

        for (var j = 0; j < s; j++) {
            var top = []
            var base = []
            for (var i = 0; i < n; i++) {
                var v = Number(chartData[i][seriesKeys[j]]) || 0
                var yBaseVal = stacked ? cum[i] : 0
                var yTopVal = stacked ? cum[i] + v : v
                top.push({ "x": catCenterX(i), "y": valToY(yTopVal) })
                base.push({ "x": catCenterX(i), "y": valToY(yBaseVal) })
                if (stacked) cum[i] += v
            }

            var col = colorFor(j)

            // ---- Area fill ----
            if (type === Chart.Area) {
                ctx.save()
                ctx.beginPath()
                _smoothPath(ctx, top)
                for (var b = base.length - 1; b >= 0; b--) ctx.lineTo(base[b].x, base[b].y)
                ctx.closePath()
                ctx.globalAlpha = areaFillOpacity
                ctx.fillStyle = col
                ctx.fill()
                ctx.restore()
            }

            // ---- Line ----
            ctx.save()
            ctx.beginPath()
            _smoothPath(ctx, top)
            ctx.strokeStyle = col
            ctx.lineWidth = 2
            ctx.lineJoin = "round"
            ctx.lineCap = "round"
            ctx.stroke()
            ctx.restore()

            // ---- Data dots ----
            if (showDots) {
                for (var d = 0; d < top.length; d++) {
                    ctx.beginPath()
                    ctx.arc(top[d].x, top[d].y, 3, 0, 2 * Math.PI)
                    ctx.fillStyle = col
                    ctx.fill()
                }
            }

            // ---- Active (hovered) point ----
            if (hoverIndex >= 0 && hoverIndex < top.length) {
                var hp = top[hoverIndex]
                ctx.beginPath(); ctx.arc(hp.x, hp.y, 4, 0, 2 * Math.PI)
                ctx.fillStyle = col; ctx.fill()
                ctx.lineWidth = 2; ctx.strokeStyle = Theme.background; ctx.stroke()
            }
        }
    }

    function _pieGeom() {
        var cx = (plotX0 + plotX1) / 2
        var cy = (plotY0 + plotY1) / 2
        var r = Math.min(plotX1 - plotX0, plotY1 - plotY0) / 2 - 4
        return { "cx": cx, "cy": cy, "r": r }
    }

    function _paintPie(ctx) {
        var g = _pieGeom()
        if (g.r <= 0) return
        var total = 0
        for (var i = 0; i < chartData.length; i++) total += Number(chartData[i][valueKey]) || 0
        if (total <= 0) return

        var pad = padAngleDeg * Math.PI / 180
        var start = -Math.PI / 2
        for (var k = 0; k < chartData.length; k++) {
            var v = Number(chartData[k][valueKey]) || 0
            var frac = v / total
            var a0 = start + pad / 2
            var a1 = start + frac * 2 * Math.PI - pad / 2
            var outer = g.r + (k === hoverSeries ? 6 : 0)

            ctx.beginPath()
            if (innerRadius > 0) {
                ctx.arc(g.cx, g.cy, outer, a0, a1, false)
                ctx.arc(g.cx, g.cy, innerRadius, a1, a0, true)
            } else {
                ctx.moveTo(g.cx, g.cy)
                ctx.arc(g.cx, g.cy, outer, a0, a1, false)
            }
            ctx.closePath()
            ctx.fillStyle = pieColor(chartData[k], k)
            ctx.fill()
            // Sector separators (background-colored stroke, approximating Recharts)
            ctx.lineWidth = 2
            ctx.strokeStyle = Theme.background
            ctx.stroke()
            start += frac * 2 * Math.PI
        }
    }

    // ================= Polar: Radar =================
    function _polarCenter() {
        return { "cx": (plotX0 + plotX1) / 2, "cy": (plotY0 + plotY1) / 2,
                 "R": Math.min(plotX1 - plotX0, plotY1 - plotY0) / 2 }
    }
    function _radarGeom() {
        var c = _polarCenter()
        var R = c.R - 30                         // leave room for angle labels
        if (R < 10) R = c.R * 0.72
        return { "cx": c.cx, "cy": c.cy, "R": R }
    }
    // Canvas angle of category i (starting at -90 degrees, clockwise)
    function _radarAngle(i, n) { return -Math.PI / 2 + i * 2 * Math.PI / n }

    function _paintRadar(ctx) {
        var n = chartData.length
        var s = seriesKeys.length
        if (n === 0 || s === 0) return
        var g = _radarGeom()
        var cx = g.cx, cy = g.cy, R = g.R
        var max = _scale.max

        // ---- Polar grid ----
        if (showGrid) {
            ctx.save()
            ctx.strokeStyle = Theme.border
            ctx.lineWidth = 1
            var ticks = _scale.ticks
            for (var t = 1; t < ticks.length; t++) {
                var rr = R * (ticks[t] / max)
                ctx.beginPath()
                if (polarGridCircle) {
                    ctx.arc(cx, cy, rr, 0, 2 * Math.PI)
                } else {
                    for (var i = 0; i < n; i++) {
                        var a = _radarAngle(i, n)
                        var px = cx + rr * Math.cos(a), py = cy + rr * Math.sin(a)
                        if (i === 0) ctx.moveTo(px, py); else ctx.lineTo(px, py)
                    }
                    ctx.closePath()
                }
                ctx.stroke()
            }
            // Spokes
            if (polarRadialLines) {
                for (var k = 0; k < n; k++) {
                    var ak = _radarAngle(k, n)
                    ctx.beginPath()
                    ctx.moveTo(cx, cy)
                    ctx.lineTo(cx + R * Math.cos(ak), cy + R * Math.sin(ak))
                    ctx.stroke()
                }
            }
            ctx.restore()
        }

        // ---- Per-series polygons ----
        for (var j = 0; j < s; j++) {
            var col = colorFor(j)
            var pts = []
            for (var m = 0; m < n; m++) {
                var v = Number(chartData[m][seriesKeys[j]]) || 0
                var frac = max > 0 ? v / max : 0
                var ang = _radarAngle(m, n)
                pts.push({ "x": cx + R * frac * Math.cos(ang), "y": cy + R * frac * Math.sin(ang) })
            }
            ctx.beginPath()
            for (var p = 0; p < pts.length; p++) {
                if (p === 0) ctx.moveTo(pts[p].x, pts[p].y); else ctx.lineTo(pts[p].x, pts[p].y)
            }
            ctx.closePath()
            if (radarFillOpacity > 0) {
                ctx.save(); ctx.globalAlpha = radarFillOpacity; ctx.fillStyle = col; ctx.fill(); ctx.restore()
            }
            ctx.lineWidth = 2; ctx.lineJoin = "round"; ctx.strokeStyle = col; ctx.stroke()

            if (showDots) {
                for (var d = 0; d < pts.length; d++) {
                    ctx.beginPath(); ctx.arc(pts[d].x, pts[d].y, 4, 0, 2 * Math.PI)
                    ctx.fillStyle = col; ctx.fill()
                }
            }
            if (hoverIndex >= 0 && hoverIndex < pts.length) {
                var hp = pts[hoverIndex]
                ctx.beginPath(); ctx.arc(hp.x, hp.y, 4, 0, 2 * Math.PI); ctx.fillStyle = col; ctx.fill()
                ctx.lineWidth = 2; ctx.strokeStyle = Theme.background; ctx.stroke()
            }
        }

        // ---- Angle labels (category names) ----
        ctx.save()
        ctx.fillStyle = Theme.mutedForeground
        ctx.font = Theme.textXs + "px '" + Theme.fontSans + "'"
        ctx.textBaseline = "middle"
        for (var q = 0; q < n; q++) {
            var aq = _radarAngle(q, n)
            var lx = cx + (R + 16) * Math.cos(aq)
            var ly = cy + (R + 16) * Math.sin(aq)
            var cosv = Math.cos(aq)
            ctx.textAlign = Math.abs(cosv) < 0.3 ? "center" : (cosv > 0 ? "left" : "right")
            var lab = xTickFormatter ? xTickFormatter(chartData[q][categoryKey])
                                     : (chartData[q][categoryKey] !== undefined ? String(chartData[q][categoryKey]) : "")
            ctx.fillText(lab, lx, ly)
        }
        ctx.restore()
    }

    // ================= Polar: Radial bars =================
    function _radialGeom() {
        var c = _polarCenter()
        var oR = outerRadius > 0 ? outerRadius : c.R - 6
        var iR = innerRadius > 0 ? innerRadius : oR * 0.3
        return { "cx": c.cx, "cy": c.cy, "oR": oR, "iR": iR,
                 "start": -Math.PI / 2 + radialStartDeg * Math.PI / 180,
                 "sweep": (radialEndDeg - radialStartDeg) * Math.PI / 180 }
    }

    function _paintRadial(ctx) {
        var n = chartData.length
        if (n === 0) return
        var g = _radialGeom()
        var cx = g.cx, cy = g.cy

        // ---- Stacked: one row's series accumulate along the angle (single ring) ----
        if (stacked) {
            var row = chartData[0]
            if (!row) return
            var total = 0
            for (var t = 0; t < seriesKeys.length; t++) total += Number(row[seriesKeys[t]]) || 0
            if (total <= 0) return
            var thick = g.oR - g.iR
            var midR = (g.oR + g.iR) / 2
            ctx.save()
            ctx.lineWidth = thick
            ctx.lineCap = radialCornerRadius > 0 ? "round" : "butt"
            var acc = 0
            for (var j = 0; j < seriesKeys.length; j++) {
                var v = Number(row[seriesKeys[j]]) || 0
                var a0 = g.start + (acc / total) * g.sweep
                var a1 = g.start + ((acc + v) / total) * g.sweep
                ctx.strokeStyle = colorFor(j)
                ctx.beginPath(); ctx.arc(cx, cy, midR, a0, a1, false); ctx.stroke()
                acc += v
            }
            ctx.restore()
            return
        }

        // ---- One ring per row ----
        var mx = 0
        for (var i0 = 0; i0 < n; i0++) mx = Math.max(mx, Number(chartData[i0][valueKey]) || 0)
        if (mx <= 0) mx = 1
        // A single value fills the track (approximating Recharts' single-point auto
        // domain); multiple rings use a nice upper bound to leave headroom.
        var domainMax = mx
        if (n > 1) {
            var step = _niceNum(mx / 4, true)
            domainMax = Math.ceil(mx / step) * step
        }
        var band = (g.oR - g.iR) / n
        var thickR = (n > 1) ? band * 0.72 : band

        // Grid circles (circle type) - drawn beneath the bars
        if (showGrid && polarGridCircle) {
            ctx.save()
            ctx.strokeStyle = Theme.border
            ctx.lineWidth = 1
            var rings = Math.max(2, n)
            for (var r = 0; r <= rings; r++) {
                var rad = g.iR + (g.oR - g.iR) * (r / rings)
                ctx.beginPath(); ctx.arc(cx, cy, rad, 0, 2 * Math.PI); ctx.stroke()
            }
            ctx.restore()
        }

        ctx.save()
        ctx.lineCap = radialCornerRadius > 0 ? "round" : "butt"
        for (var i = 0; i < n; i++) {
            var ringOuter = g.oR - i * band
            var midr = ringOuter - band / 2
            // Background track
            if (radialBackground) {
                ctx.lineWidth = thickR
                ctx.strokeStyle = Theme.muted
                ctx.beginPath(); ctx.arc(cx, cy, midr, g.start, g.start + g.sweep, false); ctx.stroke()
            }
            var val = Number(chartData[i][valueKey]) || 0
            var frac = Math.max(0, Math.min(1, val / domainMax))
            ctx.lineWidth = thickR
            ctx.strokeStyle = pieColor(chartData[i], i)
            ctx.beginPath(); ctx.arc(cx, cy, midr, g.start, g.start + frac * g.sweep, false); ctx.stroke()

            // In-ring label (nameKey, approximating LabelList insideStart)
            if (showBarLabels) {
                var lp = _radialLabelPoint(cx, cy, midr, g.start)
                ctx.save()
                ctx.fillStyle = "#ffffff"
                ctx.font = "11px '" + Theme.fontSans + "'"
                ctx.textAlign = "left"; ctx.textBaseline = "middle"
                var nm = String(chartData[i][nameKey] || "")
                nm = nm.charAt(0).toUpperCase() + nm.slice(1)
                ctx.fillText(nm, lp.x, lp.y)
                ctx.restore()
            }
        }
        ctx.restore()
    }
    function _radialLabelPoint(cx, cy, r, startAngle) {
        var a = startAngle + 0.06
        return { "x": cx + r * Math.cos(a) + 6, "y": cy + r * Math.sin(a) }
    }

    // ================= Hover hit-testing =================
    function _updateHover(mx, my) {
        if (!tooltipEnabled) return
        if (type === Chart.Pie) { _hoverPie(mx, my); return }
        if (type === Chart.Radar) { _hoverRadar(mx, my); return }
        if (type === Chart.Radial) { _hoverRadial(mx, my); return }
        _hoverCartesian(mx, my)
    }

    function _hoverCartesian(mx, my) {
        var n = chartData.length
        if (n === 0) { tip.visible = false; return }
        var best = -1, bestD = 1e9
        for (var i = 0; i < n; i++) {
            var c = _horizontalBar ? catCenterY(i) : catCenterX(i)
            var d = Math.abs((_horizontalBar ? my : mx) - c)
            if (d < bestD) { bestD = d; best = i }
        }
        if (best < 0) { tip.visible = false; return }
        hoverIndex = best
        hoverSeries = -1

        // Build tooltip items
        var items = []
        for (var j = 0; j < seriesKeys.length; j++) {
            var val = Number(chartData[best][seriesKeys[j]]) || 0
            items.push({ "color": colorFor(j),
                         "label": (series[j].label !== undefined ? series[j].label : series[j].key),
                         "value": _fmtVal(val) })
        }
        tip.labelText = chartData[best][categoryKey] !== undefined ? String(chartData[best][categoryKey]) : ""
        tip.items = items
        _placeTip(mx, my)
    }

    function _hoverPie(mx, my) {
        var g = _pieGeom()
        var dx = mx - g.cx, dy = my - g.cy
        var dist = Math.sqrt(dx * dx + dy * dy)
        if (dist > g.r + 6 || (innerRadius > 0 && dist < innerRadius)) {
            hoverSeries = -1; tip.visible = false; return
        }
        var total = 0
        for (var i = 0; i < chartData.length; i++) total += Number(chartData[i][valueKey]) || 0
        if (total <= 0) { tip.visible = false; return }
        var ang = Math.atan2(dy, dx)
        var norm = ang - (-Math.PI / 2)
        while (norm < 0) norm += 2 * Math.PI
        while (norm >= 2 * Math.PI) norm -= 2 * Math.PI
        var acc = 0, hit = -1
        for (var k = 0; k < chartData.length; k++) {
            var frac = (Number(chartData[k][valueKey]) || 0) / total
            if (norm >= acc && norm < acc + frac * 2 * Math.PI) { hit = k; break }
            acc += frac * 2 * Math.PI
        }
        if (hit < 0) { tip.visible = false; return }
        hoverSeries = hit
        hoverIndex = -1
        var d = chartData[hit]
        tip.labelText = ""
        tip.items = [{ "color": pieColor(d, hit),
                       "label": (d.label !== undefined ? d.label : d[nameKey]),
                       "value": _fmtVal(Number(d[valueKey]) || 0) }]
        _placeTip(mx, my)
    }

    function _hoverRadar(mx, my) {
        var n = chartData.length
        if (n === 0) { tip.visible = false; return }
        var g = _radarGeom()
        var dx = mx - g.cx, dy = my - g.cy
        if (Math.sqrt(dx * dx + dy * dy) > g.R + 20) { hoverIndex = -1; tip.visible = false; return }
        var ang = Math.atan2(dy, dx)
        var best = -1, bd = 1e9
        for (var i = 0; i < n; i++) {
            var ca = _radarAngle(i, n)
            var diff = Math.abs(((ang - ca + Math.PI) % (2 * Math.PI) + 2 * Math.PI) % (2 * Math.PI) - Math.PI)
            if (diff < bd) { bd = diff; best = i }
        }
        if (best < 0) { tip.visible = false; return }
        hoverIndex = best
        hoverSeries = -1
        var items = []
        for (var j = 0; j < seriesKeys.length; j++) {
            var val = Number(chartData[best][seriesKeys[j]]) || 0
            items.push({ "color": colorFor(j),
                         "label": (series[j].label !== undefined ? series[j].label : series[j].key),
                         "value": _fmtVal(val) })
        }
        tip.labelText = chartData[best][categoryKey] !== undefined ? String(chartData[best][categoryKey]) : ""
        tip.items = items
        _placeTip(mx, my)
    }

    function _hoverRadial(mx, my) {
        var n = chartData.length
        if (n === 0 || stacked) { tip.visible = false; return }
        var g = _radialGeom()
        var dx = mx - g.cx, dy = my - g.cy
        var dist = Math.sqrt(dx * dx + dy * dy)
        if (dist > g.oR || dist < g.iR) { hoverSeries = -1; tip.visible = false; return }
        var band = (g.oR - g.iR) / n
        var idx = Math.floor((g.oR - dist) / band)
        if (idx < 0 || idx >= n) { tip.visible = false; return }
        hoverSeries = idx
        hoverIndex = -1
        var d = chartData[idx]
        tip.labelText = ""
        tip.items = [{ "color": pieColor(d, idx),
                       "label": (d.label !== undefined ? d.label : d[nameKey]),
                       "value": _fmtVal(Number(d[valueKey]) || 0) }]
        _placeTip(mx, my)
    }

    function _placeTip(mx, my) {
        tip.visible = true
        var tx = mx + 12
        var ty = my - tip.implicitHeight - 8
        if (tx + tip.implicitWidth > plotArea.width) tx = mx - tip.implicitWidth - 12
        if (tx < 0) tx = 0
        if (ty < 0) ty = my + 12
        tip.x = tx
        tip.y = ty
    }
}
