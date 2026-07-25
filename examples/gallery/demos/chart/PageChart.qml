import QtQuick

PageScaffold {
    description: qsTr("Beautiful charts. Faithful QML port of the shadcn/ui Chart, hand-drawn with Canvas (bar / line / area / pie / radar / radial).")

    ExampleCard {
        title: qsTr("Bar Chart")
        description: qsTr("A single-series bar chart with a grid, x-axis and rounded bars. Hover a bar to see its value.")
        source: "qrc:/demos/chart/Bar.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Bar Chart - Multiple")
        description: qsTr("Grouped bars for two series, a legend and a dashed tooltip indicator.")
        source: "qrc:/demos/chart/BarMultiple.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Bar Chart - Horizontal")
        description: qsTr("Swap the axes to lay the bars out horizontally with category labels on the left.")
        source: "qrc:/demos/chart/BarHorizontal.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Bar Chart - Label")
        description: qsTr("Render the value of each bar as a label above it.")
        source: "qrc:/demos/chart/BarLabel.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Line Chart")
        description: qsTr("A smooth (natural) single line with grid and tooltip.")
        source: "qrc:/demos/chart/Line.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Line Chart - Multiple")
        description: qsTr("Two lines coloured from the chart palette with a legend.")
        source: "qrc:/demos/chart/LineMultiple.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Area Chart")
        description: qsTr("A filled area under a smooth line with a line-style tooltip indicator.")
        source: "qrc:/demos/chart/Area.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Area Chart - Stacked")
        description: qsTr("Stack multiple areas to show cumulative totals per category.")
        source: "qrc:/demos/chart/AreaStacked.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Pie Chart")
        description: qsTr("A pie chart with slices coloured from chart-1..5. Hover a slice for its value.")
        source: "qrc:/demos/chart/Pie.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Pie Chart - Donut")
        description: qsTr("Add an inner radius to turn the pie into a donut.")
        source: "qrc:/demos/chart/PieDonut.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Radar Chart")
        description: qsTr("A polar radar plot with a polygon grid and a single filled series. Hover a spoke for its value.")
        source: "qrc:/demos/chart/Radar.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Radar Chart - Dots")
        description: qsTr("Mark each data point on the radar polygon with a dot.")
        source: "qrc:/demos/chart/RadarDots.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Radar Chart - Multiple")
        description: qsTr("Overlay two series with a line-style tooltip indicator.")
        source: "qrc:/demos/chart/RadarMultiple.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Radar Chart - Legend")
        description: qsTr("Two radar series with a bottom legend from the chart palette.")
        source: "qrc:/demos/chart/RadarLegend.qml"
        previewMinHeight: 520
    }
    ExampleCard {
        title: qsTr("Radar Chart - Lines Only")
        description: qsTr("Drop the fill and radial spokes to show outlines only.")
        source: "qrc:/demos/chart/RadarLinesOnly.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Radar Chart - Grid Circle")
        description: qsTr("Use a concentric-circle grid instead of a polygon grid.")
        source: "qrc:/demos/chart/RadarGridCircle.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Radial Chart")
        description: qsTr("Concentric radial bars with a background track. Hover a bar for its value.")
        source: "qrc:/demos/chart/RadialSimple.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Radial Chart - Grid")
        description: qsTr("Radial bars over a concentric-circle polar grid.")
        source: "qrc:/demos/chart/RadialGrid.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Radial Chart - Label")
        description: qsTr("Render each category name inside the start of its bar.")
        source: "qrc:/demos/chart/RadialLabel.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Radial Chart - Text")
        description: qsTr("A single radial bar with a rounded cap and a centred value label.")
        source: "qrc:/demos/chart/RadialText.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Radial Chart - Shape")
        description: qsTr("A short radial arc used as a stat gauge with a big centred number.")
        source: "qrc:/demos/chart/RadialShape.qml"
        previewMinHeight: 480
    }
    ExampleCard {
        title: qsTr("Radial Chart - Stacked")
        description: qsTr("Stack two series along a half-circle gauge with a centred total.")
        source: "qrc:/demos/chart/RadialStacked.qml"
        previewMinHeight: 480
    }
}
