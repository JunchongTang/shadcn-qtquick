pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Shadcn
import LucideIcons

// Theme customizer — mirrors the two-pane experience of ui.shadcn.com/create:
//   Left: dark floating customization panel (compact dropdown picker rows, matching the official className="dark" customize card);
//   Right: live preview-02 bento dashboard (CreateDashboard, the whole library restyles instantly with the theme).
// All driven through the Theme overlay (setToken/setRadius/resetTheme/exportJson). Web-only features
// (v0, Get Code, share links, preset API, style/icon/font library pickers) don't apply in the desktop library, so they're omitted.
Item {
    id: page

    property real viewportHeight: 600
    implicitHeight: viewportHeight

    // ==== base color scheme: sets the neutral palette (light/dark). card/popover=bg, secondary/accent=muted, input=border ====
    readonly property var baseColors: [
        { name: "Neutral", dot: "#737373",
          l: { bg: "#ffffff", fg: "#0a0a0a", muted: "#f5f5f5", mutedFg: "#737373", border: "#e5e5e5", ring: "#a1a1a1" },
          d: { bg: "#0a0a0a", fg: "#fafafa", muted: "#262626", mutedFg: "#a1a1a1", border: "#2a2a2a", ring: "#737373" } },
        { name: "Stone", dot: "#78716c",
          l: { bg: "#ffffff", fg: "#1c1917", muted: "#f5f5f4", mutedFg: "#78716c", border: "#e7e5e4", ring: "#a8a29e" },
          d: { bg: "#0c0a09", fg: "#fafaf9", muted: "#292524", mutedFg: "#a8a29e", border: "#292524", ring: "#78716c" } },
        { name: "Zinc", dot: "#71717a",
          l: { bg: "#ffffff", fg: "#18181b", muted: "#f4f4f5", mutedFg: "#71717a", border: "#e4e4e7", ring: "#a1a1aa" },
          d: { bg: "#09090b", fg: "#fafafa", muted: "#27272a", mutedFg: "#a1a1aa", border: "#27272a", ring: "#71717a" } },
        { name: "Slate", dot: "#64748b",
          l: { bg: "#ffffff", fg: "#0f172a", muted: "#f1f5f9", mutedFg: "#64748b", border: "#e2e8f0", ring: "#94a3b8" },
          d: { bg: "#020817", fg: "#f8fafc", muted: "#1e293b", mutedFg: "#94a3b8", border: "#1e293b", ring: "#64748b" } },
        { name: "Gray", dot: "#6b7280",
          l: { bg: "#ffffff", fg: "#111827", muted: "#f3f4f6", mutedFg: "#6b7280", border: "#e5e7eb", ring: "#9ca3af" },
          d: { bg: "#030712", fg: "#f9fafb", muted: "#1f2937", mutedFg: "#9ca3af", border: "#1f2937", ring: "#6b7280" } }
    ]

    // ==== accent color: sets primary + primaryForeground (light/dark) ====
    readonly property var accents: [
        { name: "Amber",  dot: "#f0b100", lp: "#fdc700", lf: "#733e0a", dp: "#f0b100", df: "#733e0a" },
        { name: "Blue",   dot: "#3b82f6", lp: "#2563eb", lf: "#ffffff", dp: "#3b82f6", df: "#ffffff" },
        { name: "Green",  dot: "#10b981", lp: "#059669", lf: "#ffffff", dp: "#10b981", df: "#052e16" },
        { name: "Rose",   dot: "#f43f5e", lp: "#e11d48", lf: "#ffffff", dp: "#f43f5e", df: "#4c0519" },
        { name: "Violet", dot: "#8b5cf6", lp: "#7c3aed", lf: "#ffffff", dp: "#8b5cf6", df: "#ffffff" },
        { name: "Orange", dot: "#f97316", lp: "#ea580c", lf: "#ffffff", dp: "#f97316", df: "#431407" },
        { name: "Mono",   dot: "#171717", lp: "#171717", lf: "#fafafa", dp: "#fafafa", df: "#171717" }
    ]
    readonly property var radii: [0, 4, 8, 10, 14, 16]

    // ==== chart palette: each scheme sets chart1..chart5 (shared by light/dark) ====
    readonly property var chartPalettes: [
        { name: "Amber",   c: ["#ffd230", "#fe9a00", "#e17100", "#bb4d00", "#973c00"] },
        { name: "Blue",    c: ["#93c5fd", "#60a5fa", "#3b82f6", "#2563eb", "#1d4ed8"] },
        { name: "Green",   c: ["#6ee7b7", "#34d399", "#10b981", "#059669", "#047857"] },
        { name: "Violet",  c: ["#c4b5fd", "#a78bfa", "#8b5cf6", "#7c3aed", "#6d28d9"] },
        { name: "Rose",    c: ["#fda4af", "#fb7185", "#f43f5e", "#e11d48", "#be123c"] },
        { name: "Neutral", c: ["#d4d4d4", "#a3a3a3", "#737373", "#525252", "#404040"] }
    ]

    // Current selection state shown by the panel.
    property string baseName: "Neutral"
    property color  baseDot: "#737373"
    property string accentName: "Amber"
    property color  accentDot: "#f0b100"
    property string chartName: "Amber"
    property color  chartDot: "#fe9a00"
    property int    radiusValue: 10

    // Panel is fixed dark (matches the official className="dark" customize card, doesn't follow the app's light/dark mode).
    readonly property color pBg: "#0a0a0a"
    readonly property color pBorder: "#262626"
    readonly property color pText: "#fafafa"
    readonly property color pMuted: "#a1a1a1"
    readonly property color pHover: "#1f1f22"

    function applyBase(b) {
        var map = { "background": b.l.bg, "foreground": b.l.fg, "card": b.l.bg, "cardForeground": b.l.fg,
                    "popover": b.l.bg, "popoverForeground": b.l.fg, "secondary": b.l.muted, "secondaryForeground": b.l.fg,
                    "muted": b.l.muted, "mutedForeground": b.l.mutedFg, "accent": b.l.muted, "accentForeground": b.l.fg,
                    "border": b.l.border, "input": b.l.border, "ring": b.l.ring }
        for (var k in map) Theme.setToken(k, map[k], false)
        var dmap = { "background": b.d.bg, "foreground": b.d.fg, "card": b.d.bg, "cardForeground": b.d.fg,
                     "popover": b.d.bg, "popoverForeground": b.d.fg, "secondary": b.d.muted, "secondaryForeground": b.d.fg,
                     "muted": b.d.muted, "mutedForeground": b.d.mutedFg, "accent": b.d.muted, "accentForeground": b.d.fg,
                     "border": b.d.border, "input": b.d.border, "ring": b.d.ring }
        for (var dk in dmap) Theme.setToken(dk, dmap[dk], true)
        page.baseName = b.name; page.baseDot = b.dot
    }
    function applyAccent(a) {
        Theme.setToken("primary", a.lp, false); Theme.setToken("primaryForeground", a.lf, false)
        Theme.setToken("primary", a.dp, true);  Theme.setToken("primaryForeground", a.df, true)
        page.accentName = a.name; page.accentDot = a.dot
    }
    function setRadius(px) { Theme.setRadius(px); page.radiusValue = px }
    function applyChartColor(p) {
        for (var i = 0; i < 5; i++) {
            Theme.setToken("chart" + (i + 1), p.c[i], false)
            Theme.setToken("chart" + (i + 1), p.c[i], true)
        }
        page.chartName = p.name; page.chartDot = p.c[1]
    }
    function resetState() {
        baseName = "Neutral"; baseDot = "#737373"
        accentName = "Amber"; accentDot = "#f0b100"
        chartName = "Amber"; chartDot = "#fe9a00"; radiusValue = 10
    }
    function randomize() {
        applyBase(baseColors[Math.floor(Math.random() * baseColors.length)])
        applyAccent(accents[Math.floor(Math.random() * accents.length)])
        setRadius(radii[Math.floor(Math.random() * radii.length)])
    }

    // Compact picker row: small label + current value + right-side color dot/icon; click pops up a menu (default children are the menu items).
    component PickerRow: Rectangle {
        id: prow
        property string label: ""
        property string valueText: ""
        property bool hasDot: false
        property color dotColor: "transparent"
        property string iconName: "chevron-down"
        default property alias menuData: prowMenu.contentData
        Layout.fillWidth: true
        implicitHeight: 46
        radius: Theme.radiusMd
        color: prowHover.hovered ? page.pHover : "transparent"
        HoverHandler { id: prowHover; cursorShape: Qt.PointingHandCursor }
        TapHandler { onTapped: prowMenu.popup(0, prow.height + 2) }
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            spacing: 8
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1
                Text { text: prow.label; color: page.pMuted; font.pixelSize: 11; font.weight: Font.Medium }
                Text {
                    Layout.fillWidth: true
                    text: prow.valueText; color: page.pText
                    font.pixelSize: Theme.textSm; font.weight: Font.Medium
                    elide: Text.ElideRight
                }
            }
            Rectangle {
                visible: prow.hasDot
                implicitWidth: 16; implicitHeight: 16; radius: 8
                color: prow.dotColor
                border.width: 1; border.color: "#3a3a3a"
            }
            LucideIcon { visible: !prow.hasDot && prow.iconName !== ""; name: prow.iconName; size: 15; color: page.pMuted }
        }
        Menu { id: prowMenu }
    }

    // Dark small button (panel bottom actions; not using the library Button to avoid conflicting with the app's light/dark mode).
    component DarkBtn: Rectangle {
        id: dbtn
        property string label: ""
        property string iconName: ""
        property bool prominent: false
        signal clicked()
        Layout.fillWidth: true
        implicitHeight: 32
        radius: Theme.radiusMd
        color: prominent ? page.pText : (dbtnHover.hovered ? "#27272a" : "#18181b")
        HoverHandler { id: dbtnHover; cursorShape: Qt.PointingHandCursor }
        TapHandler { onTapped: dbtn.clicked() }
        RowLayout {
            anchors.centerIn: parent
            spacing: 6
            LucideIcon { visible: dbtn.iconName !== ""; name: dbtn.iconName; size: 14; color: dbtn.prominent ? "#0a0a0a" : page.pText }
            Text { text: dbtn.label; color: dbtn.prominent ? "#0a0a0a" : page.pText; font.pixelSize: Theme.textXs; font.weight: Font.Medium }
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 16

        // ============================ Left: dark customization panel (matches the official site) ============================
        Rectangle {
            Layout.preferredWidth: 240
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop
            radius: Theme.radiusLg
            color: page.pBg
            border.width: 1
            border.color: page.pBorder

            ScrollView {
                id: panelScroll
                anchors.fill: parent
                anchors.margins: 8
                clip: true
                contentWidth: availableWidth

                ColumnLayout {
                    width: panelScroll.availableWidth
                    spacing: 2

                    Text {
                        text: qsTr("Customize")
                        color: page.pText
                        font.pixelSize: Theme.textBase
                        font.weight: Font.DemiBold
                        Layout.margins: 8
                    }
                    Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: page.pBorder }

                    // Style (single, static display)
                    PickerRow {
                        label: qsTr("Style"); valueText: qsTr("Mira")
                        MenuItem { text: qsTr("Mira") }
                    }
                    // Base color
                    PickerRow {
                        label: qsTr("Base color"); valueText: page.baseName; hasDot: true; dotColor: page.baseDot
                        MenuItem { text: qsTr("Neutral"); onTriggered: page.applyBase(page.baseColors[0]) }
                        MenuItem { text: qsTr("Stone");   onTriggered: page.applyBase(page.baseColors[1]) }
                        MenuItem { text: qsTr("Zinc");    onTriggered: page.applyBase(page.baseColors[2]) }
                        MenuItem { text: qsTr("Slate");   onTriggered: page.applyBase(page.baseColors[3]) }
                        MenuItem { text: qsTr("Gray");    onTriggered: page.applyBase(page.baseColors[4]) }
                    }
                    // Theme (accent)
                    PickerRow {
                        label: qsTr("Theme"); valueText: page.accentName; hasDot: true; dotColor: page.accentDot
                        MenuItem { text: qsTr("Amber");  onTriggered: page.applyAccent(page.accents[0]) }
                        MenuItem { text: qsTr("Blue");   onTriggered: page.applyAccent(page.accents[1]) }
                        MenuItem { text: qsTr("Green");  onTriggered: page.applyAccent(page.accents[2]) }
                        MenuItem { text: qsTr("Rose");   onTriggered: page.applyAccent(page.accents[3]) }
                        MenuItem { text: qsTr("Violet"); onTriggered: page.applyAccent(page.accents[4]) }
                        MenuItem { text: qsTr("Orange"); onTriggered: page.applyAccent(page.accents[5]) }
                        MenuItem { text: qsTr("Mono");   onTriggered: page.applyAccent(page.accents[6]) }
                    }
                    // Chart color
                    PickerRow {
                        label: qsTr("Chart color"); valueText: page.chartName; hasDot: true; dotColor: page.chartDot
                        MenuItem { text: qsTr("Amber");   onTriggered: page.applyChartColor(page.chartPalettes[0]) }
                        MenuItem { text: qsTr("Blue");    onTriggered: page.applyChartColor(page.chartPalettes[1]) }
                        MenuItem { text: qsTr("Green");   onTriggered: page.applyChartColor(page.chartPalettes[2]) }
                        MenuItem { text: qsTr("Violet");  onTriggered: page.applyChartColor(page.chartPalettes[3]) }
                        MenuItem { text: qsTr("Rose");    onTriggered: page.applyChartColor(page.chartPalettes[4]) }
                        MenuItem { text: qsTr("Neutral"); onTriggered: page.applyChartColor(page.chartPalettes[5]) }
                    }
                    // Heading font
                    PickerRow {
                        label: qsTr("Heading"); valueText: Theme.fontHeading; iconName: "type"
                        MenuItem { text: "Inter";           onTriggered: Theme.fontHeadingOverride = "Inter" }
                        MenuItem { text: "Helvetica";       onTriggered: Theme.fontHeadingOverride = "Helvetica" }
                        MenuItem { text: "Georgia";         onTriggered: Theme.fontHeadingOverride = "Georgia" }
                        MenuItem { text: "Times New Roman"; onTriggered: Theme.fontHeadingOverride = "Times New Roman" }
                        MenuItem { text: "Courier New";     onTriggered: Theme.fontHeadingOverride = "Courier New" }
                    }
                    // Body font
                    PickerRow {
                        label: qsTr("Font"); valueText: Theme.fontSans; iconName: "type"
                        MenuItem { text: "Inter";           onTriggered: Theme.fontBodyOverride = "Inter" }
                        MenuItem { text: "Helvetica";       onTriggered: Theme.fontBodyOverride = "Helvetica" }
                        MenuItem { text: "Georgia";         onTriggered: Theme.fontBodyOverride = "Georgia" }
                        MenuItem { text: "Times New Roman"; onTriggered: Theme.fontBodyOverride = "Times New Roman" }
                        MenuItem { text: "Courier New";     onTriggered: Theme.fontBodyOverride = "Courier New" }
                    }
                    // Icon library (Lucide only)
                    PickerRow {
                        label: qsTr("Icon Library"); valueText: qsTr("Lucide")
                        MenuItem { text: qsTr("Lucide") }
                    }
                    // Radius
                    PickerRow {
                        label: qsTr("Radius"); valueText: page.radiusValue + qsTr(" px")
                        MenuItem { text: "0";  onTriggered: page.setRadius(0) }
                        MenuItem { text: "4";  onTriggered: page.setRadius(4) }
                        MenuItem { text: "8";  onTriggered: page.setRadius(8) }
                        MenuItem { text: "10"; onTriggered: page.setRadius(10) }
                        MenuItem { text: "14"; onTriggered: page.setRadius(14) }
                        MenuItem { text: "16"; onTriggered: page.setRadius(16) }
                    }
                    // Mode
                    PickerRow {
                        label: qsTr("Mode"); valueText: Theme.dark ? qsTr("Dark") : qsTr("Light")
                        iconName: Theme.dark ? "moon" : "sun"
                        MenuItem { text: qsTr("Light"); onTriggered: Theme.dark = false }
                        MenuItem { text: qsTr("Dark");  onTriggered: Theme.dark = true }
                    }

                    Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: page.pBorder; Layout.topMargin: 6 }

                    // Actions
                    DarkBtn { label: qsTr("Shuffle"); iconName: "shuffle"; prominent: true; Layout.topMargin: 6; onClicked: page.randomize() }
                    DarkBtn {
                        id: copyBtn
                        property bool _done: false
                        label: copyBtn._done ? qsTr("Copied!") : qsTr("Copy theme")
                        iconName: copyBtn._done ? "check" : "copy"
                        onClicked: { SourceReader.copyToClipboard(Theme.exportJson()); copyBtn._done = true; copyTimer.restart() }
                        Timer { id: copyTimer; interval: 1200; onTriggered: copyBtn._done = false }
                    }
                    DarkBtn { label: qsTr("Reset"); iconName: "rotate-ccw"; onClicked: { Theme.resetTheme(); page.resetState() } }
                }
            }
        }

        // ==================== Right: live showcase — preview-02 bento dashboard ====================
        CreateDashboard {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
