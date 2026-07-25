import QtQuick
import QtQuick.Layouts
import LucideIcons

/*!
    \qmltype AccordionItem
    \inqmlmodule Shadcn
    \inherits Item
    \brief A single collapsible section within an \l Accordion.

    Port of shadcn/ui's AccordionItem/AccordionTrigger/AccordionContent
    (base-mira style). Renders a trigger row (\c {p-2 text-xs} title plus a
    trailing chevron) followed by a collapsible content region.

    Clicking the trigger toggles \l expanded. When open the trigger takes a
    \c {bg-muted/50} background and the chevron rotates 180 degrees; the
    content height animates between 0 and its natural height. Every item but
    the last one draws a 1px bottom separator (\c not-last:border-b).

    Set \c enabled to \c false to disable the section: the trigger dims to
    50% opacity and clicks are ignored (Qt propagates the disabled state to
    the pointer handlers).

    Content is supplied as the default property and laid out in a
    ColumnLayout, so children should use \c Layout attached properties.

    \qml
    AccordionItem {
        title: "Is it accessible?"
        expanded: true
        Text {
            Layout.fillWidth: true
            text: "Yes. It adheres to the WAI-ARIA design pattern."
            wrapMode: Text.Wrap
        }
    }
    \endqml
*/
Item {
    id: item

    /*!
        \qmlproperty string AccordionItem::title
        The trigger label shown at the left of the header row.
    */
    property string title: ""

    /*!
        \qmlproperty bool AccordionItem::expanded
        Whether the section is open. Toggled by clicking the trigger; may
        also be set declaratively to open a section by default. Defaults to
        \c false.
    */
    property bool expanded: false

    /*!
        \qmlproperty bool AccordionItem::last
        Whether this is the final item in its \l Accordion. When \c true the
        bottom separator is hidden. Defaults to \c false.
    */
    property bool last: false

    /*!
        \qmlproperty list<QtObject> AccordionItem::content
        Default property. The collapsible content, laid out in a ColumnLayout
        with \c Theme.space2 spacing and horizontal padding.
    */
    default property alias content: body.data

    /*!
        \qmlproperty Rectangle AccordionItem::background
        The trigger's background rectangle. Exposed read-only for styling
        introspection and testing.
    */
    readonly property alias background: header

    width: parent ? parent.width : 400
    // header + animated content + optional 1px separator row.
    implicitHeight: header.height + contentClip.height + (item.last ? 0 : 1)

    Column {
        width: parent.width

        // ---- Trigger ----
        Rectangle {
            id: header
            objectName: "trigger"
            width: parent.width
            height: 34
            opacity: item.enabled ? 1.0 : 0.5   // aria-disabled:opacity-50
            color: item.expanded ? Theme.alpha(Theme.muted, 0.5) : "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.space2
                anchors.rightMargin: Theme.space2
                spacing: Theme.space2

                Text {
                    Layout.fillWidth: true
                    text: item.title
                    color: Theme.foreground
                    font.pixelSize: Theme.textXs
                    font.weight: Font.Medium
                    font.underline: hover.hovered
                    verticalAlignment: Text.AlignVCenter
                }
                LucideIcon {
                    objectName: "chevron"
                    name: "chevron-down"
                    size: 16
                    color: Theme.mutedForeground
                    rotation: item.expanded ? 180 : 0
                    Behavior on rotation { NumberAnimation { duration: Theme.durFast } }
                }
            }

            HoverHandler { id: hover }
            TapHandler { onTapped: item.expanded = !item.expanded }
        }

        // ---- Collapsible content ----
        Item {
            id: contentClip
            objectName: "content"
            width: parent.width
            // Natural height plus bottom padding while open; 0 while closed.
            height: item.expanded ? body.implicitHeight + Theme.space2 + Theme.space4 : 0
            clip: true
            Behavior on height { NumberAnimation { duration: Theme.durBase; easing.type: Easing.OutCubic } }

            ColumnLayout {
                id: body
                x: Theme.space2                       // px-2
                y: 0
                width: parent.width - Theme.space2 * 2
                spacing: Theme.space2
            }
        }
    }

    // Bottom separator on every item except the last (not-last:border-b).
    Rectangle {
        objectName: "separator"
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        visible: !item.last
        color: Theme.border
    }
}
