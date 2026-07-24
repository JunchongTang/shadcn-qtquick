import QtQuick
import QtQuick.Layouts

/*!
    \qmltype InputGroup
    \inqmlmodule Shadcn
    \inherits FocusScope
    \brief Combines an input with addons/buttons/text behind one shared rounded
    border and a single focus ring, styled after shadcn/ui base-mira.

    InputGroup mirrors \c .cn-input-group: a \c border-input outline over a
    \c bg-input/20 (dark \c /30) fill, \c h-7 tall and \c rounded-md. When any
    control inside takes focus the border switches to \c border-ring and a
    \c ring-2 \c ring-ring/30 ring appears; \l invalid paints the destructive
    border and ring instead.

    Populate it with one \l InputGroupInput or \l InputGroupTextarea plus any
    number of \l InputGroupAddon slots (each holding \l InputGroupText,
    \l InputGroupButton, an icon, a Kbd or a Spinner). Children may be declared
    in any order; the group sorts each addon by its \c align:
    \c inline-start / \c inline-end sit at the horizontal ends, while
    \c block-start / \c block-end stack vertically (a block addon or a textarea
    control switches the group to \l vertical automatically).

    Being a FocusScope, focus on any inner control reads as \c root.activeFocus,
    so the whole group shares one ring. On completion the declared children are
    moved out of a staging Item into a horizontal middle row (RowLayout) and a
    vertical outer column (ColumnLayout), and the control's padding is overridden
    according to which addons are present.

    \qml
    InputGroup {
        InputGroupInput { placeholder: "Search" }
        InputGroupAddon { InputGroupText { text: "https://" } }
    }
    \endqml

    \sa InputGroupInput, InputGroupTextarea, InputGroupAddon, InputGroupButton, InputGroupText
*/
FocusScope {
    id: root

    /*! \qmlproperty bool InputGroup::invalid
        \brief aria-invalid: paints the destructive border plus ring. Defaults to \c false. */
    property bool invalid: false

    /*! \qmlproperty bool InputGroup::_hasBlock
        \brief True while a block-aligned addon is present. Set by \c _rebuild(). \internal */
    property bool _hasBlock: false
    /*! \qmlproperty bool InputGroup::_hasTextarea
        \brief True while the control is a textarea. Set by \c _rebuild(). \internal */
    property bool _hasTextarea: false
    /*! \qmlproperty bool InputGroup::_autoVertical
        \brief Vertical layout is implied by a block addon or a textarea control. \internal */
    readonly property bool _autoVertical: _hasBlock || _hasTextarea
    /*! \qmlproperty bool InputGroup::vertical
        \brief Stacks the group vertically. Defaults to \l _autoVertical; assign to override. */
    property bool vertical: _autoVertical

    /*! \qmlproperty Item InputGroup::_firstControl
        \brief The first inner control, focused when an addon is tapped. \internal */
    property var _firstControl: null

    /*! \qmlproperty Item InputGroup::background
        \brief The shared border/background/focus-ring rectangle. \readonly */
    readonly property alias background: bg

    default property alias _content: stash.data

    implicitWidth: 260
    implicitHeight: vertical ? colL.implicitHeight : 28

    // Staging parent for declared children; sorted and reparented on completion.
    Item { id: stash }

    // ==== Shared border + background + focus ring ====
    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Theme.radiusMd
        color: Theme.alpha(Theme.input, 0.2)          // bg-input/20 subtle fill
        border.width: 1
        border.color: root.invalid ? Theme.destructive
                     : root.activeFocus ? Theme.ring : Theme.border
        Behavior on border.color { ColorAnimation { duration: Theme.durFast } }

        // aria-invalid destructive ring
        Rectangle {
            anchors.fill: parent
            anchors.margins: -Theme.ringWidth
            radius: bg.radius + Theme.ringWidth
            color: "transparent"
            border.width: Theme.ringWidth
            border.color: Theme.alpha(Theme.destructive, 0.2)
            visible: root.invalid
            z: -1
        }

        FocusRing { active: root.activeFocus; targetRadius: bg.radius }
    }

    // ==== Layout containers ====
    // Horizontal middle row: inline-start addon -> control -> inline-end addon.
    RowLayout { id: mid; spacing: 0 }
    // Vertical outer column: block-start addon -> middle row -> block-end addon.
    ColumnLayout {
        id: colL
        spacing: 0
        visible: root.vertical
        anchors.fill: parent
    }

    Component.onCompleted: _rebuild()

    // Focus the first inner control (used by addon tap-to-focus).
    function focusControl() {
        if (_firstControl)
            _firstControl.forceActiveFocus()
    }

    // Sort staged children by role/alignment and reparent into the layout.
    function _rebuild() {
        var kids = []
        for (var i = 0; i < stash.children.length; i++)
            kids.push(stash.children[i])

        var starts = [], ends = [], ctrls = [], bStarts = [], bEnds = []
        var hasBlk = false, hasTa = false

        for (var k = 0; k < kids.length; k++) {
            var c = kids[k]
            if (c.hasOwnProperty && c.hasOwnProperty("_igControl")) {
                ctrls.push(c)
                if (c._igType === "textarea") hasTa = true
            } else if (c.hasOwnProperty && c.hasOwnProperty("igAlign")) {
                c._group = root
                switch (c.igAlign) {
                case "inline-end":  ends.push(c); break
                case "block-start": bStarts.push(c); hasBlk = true; break
                case "block-end":   bEnds.push(c); hasBlk = true; break
                default:            starts.push(c)
                }
            } else {
                starts.push(c)   // unknown content falls back to inline-start
            }
        }

        _hasBlock = hasBlk
        _hasTextarea = hasTa

        var hasStart = starts.length > 0
        var hasEnd   = ends.length > 0
        var hasBS    = bStarts.length > 0
        var hasBE    = bEnds.length > 0

        // Middle row: starts -> ctrls -> ends.
        var midItems = starts.concat(ctrls).concat(ends)
        for (var m = 0; m < midItems.length; m++)
            midItems[m].parent = mid

        // Control padding (overridden by addon presence) + fill width.
        _firstControl = ctrls.length > 0 ? ctrls[0] : null
        for (var t = 0; t < ctrls.length; t++) {
            var ct = ctrls[t]
            ct.Layout.fillWidth = true
            var isTa = ct._igType === "textarea"
            ct.leftPadding  = hasStart ? Theme.space1_5 : Theme.space2   // pl-1.5 : px-2
            ct.rightPadding = hasEnd   ? Theme.space1_5 : Theme.space2   // pr-1.5 : px-2
            if (isTa) {
                ct.topPadding = Theme.space2
                ct.bottomPadding = Theme.space2
            } else {
                ct.topPadding    = hasBE ? Theme.space3 : 0   // block-end present -> pt-3
                ct.bottomPadding = hasBS ? Theme.space3 : 0   // block-start present -> pb-3
                ct.Layout.fillHeight = true
            }
        }
        for (var s = 0; s < starts.length; s++) starts[s].Layout.fillHeight = true
        for (var e = 0; e < ends.length; e++)   ends[e].Layout.fillHeight = true

        if (root.vertical) {
            for (var a = 0; a < bStarts.length; a++) { bStarts[a].parent = colL; bStarts[a].Layout.fillWidth = true }
            mid.parent = colL
            mid.Layout.fillWidth = true
            for (var b = 0; b < bEnds.length; b++) { bEnds[b].parent = colL; bEnds[b].Layout.fillWidth = true }
        } else {
            mid.parent = root
            mid.anchors.fill = root
        }
    }
}
