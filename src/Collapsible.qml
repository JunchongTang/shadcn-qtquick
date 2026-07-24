import QtQuick
import QtQuick.Layouts

/*!
    \qmltype Collapsible
    \inqmlmodule Shadcn
    \inherits Item
    \brief A panel whose content expands and collapses with a height animation.

    Collapsible is the base-mira port of shadcn's Collapsible (base-ui
    \c Root / \c Trigger / \c Panel). base-mira ships no dedicated styling for
    it: the component provides structure and a height animation only, while the
    visuals come from whatever Button and content the caller places inside.

    The layout has two parts:
    \list
        \li \l trigger — an always-visible header slot. It typically holds the
            control that opens and closes the panel (which calls \l toggle()).
        \li default content — the collapsible \e panel. Its height animates
            between \c 0 (collapsed) and its natural height (expanded), following
            the same pattern as AccordionItem.
    \endlist

    Open state is controlled through \l expanded; call \l toggle() from the
    trigger control to flip it.

    Set \l background and \l radius to paint an optional rounded fill behind the
    whole (animating) region, mirroring a \c {rounded-md data-open:bg-muted}
    treatment. Both default to no background.

    \qml
    Collapsible {
        id: c
        trigger: Button { text: "Toggle"; onClicked: c.toggle() }
        Text { Layout.fillWidth: true; text: "Collapsible content." }
    }
    \endqml
*/
Item {
    id: root

    /*! \qmlproperty bool Collapsible::expanded \brief Whether the panel is open. Defaults to \c false. */
    property bool expanded: false
    /*! \qmlproperty real Collapsible::gap
        \brief Spacing between the trigger and the content, and between content
        items (mirrors the demo's \c gap-2). Defaults to \c Theme.space2. */
    property real gap: Theme.space2
    /*! \qmlproperty color Collapsible::background \brief Optional fill behind the whole region. Defaults to transparent. */
    property color background: "transparent"
    /*! \qmlproperty real Collapsible::radius \brief Corner radius of \l background. Defaults to \c 0. */
    property real radius: 0

    /*! \qmlproperty list<QtObject> Collapsible::trigger \brief Content of the always-visible header slot. */
    property alias trigger: triggerSlot.data
    /*! \qmlproperty list<QtObject> Collapsible::content \brief Collapsible panel content (the default property). */
    default property alias content: body.data

    /*! \qmlmethod void Collapsible::toggle() \brief Flips \l expanded between open and closed. */
    function toggle() { expanded = !expanded }

    // Size follows the children; width must come from outside (Layout or an
    // explicit width) to avoid a self-referential loop.
    implicitWidth: Math.max(triggerSlot.implicitWidth, body.implicitWidth)
    implicitHeight: triggerSlot.height + contentClip.height

    // Fill behind the current (height-animated) region.
    Rectangle {
        anchors.fill: parent
        color: root.background
        radius: root.radius
        visible: root.background.a > 0
    }

    // Always-visible trigger slot.
    Item {
        id: triggerSlot
        objectName: "trigger"
        width: root.width
        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
        height: childrenRect.height
    }

    // Collapsible panel with an animated height.
    Item {
        id: contentClip
        objectName: "content"
        anchors.top: triggerSlot.bottom
        width: root.width
        clip: true
        height: root.expanded ? body.implicitHeight + root.gap : 0
        Behavior on height { NumberAnimation { duration: Theme.durBase; easing.type: Easing.OutCubic } }

        ColumnLayout {
            id: body
            y: root.gap
            width: parent.width
            spacing: root.gap
        }
    }
}
