pragma Singleton
import QtQuick

// shadcn 设计令牌(base-mira · neutral · amber),与前端 prototype/app/globals.css 一一对应。
// oklch → sRGB 精确转换。切换明/暗只需设 Theme.dark。
//
// 主题定制(加法层,不改任何令牌名/默认值):
//   · lightOverrides / darkOverrides —— { tokenName: "#rrggbb", ... },覆盖对应模式的颜色令牌。
//   · radiusOverride —— >=0 时覆盖基础圆角(px);<0 用默认 10。
//   颜色令牌一律经 _resolve() 求值:先查当前模式的 override,未命中则回退内置值。
//   定制器通过 setToken()/setRadius()/resetTheme() 修改;因 var 需整体重赋才触发绑定,已封装。
QtObject {
    id: theme

    property bool dark: false

    // ==== 定制覆盖层 ====================================================
    property var lightOverrides: ({})
    property var darkOverrides: ({})
    property real radiusOverride: -1

    function _resolve(name, fallback) {
        var o = dark ? darkOverrides : lightOverrides
        return (o && o[name] !== undefined) ? o[name] : fallback
    }
    // 设置某令牌在指定模式的覆盖值(整体重赋以触发绑定刷新)。
    function setToken(name, value, forDark) {
        if (forDark) { let d = Object.assign({}, darkOverrides); d[name] = value; darkOverrides = d }
        else         { let l = Object.assign({}, lightOverrides); l[name] = value; lightOverrides = l }
    }
    function setRadius(px) { radiusOverride = px }
    function resetTheme() { lightOverrides = ({}); darkOverrides = ({}); radiusOverride = -1 }
    // 可枚举的颜色令牌名(定制器遍历用)。
    readonly property var colorTokenNames: [
        "background","foreground","card","cardForeground","popover","popoverForeground",
        "primary","primaryForeground","secondary","secondaryForeground","muted","mutedForeground",
        "accent","accentForeground","destructive","border","input","ring",
        "chart1","chart2","chart3","chart4","chart5",
        "sidebar","sidebarForeground","sidebarPrimary","sidebarPrimaryForeground",
        "sidebarAccent","sidebarAccentForeground","sidebarBorder","sidebarRing"
    ]
    // 当前模式某令牌的解析值(定制器取色/回显用)。
    function tokenColor(name) {
        switch (name) {
        case "background": return background; case "foreground": return foreground
        case "card": return card; case "cardForeground": return cardForeground
        case "popover": return popover; case "popoverForeground": return popoverForeground
        case "primary": return primary; case "primaryForeground": return primaryForeground
        case "secondary": return secondary; case "secondaryForeground": return secondaryForeground
        case "muted": return muted; case "mutedForeground": return mutedForeground
        case "accent": return accent; case "accentForeground": return accentForeground
        case "destructive": return destructive; case "border": return border
        case "input": return input; case "ring": return ring
        case "chart1": return chart1; case "chart2": return chart2; case "chart3": return chart3
        case "chart4": return chart4; case "chart5": return chart5
        case "sidebar": return sidebar; case "sidebarForeground": return sidebarForeground
        case "sidebarPrimary": return sidebarPrimary; case "sidebarPrimaryForeground": return sidebarPrimaryForeground
        case "sidebarAccent": return sidebarAccent; case "sidebarAccentForeground": return sidebarAccentForeground
        case "sidebarBorder": return sidebarBorder; case "sidebarRing": return sidebarRing
        }
        return "#000000"
    }
    // 导出配置(JSON):当前 radius + 明暗覆盖。开发者可存为品牌主题。
    function exportJson() {
        return JSON.stringify({
            radius: (radiusOverride >= 0 ? radiusOverride : 10),
            light: lightOverrides,
            dark: darkOverrides
        }, null, 2)
    }
    // 导入配置(JSON 字符串)。
    function importJson(text) {
        try {
            let cfg = JSON.parse(text)
            lightOverrides = cfg.light || ({})
            darkOverrides = cfg.dark || ({})
            radiusOverride = (cfg.radius !== undefined) ? cfg.radius : -1
            return true
        } catch (e) { return false }
    }

    // ==== 颜色令牌(globals.css :root / .dark 全量;经 _resolve 支持覆盖)========
    readonly property color background: _resolve("background", dark ? "#0a0a0a" : "#ffffff")
    readonly property color foreground: _resolve("foreground", dark ? "#fafafa" : "#0a0a0a")
    readonly property color card: _resolve("card", dark ? "#171717" : "#ffffff")
    readonly property color cardForeground: _resolve("cardForeground", dark ? "#fafafa" : "#0a0a0a")
    readonly property color popover: _resolve("popover", dark ? "#171717" : "#ffffff")
    readonly property color popoverForeground: _resolve("popoverForeground", dark ? "#fafafa" : "#0a0a0a")
    readonly property color primary: _resolve("primary", dark ? "#f0b100" : "#fdc700")
    readonly property color primaryForeground: _resolve("primaryForeground", dark ? "#733e0a" : "#733e0a")
    readonly property color secondary: _resolve("secondary", dark ? "#27272a" : "#f4f4f5")
    readonly property color secondaryForeground: _resolve("secondaryForeground", dark ? "#fafafa" : "#18181b")
    readonly property color muted: _resolve("muted", dark ? "#262626" : "#f5f5f5")
    readonly property color mutedForeground: _resolve("mutedForeground", dark ? "#a1a1a1" : "#737373")
    readonly property color accent: _resolve("accent", dark ? "#262626" : "#f5f5f5")
    readonly property color accentForeground: _resolve("accentForeground", dark ? "#fafafa" : "#171717")
    readonly property color destructive: _resolve("destructive", dark ? "#ff6467" : "#e7000b")
    readonly property color border: _resolve("border", dark ? "#1affffff" : "#e5e5e5")
    readonly property color input: _resolve("input", dark ? "#26ffffff" : "#e5e5e5")
    readonly property color ring: _resolve("ring", dark ? "#737373" : "#a1a1a1")
    readonly property color chart1: _resolve("chart1", "#ffd230")
    readonly property color chart2: _resolve("chart2", "#fe9a00")
    readonly property color chart3: _resolve("chart3", "#e17100")
    readonly property color chart4: _resolve("chart4", "#bb4d00")
    readonly property color chart5: _resolve("chart5", "#973c00")
    readonly property color sidebar: _resolve("sidebar", dark ? "#171717" : "#fafafa")
    readonly property color sidebarForeground: _resolve("sidebarForeground", dark ? "#fafafa" : "#0a0a0a")
    readonly property color sidebarPrimary: _resolve("sidebarPrimary", dark ? "#f0b100" : "#d08700")
    readonly property color sidebarPrimaryForeground: _resolve("sidebarPrimaryForeground", dark ? "#fefce8" : "#fefce8")
    readonly property color sidebarAccent: _resolve("sidebarAccent", dark ? "#262626" : "#f5f5f5")
    readonly property color sidebarAccentForeground: _resolve("sidebarAccentForeground", dark ? "#fafafa" : "#171717")
    readonly property color sidebarBorder: _resolve("sidebarBorder", dark ? "#1affffff" : "#e5e5e5")
    readonly property color sidebarRing: _resolve("sidebarRing", dark ? "#737373" : "#a1a1a1")

    // ==== 圆角(--radius 0.625rem;radiusOverride>=0 时覆盖)===================
    readonly property real radius: radiusOverride >= 0 ? radiusOverride : 10
    readonly property real radiusSm: radius * 0.6    // 6
    readonly property real radiusMd: radius * 0.8    // 8
    readonly property real radiusLg: radius          // 10
    readonly property real radiusXl: radius * 1.4    // 14
    readonly property real radius2xl: radius * 1.8   // 18
    readonly property real radius3xl: radius * 2.2   // 22
    readonly property real radius4xl: radius * 2.6   // 26
    readonly property real radiusFull: 9999          // 胶囊(rounded-full)

    // ==== 字体 ============================================================
    readonly property string fontSans: "Inter"
    readonly property string fontMono: "Geist Mono"
    readonly property string fontHeading: fontSans

    // ==== 焦点环(base-mira: ring-2 ring-ring/30 + border→ring)==============
    readonly property real ringWidth: 2
    readonly property real ringOpacity: 0.30

    // ==== 浮层立体感(ring-1 ring-foreground/10 + shadow-md)=================
    readonly property color overlayRing: alpha(foreground, 0.10)
    readonly property real overlayRingWidth: 1
    readonly property color shadowColor: alpha("#000000", dark ? 0.5 : 0.12)
    readonly property real shadowBlur: 0.5
    readonly property real shadowOffset: 4

    // ==== 间距(Tailwind spacing = rem × 4 → px)============================
    readonly property real space0_5: 2
    readonly property real space1: 4
    readonly property real space1_5: 6
    readonly property real space2: 8
    readonly property real space2_5: 10
    readonly property real space3: 12
    readonly property real space3_5: 14
    readonly property real space4: 16
    readonly property real space5: 20
    readonly property real space6: 24
    readonly property real space8: 32

    // ==== 字号(Tailwind text-xs..4xl)=====================================
    readonly property int textXs: 12
    readonly property int textSm: 14
    readonly property int textBase: 16
    readonly property int textLg: 18
    readonly property int textXl: 20
    readonly property int text2xl: 24
    readonly property int text3xl: 30
    readonly property int text4xl: 36
    // 行高
    readonly property real lineRelaxed: 1.625

    // ==== 动效 ============================================================
    readonly property int durFast: 100
    readonly property int durBase: 150

    // 令牌色 × 不透明度(对标 CSS 的 color/NN)。
    function alpha(c, a) { return Qt.rgba(c.r, c.g, c.b, a) }
}
