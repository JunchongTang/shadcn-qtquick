import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

/*!
    \qmltype ChartTooltip
    \inqmlmodule Shadcn
    \inherits Item
    \brief The hover tooltip for a Chart, styled after shadcn's base-mira ChartTooltipContent.

    ChartTooltip is the floating card shown while hovering a chart data point.
    It mirrors shadcn's \c .cn-chart-tooltip: a \c bg-background card with a
    \c border-border/50 hairline, \c rounded-lg corners, \c px-2.5 / \c py-1.5
    padding, \c text-xs body, \c shadow-xl elevation, \c gap-1.5 row spacing and
    a \c min-w-32 (128px) minimum width.

    The layout is an optional \l labelText line (\c font-medium) followed by one
    row per entry in \l items, each row being
    \c {[indicator] [name (muted)]  <->  [value (mono, medium)]}. \l Chart owns
    a single instance and feeds it while tracking the pointer.

    \note This is a simplified port: shadcn's \c nestLabel behaviour (folding the
    label into a single-series row) is not reproduced, and the \c dashed
    indicator is approximated with a hollow outlined square rather than a
    zero-width dashed rule.
*/
Item {
    id: tip

    // The per-row swatch style, matching shadcn's indicator prop. Dot is first (value 0).
    enum Indicator { Dot, Line, Dashed }

    /*!
        \qmlproperty string ChartTooltip::labelText
        The heading line (typically the category, e.g. the x-axis value). Empty,
        or when \l showLabel is \c false, hides the heading. Defaults to \c "".
    */
    property string labelText: ""

    /*!
        \qmlproperty bool ChartTooltip::showLabel
        Whether the \l labelText heading is shown. Mirrors the inverse of
        shadcn's \c hideLabel. Defaults to \c true.
    */
    property bool showLabel: true

    /*!
        \qmlproperty list ChartTooltip::items
        The rows to display, each an object \c {{ color, label, value }}: \c color
        is the indicator color, \c label the (muted) series name and \c value the
        pre-formatted display value. Defaults to an empty list.
    */
    property var items: []

    /*!
        \qmlproperty enumeration ChartTooltip::indicator
        The row swatch style, matching shadcn's \c indicator prop.
        Defaults to \c ChartTooltip.Dot.

        \value ChartTooltip.Dot Filled rounded square (\c size-2.5).
        \value ChartTooltip.Line Thin filled vertical bar (\c w-1).
        \value ChartTooltip.Dashed Hollow outlined square (approximates \c border-dashed).
    */
    property int indicator: ChartTooltip.Dot

    readonly property real _padX: Theme.space2_5   // px-2.5 (10px)
    readonly property real _padY: Theme.space1_5   // py-1.5 (6px)

    implicitWidth: Math.max(128, box.implicitWidth)   // min-w-32
    implicitHeight: box.implicitHeight

    Rectangle {
        id: box
        width: tip.implicitWidth
        implicitWidth: content.implicitWidth + tip._padX * 2
        implicitHeight: content.implicitHeight + tip._padY * 2
        radius: Theme.radiusLg
        color: Theme.background
        border.width: 1
        border.color: Theme.alpha(Theme.border, 0.5)   // border-border/50

        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: true
            shadowEnabled: true
            shadowColor: Theme.alpha("#000000", Theme.dark ? 0.6 : 0.22)  // shadow-xl (approx)
            shadowBlur: 0.7
            shadowVerticalOffset: 8
        }

        ColumnLayout {
            id: content
            x: tip._padX
            y: tip._padY
            width: box.width - tip._padX * 2
            spacing: Theme.space1_5              // gap-1.5

            Text {
                visible: tip.showLabel && tip.labelText !== ""
                Layout.fillWidth: true
                text: tip.labelText
                color: Theme.foreground
                font.pixelSize: Theme.textXs
                font.weight: Font.Medium
            }

            Repeater {
                model: tip.items
                delegate: RowLayout {
                    required property var modelData
                    Layout.fillWidth: true
                    spacing: Theme.space2            // gap-2

                    // ---- Indicator swatch ----
                    Item {
                        Layout.alignment: tip.indicator === ChartTooltip.Dot ? Qt.AlignVCenter : Qt.AlignTop
                        Layout.topMargin: tip.indicator === ChartTooltip.Dot ? 0 : 2
                        implicitWidth: tip.indicator === ChartTooltip.Dot ? 10 : (tip.indicator === ChartTooltip.Line ? 4 : 10)
                        implicitHeight: tip.indicator === ChartTooltip.Dot ? 10 : 10

                        // dot / line: filled rounded block; dashed: hollow outlined square
                        Rectangle {
                            anchors.fill: parent
                            radius: 2
                            visible: tip.indicator !== ChartTooltip.Dashed
                            color: modelData.color
                        }
                        Rectangle {
                            anchors.fill: parent
                            radius: 2
                            visible: tip.indicator === ChartTooltip.Dashed
                            color: "transparent"
                            border.width: 1.5
                            border.color: modelData.color
                        }
                    }

                    Text {
                        text: modelData.label !== undefined ? modelData.label : ""
                        color: Theme.mutedForeground
                        font.pixelSize: Theme.textXs
                    }
                    Item { Layout.fillWidth: true; implicitWidth: Theme.space3 }
                    Text {
                        text: modelData.value !== undefined ? modelData.value : ""
                        color: Theme.foreground
                        font.pixelSize: Theme.textXs
                        font.weight: Font.Medium
                        font.family: Theme.fontMono
                    }
                }
            }
        }
    }
}
