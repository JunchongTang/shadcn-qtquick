import QtQuick
import QtQuick.Layouts

/*!
    \qmltype InputGroupAddon
    \inqmlmodule Shadcn
    \inherits Item
    \brief A slot inside an InputGroup for an icon, text, small button, Kbd or
    Spinner, styled after shadcn/ui base-mira.

    InputGroupAddon carries no border of its own (\l InputGroup paints the shared
    outline); it only supplies padding and a horizontal RowLayout for its
    content. \l align decides both placement and padding: \c InlineStart /
    \c InlineEnd hug the horizontal ends, while \c BlockStart / \c BlockEnd stack
    above/below the control. Tapping the empty area focuses the group's control
    (the \c cursor-text affordance); a child button takes the tap first.

    Enum member names are prefixed (\c InlineStart etc.) to avoid colliding with
    Item's inherited \c TransformOrigin members (Top/Left/Center/Right/Bottom).

    \sa InputGroup, InputGroupText, InputGroupButton
*/
Item {
    id: addon

    // Placement of the addon (documented on the align property).
    enum Align { InlineStart, InlineEnd, BlockStart, BlockEnd }

    /*!
        \qmlproperty enumeration InputGroupAddon::align
        Placement of the addon. Defaults to \c InputGroupAddon.InlineStart.

        \value InputGroupAddon.InlineStart Leading horizontal end (pl-2).
        \value InputGroupAddon.InlineEnd Trailing horizontal end (pr-2).
        \value InputGroupAddon.BlockStart Row above the control (full width).
        \value InputGroupAddon.BlockEnd Row below the control (full width).
    */
    property int align: InputGroupAddon.InlineStart

    /*! \qmlproperty bool InputGroupAddon::border
        Draws a divider on a block addon (block-start -> bottom border,
        block-end -> top border), matching \c .border-b / \c .border-t. Defaults
        to \c false. */
    property bool border: false

    /*! \qmlproperty string InputGroupAddon::igAlign
        Alignment token consumed by InputGroup when sorting children. \readonly */
    readonly property string igAlign: {
        switch (align) {
        case InputGroupAddon.InlineEnd:  return "inline-end"
        case InputGroupAddon.BlockStart: return "block-start"
        case InputGroupAddon.BlockEnd:   return "block-end"
        default:                         return "inline-start"
        }
    }
    /*!
        \qmlproperty bool InputGroupAddon::_block
        True for a block-aligned addon. \internal
    */
    readonly property bool _block: align === InputGroupAddon.BlockStart
                                || align === InputGroupAddon.BlockEnd

    /*! \qmlproperty InputGroup InputGroupAddon::_group
        Owning group, injected by InputGroup for tap-to-focus. \internal */
    property var _group: null

    default property alias content: row.data

    /*! \qmlproperty bool InputGroupAddon::_edgePull
        True when a child button tightens this side's padding
        (has-[>button]:ml/mr-[-0.275rem]). \internal */
    readonly property bool _edgePull: {
        for (var i = 0; i < row.children.length; i++) {
            var c = row.children[i]
            if (c && c.hasOwnProperty && c.hasOwnProperty("_igButton"))
                return true
        }
        return false
    }

    // Padding (px-2 / py-2; an inline side with a button tightens 8 -> 4).
    readonly property real _padL: {
        if (_block) return Theme.space2
        if (align === InputGroupAddon.InlineStart) return _edgePull ? Theme.space1 : Theme.space2
        return 0
    }
    readonly property real _padR: {
        if (_block) return Theme.space2
        if (align === InputGroupAddon.InlineEnd) return _edgePull ? Theme.space1 : Theme.space2
        return 0
    }
    readonly property real _padT: {
        if (align === InputGroupAddon.BlockStart) return Theme.space2
        if (align === InputGroupAddon.BlockEnd)   return addon.border ? Theme.space2 : 0
        return 0
    }
    readonly property real _padB: {
        if (align === InputGroupAddon.BlockEnd)   return Theme.space2
        if (align === InputGroupAddon.BlockStart) return addon.border ? Theme.space2 : 0
        return 0
    }

    implicitWidth: row.implicitWidth + _padL + _padR
    implicitHeight: row.implicitHeight + _padT + _padB + (_block ? 0 : Theme.space1 * 2)

    // Divider (only for a block addon with border set).
    Rectangle {
        visible: addon.border && addon._block
        width: parent.width
        height: 1
        color: Theme.border
        anchors.top: addon.align === InputGroupAddon.BlockEnd ? parent.top : undefined
        anchors.bottom: addon.align === InputGroupAddon.BlockStart ? parent.bottom : undefined
    }

    RowLayout {
        id: row
        spacing: Theme.space1                       // gap-1
        anchors.leftMargin: addon._padL
        anchors.rightMargin: addon._padR
        anchors.topMargin: addon._padT
        anchors.bottomMargin: addon._padB
        // inline: vertically centered against its end; block: full width (lets an
        // InputGroupText use Layout.fillWidth to push a trailing button to the right).
        anchors.left: (addon._block || addon.align === InputGroupAddon.InlineStart) ? parent.left : undefined
        anchors.right: (addon._block || addon.align === InputGroupAddon.InlineEnd) ? parent.right : undefined
        anchors.verticalCenter: addon._block ? undefined : parent.verticalCenter
        anchors.top: addon._block ? parent.top : undefined
    }

    // Tapping empty space focuses the control; a child button preempts this.
    TapHandler {
        gesturePolicy: TapHandler.ReleaseWithinBounds
        onTapped: if (addon._group) addon._group.focusControl()
    }
}
