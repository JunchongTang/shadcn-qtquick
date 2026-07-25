import QtQuick

/*!
    \qmltype ButtonGroupSeparator
    \inqmlmodule Shadcn
    \inherits Rectangle
    \brief A thin divider drawn between items of a hand-built button group,
    styled after base-mira \c .cn-button-group-separator (\c bg-input).

    ButtonGroupSeparator is a 1px line used to visually split borderless buttons
    (e.g. Secondary) inside a group. It defaults to \l orientation
    \c ButtonGroupSeparator.Vertical (a vertical line, for a horizontally laid
    out group) and takes its color from \c Theme.input.

    Because the -1px spacing of a ButtonGroup would swallow a 1px separator,
    place it inside a hand-built \c spacing:0 layout and set the adjacent
    buttons' \c groupPosition explicitly.

    \sa ButtonGroup, Button
*/
Rectangle {
    /*!
        \qmlproperty enumeration ButtonGroupSeparator::orientation
        Direction the divider runs.
        \value ButtonGroupSeparator.Horizontal A horizontal line (1px tall,
        \l length wide). Value 0.
        \value ButtonGroupSeparator.Vertical A vertical line (1px wide,
        \l length tall). Default.
    */
    enum Orientation { Horizontal, Vertical }

    /*!
        \qmlproperty int ButtonGroupSeparator::orientation
        The divider direction; see \l Orientation. Defaults to
        \c ButtonGroupSeparator.Vertical.
    */
    property int orientation: ButtonGroupSeparator.Vertical

    /*!
        \qmlproperty real ButtonGroupSeparator::length
        The length of the line along its running direction (height when
        vertical, width when horizontal). Defaults to 24; override to match
        adjacent buttons of a different size.
    */
    property real length: 24

    color: Theme.input
    implicitWidth: orientation === ButtonGroupSeparator.Vertical ? 1 : length
    implicitHeight: orientation === ButtonGroupSeparator.Vertical ? length : 1
}
