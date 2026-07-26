pragma Singleton
import QtQuick

/*!
    \qmltype Theme
    \inqmlmodule Shadcn
    \inherits QtObject
    \brief Application-wide design-token singleton for the shadcn (base-mira) port.

    Theme is the single source of truth for every design token used across the
    library: colors, radii, spacing, typography sizes, focus-ring metrics,
    overlay elevation, and animation durations. Every component reads its
    appearance from this singleton, so the token names and default values are a
    stable public contract and must not be renamed.

    The values mirror shadcn/ui's base-mira style (neutral surfaces, amber
    primary), with oklch source colors converted to sRGB. Light and dark
    palettes are selected by the single \l dark flag.

    An additive customization layer sits on top of the built-in defaults:
    \l lightOverrides / \l darkOverrides override individual color tokens per
    mode, and \l radiusOverride overrides the base corner radius. Every color
    token is resolved through the override map first and falls back to its
    built-in value when no override is present. Because overrides are stored in
    \c var maps, they are reassigned wholesale (see \l setToken) so bindings
    re-evaluate.

    \note This type is registered as a QML singleton; reference tokens directly,
    e.g. \c {Theme.primary} or \c {Theme.space4}.

    \sa {Shadcn}{Shadcn QML Components}
*/
QtObject {
    id: theme

    /*!
        \qmlproperty bool Theme::dark
        Selects the dark palette when \c true and the light palette when \c false
        (the default). Toggling it re-evaluates every color token.
    */
    property bool dark: false

    // ==== Customization override layer ==================================
    /*!
        \qmlproperty var Theme::lightOverrides
        \qmlproperty var Theme::darkOverrides
        Per-mode color override maps of the form \c {{ tokenName: "#rrggbb" }}. A
        token present here wins over its built-in value for that mode.
    */
    property var lightOverrides: ({})
    property var darkOverrides: ({})
    /*!
        \qmlproperty real Theme::radiusOverride
        Overrides the base corner radius in pixels when \c {>= 0}; a negative value
        (the default) keeps the built-in base radius of 10.
    */
    property real radiusOverride: -1

    // Resolve a color token: prefer the active mode's override, else fallback.
    function _resolve(name, fallback) {
        var o = dark ? darkOverrides : lightOverrides
        return (o && o[name] !== undefined) ? o[name] : fallback
    }

    /*!
        \qmlmethod void Theme::setToken(string name, color value, bool forDark)
        Sets the override \a value for color token \a name. Targets the dark
        palette when \a forDark is \c true, otherwise the light palette. The
        override map is reassigned wholesale so dependent bindings refresh.
    */
    function setToken(name, value, forDark) {
        if (forDark) { let d = Object.assign({}, darkOverrides); d[name] = value; darkOverrides = d }
        else         { let l = Object.assign({}, lightOverrides); l[name] = value; lightOverrides = l }
    }

    /*!
        \qmlmethod void Theme::setRadius(real px)
        Overrides the base corner radius with \a px pixels.
    */
    function setRadius(px) { radiusOverride = px }

    /*!
        \qmlmethod void Theme::resetTheme()
        Clears all color, radius and font overrides, restoring the defaults.
    */
    function resetTheme() {
        lightOverrides = ({}); darkOverrides = ({}); radiusOverride = -1
        fontBodyOverride = ""; fontHeadingOverride = ""
    }

    // Enumerable color-token names (used by customizers to iterate tokens).
    readonly property var colorTokenNames: [
        "background","foreground","card","cardForeground","popover","popoverForeground",
        "primary","primaryForeground","secondary","secondaryForeground","muted","mutedForeground",
        "accent","accentForeground","destructive","border","input","ring",
        "chart1","chart2","chart3","chart4","chart5",
        "sidebar","sidebarForeground","sidebarPrimary","sidebarPrimaryForeground",
        "sidebarAccent","sidebarAccentForeground","sidebarBorder","sidebarRing"
    ]

    /*!
        \qmlmethod color Theme::tokenColor(string name)
        Returns the resolved value of color token \a name in the active mode.
        Used by customizers to read or echo a token's current color.
    */
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

    /*!
        \qmlmethod string Theme::exportJson()
        Serializes the current customization (base radius plus light/dark
        overrides) to a JSON string that can be persisted as a brand theme.
    */
    function exportJson() {
        return JSON.stringify({
            radius: (radiusOverride >= 0 ? radiusOverride : 10),
            light: lightOverrides,
            dark: darkOverrides
        }, null, 2)
    }

    /*!
        \qmlmethod bool Theme::importJson(string text)
        Loads a customization from the JSON string \a text (as produced by
        \l exportJson). Returns \c true on success, \c false on a parse error.
    */
    function importJson(text) {
        try {
            let cfg = JSON.parse(text)
            lightOverrides = cfg.light || ({})
            darkOverrides = cfg.dark || ({})
            radiusOverride = (cfg.radius !== undefined) ? cfg.radius : -1
            return true
        } catch (e) { return false }
    }

    // ==== Color tokens (globals.css :root / .dark, resolved via _resolve) ====
    /*!
        \qmlproperty color Theme::background
        \qmlproperty color Theme::foreground
        \qmlproperty color Theme::primary
        \qmlproperty color Theme::secondary
        \qmlproperty color Theme::muted
        \qmlproperty color Theme::accent
        \qmlproperty color Theme::destructive
        \qmlproperty color Theme::border
        \qmlproperty color Theme::input
        \qmlproperty color Theme::ring
        The core color tokens (plus their \c *Foreground pairs, \c card, \c popover,
        the \c chart1..chart5 ramp, and the \c sidebar* family). Each resolves
        through the active override map before falling back to its built-in value.
    */
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

    // ==== Corner radii (--radius 0.625rem; radiusOverride >= 0 overrides) ====
    /*!
        \qmlproperty real Theme::radius
        \qmlproperty real Theme::radiusSm
        \qmlproperty real Theme::radiusMd
        \qmlproperty real Theme::radiusLg
        \qmlproperty real Theme::radiusXl
        \qmlproperty real Theme::radiusFull
        The corner-radius scale derived from the base \l radius (10px). Ratios match
        base-mira: sm 0.6, md 0.8, lg 1.0, xl 1.4, 2xl 1.8, 3xl 2.2, 4xl 2.6.
        \l radiusFull is a large pill value for fully rounded shapes.
    */
    readonly property real radius: radiusOverride >= 0 ? radiusOverride : 10
    readonly property real radiusSm: radius * 0.6    // 6
    readonly property real radiusMd: radius * 0.8    // 8
    readonly property real radiusLg: radius          // 10
    readonly property real radiusXl: radius * 1.4    // 14
    readonly property real radius2xl: radius * 1.8   // 18
    readonly property real radius3xl: radius * 2.2   // 22
    readonly property real radius4xl: radius * 2.6   // 26
    readonly property real radiusFull: 9999          // pill (rounded-full)

    // ==== Typography ======================================================
    /*!
        \qmlproperty string Theme::fontBodyOverride
        Overrides the body (sans) font family when non-empty; empty uses the
        built-in default (\c Inter). Cleared by \l resetTheme.
    */
    property string fontBodyOverride: ""
    /*!
        \qmlproperty string Theme::fontHeadingOverride
        Overrides the heading font family when non-empty; empty falls back to
        \l fontSans. Cleared by \l resetTheme.
    */
    property string fontHeadingOverride: ""
    readonly property string fontSans: fontBodyOverride !== "" ? fontBodyOverride : "Inter"
    readonly property string fontMono: "Geist Mono"
    readonly property string fontHeading: fontHeadingOverride !== "" ? fontHeadingOverride : fontSans

    // ==== Focus ring (base-mira: ring-2 ring-ring/30 + border->ring) ========
    /*!
        \qmlproperty real Theme::ringWidth
        \qmlproperty real Theme::ringOpacity
        Focus-ring metrics (base-mira uses \c {ring-2 ring-ring/30}): a 2px stroke of
        \l ring at 30% opacity.
    */
    readonly property real ringWidth: 2
    readonly property real ringOpacity: 0.30

    // ==== Overlay elevation (ring-1 ring-foreground/10 + shadow-md) =========
    readonly property color overlayRing: alpha(foreground, 0.10)
    readonly property real overlayRingWidth: 1
    readonly property color shadowColor: alpha("#000000", dark ? 0.5 : 0.12)
    readonly property real shadowBlur: 0.5
    readonly property real shadowOffset: 4

    // ==== Spacing (Tailwind spacing = rem x 4 -> px) ========================
    /*!
        \qmlproperty real Theme::space1
        \qmlproperty real Theme::space2
        \qmlproperty real Theme::space4
        \qmlproperty real Theme::space6
        The spacing scale in pixels (Tailwind spacing = 0.25rem x n = 4px x n).
        Includes half steps such as \c space0_5, \c space1_5, \c space2_5, \c space3_5.
    */
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

    // ==== Font sizes (Tailwind text-xs..4xl) ===============================
    /*!
        \qmlproperty int Theme::textXs
        \qmlproperty int Theme::textSm
        \qmlproperty int Theme::textBase
        \qmlproperty int Theme::textLg
        The font-size scale in pixels (Tailwind text-xs..text-4xl): 12, 14, 16, 18,
        20, 24, 30, 36.
    */
    readonly property int textXs: 12
    readonly property int textSm: 14
    readonly property int textBase: 16
    readonly property int textLg: 18
    readonly property int textXl: 20
    readonly property int text2xl: 24
    readonly property int text3xl: 30
    readonly property int text4xl: 36
    // Line height
    readonly property real lineRelaxed: 1.625

    // ==== Motion ==========================================================
    /*!
        \qmlproperty int Theme::durFast
        \qmlproperty int Theme::durBase
        Animation durations in milliseconds: 100 for fast overlay transitions, 150
        for the default color/state transition.
    */
    readonly property int durFast: 100
    readonly property int durBase: 150

    /*!
        \qmlmethod color Theme::alpha(color c, real a)
        Returns color \a c with its alpha replaced by \a a (0..1), mirroring
        CSS's \c color/NN opacity syntax. RGB channels are preserved.
    */
    function alpha(c, a) { return Qt.rgba(c.r, c.g, c.b, a) }
}
