import QtQuick

/*!
    \qmltype ButtonGroupText
    \inqmlmodule Shadcn
    \inherits Rectangle
    \brief A non-interactive text chip for a ButtonGroup, styled after base-mira
    \c .cn-button-group-text (\c bg-muted, \c rounded-md, \c border, \c px-2.5,
    \c text-xs, \c font-medium).

    ButtonGroupText renders a muted, bordered label that sits flush against
    neighbouring buttons or inputs inside a ButtonGroup. Like Button it exposes
    \l groupPosition / \l groupVertical, so ButtonGroup can straighten the inner
    corners adjacent to its neighbours.

    \sa ButtonGroup, Button
*/
Rectangle {
    id: control

    /*!
        \qmlproperty string ButtonGroupText::text
        The label text.
    */
    property alias text: label.text

    /*!
        \qmlproperty int ButtonGroupText::groupPosition
        Adjacency inside a ButtonGroup; see \c Button.GroupPosition. Set
        automatically by ButtonGroup. Defaults to \c Button.GroupNone.
    */
    property int groupPosition: Button.GroupNone

    /*!
        \qmlproperty bool ButtonGroupText::groupVertical
        Whether the containing ButtonGroup is vertical. Set automatically
        by ButtonGroup. Defaults to false.
    */
    property bool groupVertical: false

    implicitHeight: 28
    implicitWidth: label.implicitWidth + Theme.space2_5 * 2   // px-2.5
    color: Theme.muted
    radius: Theme.radiusMd
    border.width: 1
    border.color: Theme.border

    // Straighten the inner corners adjacent to neighbours when grouped (same
    // per-corner derivation as Button). None is fully round; Middle is fully
    // square. Horizontal: First keeps its left corners, Last its right.
    // Vertical: First keeps its top corners, Last its bottom.
    readonly property bool _n: groupPosition === Button.GroupNone
    readonly property bool _f: groupPosition === Button.GroupFirst
    readonly property bool _l: groupPosition === Button.GroupLast
    readonly property bool _v: groupVertical
    topLeftRadius:     (_n || _f) ? radius : 0
    bottomRightRadius: (_n || _l) ? radius : 0
    topRightRadius:    (_n || (!_v && _l) || (_v && _f)) ? radius : 0
    bottomLeftRadius:  (_n || (!_v && _f) || (_v && _l)) ? radius : 0

    Text {
        id: label
        anchors.centerIn: parent
        color: Theme.foreground
        font.pixelSize: Theme.textXs      // text-xs
        font.weight: Font.Medium
    }
}
