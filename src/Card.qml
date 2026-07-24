import QtQuick
import QtQuick.Layouts

/*!
    \qmltype Card
    \inqmlmodule Shadcn
    \inherits Item
    \brief Surface container matching shadcn/ui base-mira Card.

    Renders a card surface: bg-card fill, rounded-lg corners and a 1px
    foreground/10 ring (ring-1 ring-foreground/10) rather than a plain border.

    Layout mirrors the base-mira model: vertical padding and inter-block gap
    both equal \l cardSpacing (default 16, small 12). Horizontal insets are
    applied uniformly here (anchors.margins on the content column) rather than
    per child, so CardHeader/CardContent/CardFooter only manage their own inner
    stacking. Children may be CardHeader/CardContent/CardFooter or any Item.

    \note Full-bleed edge cases (e.g. rounded top images with pt-0) and
    overflow-hidden clipping are not yet modelled.
*/
Item {
    id: control

    enum Size { Default, Small }

    /*! \qmlproperty enumeration Card::size
        Size variant. \c Card.Default (16px spacing) or \c Card.Small (12px). */
    property int size: Card.Default

    /*! \qmlproperty real Card::cardSpacing
        The --card-spacing token: vertical padding and block gap. Derived from
        \l size when not assigned; assign to override (any [--card-spacing]). */
    property real cardSpacing: size === Card.Small ? Theme.space3 : Theme.space4

    /*! \qmlproperty list<QtObject> Card::content
        Default property: card body items, stacked vertically. */
    default property alias content: col.data

    implicitWidth: col.implicitWidth + cardSpacing * 2
    implicitHeight: col.implicitHeight + cardSpacing * 2

    Rectangle {
        anchors.fill: parent
        color: Theme.card
        radius: Theme.radiusLg
        // base-mira uses a 1px foreground ring (ring-1 ring-foreground/10)
        // instead of a solid border.
        border.width: Theme.overlayRingWidth
        border.color: Theme.overlayRing
    }

    ColumnLayout {
        id: col
        anchors.fill: parent
        anchors.margins: control.cardSpacing
        spacing: control.cardSpacing
    }
}
