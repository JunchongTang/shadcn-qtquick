import QtQuick
import QtQuick.Layouts
import Shadcn

// 仿官方 badge-colors:用字面 hex 覆盖 bgColor/fgColor(Tailwind *-50/*-700 浅色档)。
RowLayout {
    spacing: 8

    Badge { text: qsTr("Blue");   bgColor: "#eff6ff"; fgColor: "#1d4ed8" }
    Badge { text: qsTr("Green");  bgColor: "#f0fdf4"; fgColor: "#15803d" }
    Badge { text: qsTr("Sky");    bgColor: "#f0f9ff"; fgColor: "#0369a1" }
    Badge { text: qsTr("Purple"); bgColor: "#faf5ff"; fgColor: "#7e22ce" }
    Badge { text: qsTr("Red");    bgColor: "#fef2f2"; fgColor: "#b91c1c" }
}
