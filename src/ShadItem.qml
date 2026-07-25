import QtQuick
import QtQuick.Layouts

/*!
    \qmltype ShadItem
    \inqmlmodule Shadcn
    \inherits Item
    \brief A generic content row: media | content (stretches) | actions, with
    optional header and footer rows that each span the full width.

    Port of shadcn/ui \c Item (base-mira). The main row lays out an optional
    \l ItemMedia, one or more \l ItemContent columns (the first stretches), and
    an optional \l ItemActions group. \l ItemHeader and \l ItemFooter children
    are routed out of the main row into full-width rows above / below it
    (equivalent to the web's \c basis-full wrap behaviour).

    The type is named \c ShadItem rather than \c Item on purpose: registering a
    type literally named \c Item into the Shadcn module would shadow
    QtQuick.Item for every sibling and consumer that uses a bare \c Item {},
    breaking the whole library. The root therefore uses QtQuick.Item directly
    and exposes the type as \c ShadItem.

    When \l asLink is true the row hovers to \c bg-muted, shows a pointing-hand
    cursor, emits \l clicked, and paints a keyboard focus ring.
*/
Item {
    id: control

    enum Variant { Default, Outline, Muted }
    enum Size { Default, Sm, Xs }

    /*!
        \qmlproperty int ShadItem::variant
        Visual variant. One of:
        \value ShadItem.Default Transparent background, no border.
        \value ShadItem.Outline Transparent background with a 1px border.
        \value ShadItem.Muted   Muted/50 background, no border.
    */
    property int variant: ShadItem.Default
    /*!
        \qmlproperty int ShadItem::size
        Density preset controlling padding and inner spacing. One of:
        \value ShadItem.Default px-3 / py-2.5, gap-2.5.
        \value ShadItem.Sm      Same metrics as Default in base-mira.
        \value ShadItem.Xs      px-2.5 / py-2, gap-2.5; drives compact media/content.
    */
    property int size: ShadItem.Default
    /*!
        \qmlproperty bool ShadItem::asLink
        When true the row is interactive: hover background, pointing cursor,
        \l clicked signal, and Tab focus ring.
    */
    property bool asLink: false
    /*!
        \qmlsignal ShadItem::clicked()
        Emitted when an \l asLink row is tapped.
    */
    signal clicked()

    // Slot tag so ItemGroup can recognise items and derive its spacing.
    readonly property string itemSlot: "item"

    // Consumer children (ItemMedia/ItemContent/ItemActions/ItemHeader/ItemFooter)
    // land in the main row; _route() then migrates header/footer out to their
    // own full-width rows by inspecting itemSlot.
    default property alias content: mainRow.data

    // Padding: default/sm px-3 py-2.5; xs px-2.5 py-2. Flex gap is gap-2.5 (10).
    readonly property real _padH: size === ShadItem.Xs ? Theme.space2_5 : Theme.space3
    readonly property real _padV: size === ShadItem.Xs ? Theme.space2 : Theme.space2_5
    readonly property real _gap: Theme.space2_5

    implicitWidth: layoutCol.implicitWidth + _padH * 2
    implicitHeight: layoutCol.implicitHeight + _padV * 2

    activeFocusOnTab: asLink

    // Background + border (per variant; asLink hovers to bg-muted).
    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Theme.radiusMd
        border.width: control.variant === ShadItem.Outline ? 1 : 0
        border.color: Theme.border
        color: {
            var hov = control.asLink && hover.hovered
            if (control.variant === ShadItem.Muted)
                return hov ? Theme.muted : Theme.alpha(Theme.muted, 0.5)
            return hov ? Theme.muted : "transparent"
        }
    }

    ColumnLayout {
        id: layoutCol
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: control._padH
        anchors.rightMargin: control._padH
        anchors.topMargin: control._padV
        anchors.bottomMargin: control._padV
        spacing: control._gap

        // ---- header zone (basis-full, spans a full row, pinned to top) ----
        ColumnLayout {
            id: headerZone
            Layout.fillWidth: true
            spacing: control._gap
            visible: children.length > 0
        }

        // ---- main row: media | content (stretches) | actions ----
        RowLayout {
            id: mainRow
            Layout.fillWidth: true
            spacing: control._gap
        }

        // ---- footer zone (basis-full, spans a full row, pinned to bottom) ----
        ColumnLayout {
            id: footerZone
            Layout.fillWidth: true
            spacing: control._gap
            visible: children.length > 0
        }
    }

    FocusRing {
        active: control.asLink && control.activeFocus
        targetRadius: Theme.radiusMd
    }

    HoverHandler {
        id: hover
        enabled: control.asLink
        cursorShape: Qt.PointingHandCursor
    }
    TapHandler {
        enabled: control.asLink
        onTapped: control.clicked()
    }

    Component.onCompleted: _route()

    // Migrate header/footer children into their own rows and configure media /
    // content children based on the item's size and description presence.
    function _route() {
        var kids = []
        for (var i = 0; i < mainRow.children.length; i++)
            kids.push(mainRow.children[i])

        var contentCount = 0
        var hasDesc = false
        var medias = []
        for (var j = 0; j < kids.length; j++) {
            var c = kids[j]
            if (!c || c.itemSlot === undefined)
                continue
            switch (c.itemSlot) {
            case "item-header":
                c.parent = headerZone
                break
            case "item-footer":
                c.parent = footerZone
                break
            case "item-media":
                if (c.hostSize !== undefined)
                    c.hostSize = control.size
                medias.push(c)
                break
            case "item-content":
                if (c.hostSize !== undefined)
                    c.hostSize = control.size
                contentCount++
                // [&+[data-slot=item-content]]:flex-none — the second and later
                // content columns do not stretch.
                if (contentCount > 1 && c.contentFill !== undefined)
                    c.contentFill = false
                if (c.hasDescription)
                    hasDesc = true
                break
            }
        }
        // group-has-data-[slot=item-description]: media aligns to top and shifts
        // down 0.5 (2px).
        for (var k = 0; k < medias.length; k++) {
            if (medias[k].topShift !== undefined)
                medias[k].topShift = hasDesc
        }
    }
}
