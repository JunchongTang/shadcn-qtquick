import QtQuick

/*!
    \qmltype ButtonGroup
    \inqmlmodule Shadcn
    \inherits Grid
    \brief Joins adjacent controls into a single seamless bar, styled after
    shadcn/ui base-mira \c .cn-button-group.
    \image button-group.png


    ButtonGroup lays its children out in a single row (\l orientation
    \c ButtonGroup.Horizontal) or a single column (\c ButtonGroup.Vertical) and
    makes their touching 1px borders overlap into one shared edge (via a -1px
    \c spacing), mirroring the web behaviour where adjacent items collapse their
    inner border and straighten their inner corners.

    It works with any child that exposes a \c groupPosition property (Button,
    Input, Select, ButtonGroupText). On layout it assigns each such child a
    First / Middle / Last position (or \c Button.GroupNone when there is a single
    item), and children that also expose \c groupVertical are told the group's
    orientation so they straighten the correct corners.

    A single \c Grid (rather than Row/Column) is used so one component can serve
    both orientations by constraining the opposite dimension.

    \note Group-to-group spacing (the nested \c gap-2 case) is done by wrapping
    several ButtonGroups in an outer \c Row / \c Column with a positive spacing.
    Groups that contain a ButtonGroupSeparator (Separator / Split) cannot use the
    -1px spacing (it would swallow the separator); build those by hand with a
    \c spacing:0 layout and set each child's \c groupPosition explicitly.

    \sa Button, ButtonGroupText, ButtonGroupSeparator
*/
Grid {
    id: group

    // Layout direction of the group. Horizontal is first so it holds value 0.
    enum Orientation { Horizontal, Vertical }

    /*!
        \qmlproperty enumeration ButtonGroup::orientation
        The layout direction. Defaults to \c ButtonGroup.Horizontal.

        \value ButtonGroup.Horizontal Single row; inner left/right corners are
        straightened. Value 0 (default).
        \value ButtonGroup.Vertical Single column; inner top/bottom corners are
        straightened.
    */
    property int orientation: ButtonGroup.Horizontal

    // Horizontal: rows=1, columns auto (-1) -> one row. Vertical: columns=1,
    // rows auto -> one column. The auto dimension MUST stay -1: a fixed large
    // count makes Grid reserve that many rows/columns, and combined with the
    // -1px spacing that collapses the whole group (it renders empty vertically).
    rows: orientation === ButtonGroup.Vertical ? -1 : 1
    columns: orientation === ButtonGroup.Vertical ? 1 : -1
    spacing: -1  // overlap adjacent 1px borders into one edge (avoid double lines)

    onChildrenChanged: Qt.callLater(_assignPositions)
    onOrientationChanged: _assignPositions()
    Component.onCompleted: _assignPositions()

    // Collect children that expose groupPosition (Button / Input / Select /
    // ButtonGroupText) and tag each First / Middle / Last (or None when alone)
    // so it straightens the correct inner corners; children that also expose
    // groupVertical are told the group's orientation.
    function _assignPositions() {
        let items = []
        for (let i = 0; i < children.length; i++) {
            const c = children[i]
            if (c !== null && c.hasOwnProperty("groupPosition"))
                items.push(c)
        }
        const vertical = (orientation === ButtonGroup.Vertical)
        for (let j = 0; j < items.length; j++) {
            if (items[j].hasOwnProperty("groupVertical"))
                items[j].groupVertical = vertical
            if (items.length === 1)
                items[j].groupPosition = Button.GroupNone
            else if (j === 0)
                items[j].groupPosition = Button.GroupFirst
            else if (j === items.length - 1)
                items[j].groupPosition = Button.GroupLast
            else
                items[j].groupPosition = Button.GroupMiddle
        }
    }
}
