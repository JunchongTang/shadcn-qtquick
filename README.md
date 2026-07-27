# shadcn-qtquick

**English** | [简体中文](README.zh-CN.md)

[![Documentation](https://img.shields.io/badge/docs-online-blue.svg)](https://junchongtang.github.io/shadcn-qtquick/)
[![License: MIT](https://img.shields.io/badge/License-MIT-informational.svg)](LICENSE)
![Qt 6.8+](https://img.shields.io/badge/Qt-6.8%2B-41cd52.svg)
![C++20](https://img.shields.io/badge/C%2B%2B-20-00599c.svg)

A high-fidelity [Qt Quick](https://doc.qt.io/qt-6/qtquick-index.html) / QML port of
[shadcn/ui](https://ui.shadcn.com). It brings shadcn/ui's component set, token-driven
theming, and compact *base-mira* visual style to native Qt applications — no web view,
no HTML/CSS, just QML rendered by the Qt scene graph.

<p align="center">
  <img src="screenshot/create.png" alt="Theme customizer and live dashboard preview" width="900">
</p>

62 components ship today, from primitives (Button, Input, Checkbox, Badge) through
composites (Dialog, Sheet, Command, Combobox, Calendar, Data Table, Sidebar) to
charts and typography — each faithful to the upstream design and driven by the same
design tokens. Retheme the entire set at runtime: colors, corner radius, and font
families all update live, as shown in the customizer above.

## Screenshots

The bundled gallery is a browsable showcase of every component, mirroring the layout
of ui.shadcn.com — a live **Preview** with copyable source, plus an embedded **API**
reference generated from the component's QDoc.

<table>
  <tr>
    <td width="50%"><img src="screenshot/button-page.png" alt="Component gallery — Button preview"></td>
    <td width="50%"><img src="screenshot/button-api.png" alt="Embedded API reference"></td>
  </tr>
  <tr>
    <td align="center"><em>Component preview with live source</em></td>
    <td align="center"><em>Embedded QDoc API reference</em></td>
  </tr>
</table>

## Features

- **Token-driven theming.** A single `Theme` singleton exposes shadcn/ui's color,
  radius, and font tokens with light/dark overrides. Restyle the whole component set
  at runtime — colors, corner radius, and font families all re-theme live.
- **base-mira fidelity.** Spacing, radii, and typography track shadcn/ui's compact
  base-mira reference values.
- **Lucide icons.** Bundled via the `lucide-qtquick` submodule.
- **Documented.** Every component carries QDoc comments; the gallery renders that
  reference inline next to each live demo.
- **Tested.** An 800+ case QuickTest suite guards behavior and appearance regressions.

## Requirements

- Qt **6.8** or newer (Core, Gui, Qml, Quick)
- CMake **3.22+**
- A C++20 compiler

## Getting started

```bash
git clone --recurse-submodules https://github.com/JunchongTang/shadcn-qtquick.git
cd shadcn-qtquick

cmake -B build -DCMAKE_PREFIX_PATH=/path/to/Qt/6.8.6/<platform>
cmake --build build
```

Run the gallery:

```bash
./build/examples/gallery/shadcn_gallery
```

Run the test suite:

```bash
cmake --build build --target tst_shadcn
QT_QPA_PLATFORM=offscreen ./build/tests/tst_shadcn
```

Build options: `-DSHADCN_BUILD_EXAMPLES=OFF` and `-DSHADCN_BUILD_TESTS=OFF` skip the
gallery and tests respectively.

## Using it in your project

The library builds as a static QML module with the URI `Shadcn`. Add this repository
as a subdirectory (or via CMake `FetchContent`), link the module, and import it:

```qml
import Shadcn

Button {
    text: qsTr("Continue")
    onClicked: console.log("clicked")
}
```

## Theming

All appearance flows through the `Theme` singleton, so you retheme every component at
once rather than styling controls individually:

```qml
import Shadcn

// Switch light/dark
Theme.dark = true

// Override a color token (light and/or dark)
Theme.setToken("primary", "#2563eb", false)   // light
Theme.setToken("primary", "#3b82f6", true)     // dark

// Corner radius and fonts
Theme.setRadius(8)
Theme.fontHeadingOverride = "Georgia"

Theme.resetTheme()   // back to base-mira defaults
```

The **Create** page in the gallery (first screenshot) is a live front-end for exactly
this API — base color, accent, chart palette, radius, and fonts.

## Project layout

| Path | Contents |
| --- | --- |
| `src/qml/<component>/` | Component sources; shared pieces live in `src/qml/core/` |
| `examples/gallery/` | The gallery app and per-component demos under `demos/<component>/` |
| `tests/` | QuickTest suite (`tst_*.qml`) |
| `third_party/lucide-qtquick/` | Lucide icon submodule |
| `docs/` | Doc build script and generated hero images |

## Credits & license

This project is a port of [shadcn/ui](https://ui.shadcn.com) by
[shadcn](https://github.com/shadcn), used under the MIT License. Icons are from
[Lucide](https://lucide.dev) (ISC License).

shadcn-qtquick is released under the [MIT License](LICENSE); the upstream shadcn/ui
copyright notice is retained there.
