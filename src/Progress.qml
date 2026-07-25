import QtQuick

/*!
    \qmltype Progress
    \inqmlmodule Shadcn
    \inherits Item
    \brief A horizontal bar that displays the completion progress of a task.

    Progress ports shadcn's base-mira \c .cn-progress-* rules: an \c h-1 (4px)
    \c rounded-md track painted with the muted color, over which a primary-colored
    indicator fills from the left in proportion to \l value.

    The indicator width is \c{(value - from) / (to - from)}, clamped to the track,
    and animates when \l value changes. Set \l indeterminate for tasks whose
    progress is unknown; the indicator then slides back and forth instead.

    \qml
    Progress { value: 66 }                 // 66%
    Progress { from: 0; to: 200; value: 50 } // 25%
    Progress { indeterminate: true }
    \endqml
*/
Item {
    id: control

    /*!
        \qmlproperty real Progress::value
        The current progress, expressed on the \l from .. \l to scale.
        Defaults to \c 0. Values outside the range are clamped for display.
    */
    property real value: 0

    /*!
        \qmlproperty real Progress::from
        The value that maps to an empty (0%) bar. Defaults to \c 0.
    */
    property real from: 0

    /*!
        \qmlproperty real Progress::to
        The value that maps to a full (100%) bar. Defaults to \c 100.
    */
    property real to: 100

    /*!
        \qmlproperty bool Progress::indeterminate
        When \c true the task's progress is unknown; the indicator loops a
        sliding animation and \l value is ignored. Defaults to \c false.
    */
    property bool indeterminate: false

    // Completed fraction in [0, 1]. Guards a zero/inverted range (to <= from).
    readonly property real position: {
        var span = to - from
        if (span <= 0)
            return 0
        return Math.max(0, Math.min(1, (value - from) / span))
    }

    // Animated position (0..1) that drives the indeterminate sliding bar.
    property real _indeterminatePos: 0

    implicitWidth: 200
    implicitHeight: 4              // h-1

    // Introspection handles (read-only) for tests and composition.
    readonly property alias track: track
    readonly property alias indicator: indicator

    NumberAnimation on _indeterminatePos {
        running: control.indeterminate
        loops: Animation.Infinite
        from: 0
        to: 1
        duration: 1200
        easing.type: Easing.InOutSine
    }

    Rectangle {
        id: track
        anchors.fill: parent
        radius: Theme.radiusMd    // rounded-md
        color: Theme.muted        // bg-muted
        clip: true

        Rectangle {
            id: indicator
            height: parent.height
            // Determinate: fraction of the track. Indeterminate: a short 40% bar.
            width: control.indeterminate ? parent.width * 0.4
                                         : parent.width * control.position
            // Determinate anchors at the left; indeterminate slides across.
            x: control.indeterminate
               ? (parent.width + width) * control._indeterminatePos - width
               : 0
            radius: Theme.radiusMd
            color: Theme.primary  // bg-primary

            // transition-all: animate width changes, but not while sliding.
            Behavior on width {
                enabled: !control.indeterminate
                NumberAnimation { duration: Theme.durBase; easing.type: Easing.OutCubic }
            }
        }
    }
}
