import QtQuick
import QtQuick.Layouts
import Shadcn

// Mimics the official badge-colors: override bgColor/fgColor with literal hex (Tailwind *-50/*-700 light shades).
RowLayout {
    spacing: 8

    Badge { text: qsTr("Blue");   bgColor: "#eff6ff"; fgColor: "#1d4ed8" }
    Badge { text: qsTr("Green");  bgColor: "#f0fdf4"; fgColor: "#15803d" }
    Badge { text: qsTr("Sky");    bgColor: "#f0f9ff"; fgColor: "#0369a1" }
    Badge { text: qsTr("Purple"); bgColor: "#faf5ff"; fgColor: "#7e22ce" }
    Badge { text: qsTr("Red");    bgColor: "#fef2f2"; fgColor: "#b91c1c" }
}
