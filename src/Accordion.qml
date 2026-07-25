import QtQuick

/*!
    \qmltype Accordion
    \inqmlmodule Shadcn
    \inherits Item
    \brief A vertically stacked set of collapsible sections.
    \image accordion.png


    Port of shadcn/ui's Accordion (base-mira style). The container is an
    \c {overflow-hidden rounded-md border} card that stacks its
    \l AccordionItem children in a Column.

    Each item toggles independently (equivalent to the web \c {type="multiple"}
    accordion), so any number of sections may be open at once. Set
    \l bordered to \c false to drop the outer frame when embedding the
    accordion inside another surface such as a Card.

    \qml
    Accordion {
        width: 420
        AccordionItem { title: "Section one"; expanded: true; Text { text: "..." } }
        AccordionItem { title: "Section two"; last: true;      Text { text: "..." } }
    }
    \endqml
*/
Item {
    id: control

    /*!
        \qmlproperty bool Accordion::bordered
        Whether the outer 1px rounded border is drawn. Defaults to \c true;
        set to \c false when the accordion sits inside another bordered
        surface (e.g. a Card).
    */
    property bool bordered: true

    /*!
        \qmlproperty list<QtObject> Accordion::content
        Default property. The \l AccordionItem sections stacked in the
        container, top to bottom.
    */
    default property alias content: col.data

    /*!
        \qmlproperty Rectangle Accordion::background
        The container's border/background rectangle. Exposed read-only for
        styling introspection and testing.
    */
    readonly property alias background: bg

    implicitWidth: 400
    implicitHeight: col.implicitHeight

    // Rounded outer frame (rounded-md border); painted behind the items.
    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Theme.radiusMd
        color: "transparent"
        border.width: control.bordered ? 1 : 0
        border.color: Theme.border
    }

    // Items are stacked vertically; each child sizes its own width to the column.
    Column {
        id: col
        width: parent.width
    }
}
