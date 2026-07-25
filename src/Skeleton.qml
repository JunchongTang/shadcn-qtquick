import QtQuick

/*!
    \qmltype Skeleton
    \inqmlmodule Shadcn
    \inherits Rectangle
    \brief A pulsing placeholder shown while content loads.
    \image skeleton.png


    Skeleton ports shadcn's base-mira \c .cn-skeleton rule
    (\c {bg-muted rounded-md}) plus the Tailwind \c animate-pulse utility. It is
    a plain \l Rectangle: the caller sizes it (and may override \c radius, for
    example to \c width/2 for a circular avatar placeholder) while this type
    supplies the muted fill, the \c rounded-md corner and the breathing
    opacity animation.

    The pulse follows Tailwind's \c animate-pulse keyframes: opacity eases
    between \c 1 and \c 0.5 over a 2s cycle with a \c {cubic-bezier(0.4, 0, 0.6, 1)}
    timing function, looping forever. The animation only runs while the item is
    \l {Item::visible}{visible}, so hidden skeletons cost nothing. Use \l pulse
    to inspect or control it.

    \qml
    // Text line placeholder.
    Skeleton { width: 150; height: 16 }

    // Circular avatar placeholder (size-10 rounded-full).
    Skeleton { width: 40; height: 40; radius: width / 2 }
    \endqml
*/
Rectangle {
    id: control

    // .cn-skeleton: bg-muted rounded-md.
    color: Theme.muted
    radius: Theme.radiusMd

    /*!
        \qmlproperty SequentialAnimation Skeleton::pulse
        \readonly
        The looping opacity animation that drives \c animate-pulse. Exposed so
        callers can pause it (\c {pulse.running = false}) or assert its
        configuration in tests. Its two child \l NumberAnimation steps fade
        opacity \c {1 -> 0.5} and back, 1000ms each.
    */
    readonly property alias pulse: pulseAnim

    SequentialAnimation on opacity {
        id: pulseAnim
        loops: Animation.Infinite
        running: control.visible
        // Tailwind animate-pulse: opacity 1 -> .5 -> 1 over 2s,
        // cubic-bezier(0.4, 0, 0.6, 1).
        NumberAnimation {
            from: 1.0; to: 0.5; duration: 1000
            easing.type: Easing.Bezier
            easing.bezierCurve: [0.4, 0.0, 0.6, 1.0, 1.0, 1.0]
        }
        NumberAnimation {
            from: 0.5; to: 1.0; duration: 1000
            easing.type: Easing.Bezier
            easing.bezierCurve: [0.4, 0.0, 0.6, 1.0, 1.0, 1.0]
        }
    }
}
