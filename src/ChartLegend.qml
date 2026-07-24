import QtQuick
import QtQuick.Layouts

/*!
    \qmltype ChartLegend
    \inqmlmodule Shadcn
    \inherits Item
    \brief The legend row for a Chart, styled after shadcn's base-mira ChartLegendContent.

    ChartLegend lays out one entry per series (or per pie/radial slice) in a
    centered horizontal row (\c {flex items-center justify-center gap-4}). Each
    entry is an 8x8 \c rounded-[2px] color swatch (\c size-2) followed by a
    \c gap-1.5 text label at \c text-xs.

    It is a presentation-only helper driven by \l items; \l Chart builds that
    list from its series/config and embeds one ChartLegend above or below the
    plot. \l atTop mirrors shadcn's \c verticalAlign: top adds bottom padding
    (\c pb-3), bottom adds top padding (\c pt-3).
*/
Item {
    id: legend

    /*!
        \qmlproperty list ChartLegend::items
        The legend entries, each an object \c {{ label, color }}. \c label is the
        display text and \c color the swatch fill. Defaults to an empty list.
    */
    property var items: []

    /*!
        \qmlproperty bool ChartLegend::atTop
        Whether the legend sits above the plot. When \c true it uses bottom
        padding (\c pb-3); when \c false (the default) it uses top padding (\c pt-3).
    */
    property bool atTop: false

    implicitHeight: visible ? row.implicitHeight + Theme.space3 : 0
    implicitWidth: row.implicitWidth

    RowLayout {
        id: row
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: legend.atTop ? parent.top : undefined
        anchors.bottom: legend.atTop ? undefined : parent.bottom
        anchors.topMargin: legend.atTop ? 0 : Theme.space3
        anchors.bottomMargin: legend.atTop ? Theme.space3 : 0
        spacing: Theme.space4                     // gap-4

        Repeater {
            model: legend.items
            delegate: RowLayout {
                required property var modelData
                spacing: Theme.space1_5           // gap-1.5
                Rectangle {
                    Layout.preferredWidth: 8      // size-2 (8px)
                    Layout.preferredHeight: 8
                    radius: 2                     // rounded-[2px]
                    color: modelData.color
                }
                Text {
                    text: modelData.label !== undefined ? modelData.label : ""
                    color: Theme.foreground
                    font.pixelSize: Theme.textXs
                }
            }
        }
    }
}
