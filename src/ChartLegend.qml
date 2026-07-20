import QtQuick
import QtQuick.Layouts

// shadcn ChartLegendContent(base-mira)—— 图表图例行。
// 对标 flex items-center justify-center gap-4;每项 8×8 rounded-[2px] 色块 + gap-1.5 标签。
// items:[{ label, color }]。verticalAlign top → pb-3;bottom → pt-3。
Item {
    id: legend

    property var items: []
    property bool atTop: false       // true: 图例在图上方(pb-3);false: 下方(pt-3)

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
                    Layout.preferredWidth: 8      // size-2
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
