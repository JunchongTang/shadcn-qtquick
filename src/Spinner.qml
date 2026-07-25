import QtQuick
import LucideIcons

/*!
    \qmltype Spinner
    \inqmlmodule Shadcn
    \inherits LucideIcon
    \brief A continuously rotating loading indicator.

    Spinner ports shadcn's base-mira \c Spinner: the Lucide \c loader-2 glyph
    with the Tailwind \c animate-spin animation (a linear 360-degree rotation
    looping forever). It defaults to \c size-4 (16px) and the foreground color,
    matching the reference's \c currentColor so it inherits the surrounding text
    color when embedded in a Button, Badge, InputGroup addon, or Empty state.

    Being a \l LucideIcon, both \l size and \l color can be set directly by the
    caller (for example a Button sets \c color to its own foreground token).

    \qml
    Spinner {}                       // size-4, foreground
    Spinner { size: 24 }             // size-6
    Spinner { color: Theme.primaryForeground }  // inside a primary Button
    \endqml
*/
LucideIcon {
    id: control

    /*!
        \qmlproperty int Spinner::size
        The glyph size in pixels; also the item's implicit width/height.
        Defaults to 16 (\c size-4). Inherited from \l LucideIcon.
    */

    /*!
        \qmlproperty color Spinner::color
        The glyph color. Defaults to \c Theme.foreground (the reference's
        \c currentColor). Inherited from \l LucideIcon.
    */

    /*!
        \qmlproperty NumberAnimation Spinner::spin
        \readonly
        The looping rotation animation that drives \c animate-spin. Exposed so
        callers can pause it (\c {spin.running = false}) or assert its
        configuration in tests. Rotates \c {0 -> 360} degrees over 1000ms,
        linearly, forever.
    */
    readonly property alias spin: spinAnim

    name: "loader-2"
    size: 16                       // size-4
    color: Theme.foreground        // matches currentColor; callers may override

    // animate-spin: `spin 1s linear infinite`. NumberAnimation defaults to a
    // linear easing curve, so the plain rotation from 0->360 over 1000ms is a
    // faithful reproduction. The animation rotates about the item's default
    // Item.Center transform origin; since implicit width == height == size the
    // glyph stays centered while spinning.
    NumberAnimation on rotation {
        id: spinAnim
        from: 0; to: 360
        duration: 1000
        loops: Animation.Infinite
        running: control.visible   // pause when hidden to avoid idle repaints
    }
}
