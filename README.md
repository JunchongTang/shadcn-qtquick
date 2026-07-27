# shadcn-qtquick

A high-fidelity [Qt Quick](https://doc.qt.io/qt-6/qtquick-index.html) / QML port of
[shadcn/ui](https://ui.shadcn.com). It brings shadcn/ui's component set, token-driven
theming, and compact *base-mira* visual style to native Qt applications — no web view,
no HTML/CSS, just QML rendered by the Qt scene graph.

62 components ship today, from primitives (Button, Input, Checkbox, Badge) through
composites (Dialog, Sheet, Command, Combobox, Calendar, Data Table, Sidebar) to
charts and typography — each faithful to the upstream design and driven by the same
design tokens.

## Features

- **Token-driven theming.** A single `Theme` singleton exposes shadcn/ui's color,
  radius, and font tokens with light/dark overrides. Restyle the whole component set
  at runtime — colors, corner radius, and font families all re-theme live.
- **base-mira fidelity.** Spacing, radii, and typography track shadcn/ui's compact
  base-mira reference values.
- **Lucide icons.** Bundled via the `lucide-qtquick` submodule.
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

Run the gallery — a browsable showcase of every component with live source and a
theme customizer:

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
