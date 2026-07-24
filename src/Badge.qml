import QtQuick
import QtQuick.Layouts
import LucideIcons

/*!
    \qmltype Badge
    \inqmlmodule Shadcn
    \inherits Item
    \brief A small pill-shaped label, styled after shadcn's base-mira badge.

    Badge renders shadcn's \c .cn-badge as a compact \c rounded-full pill:
    20px tall (\c h-5), 10px medium text (\c text-[0.625rem]) and 6 color
    variants. It can carry an optional leading and/or trailing Lucide icon
    (\l iconName / \l trailingIconName, painted at 10px), plus arbitrary
    content slots (\l leading / \l trailing) for things like a Spinner.

    Per-variant colors come from \l Theme; they may be overridden wholesale
    through \l bgColor, \l fgColor and \l borderColor for custom-colored badges.

    The \l Variant enum values/names are stable API: other components (for
    example table cells) select a badge style by name, e.g. \c Badge.Secondary.

    \qml
    Badge { text: "Badge" }
    Badge { text: "Secondary"; variant: Badge.Secondary }
    Badge { iconName: "badge-check"; text: "Verified"; variant: Badge.Outline }
    \endqml
*/
Item {
    id: control

    /*!
        \qmlproperty enumeration Badge::variant
        The color style. Values map to shadcn's \c .cn-badge-variant-* rules.
        \value Badge.Default Primary fill with primary-foreground text.
        \value Badge.Secondary Secondary fill with secondary-foreground text.
        \value Badge.Outline 1px border, foreground text, faint input-tinted fill.
        \value Badge.Destructive Faint destructive fill with destructive text.
        \value Badge.Ghost Transparent, foreground text.
        \value Badge.Link Transparent, primary text, underlined.

        \note The member order differs from \c Button.Variant on purpose; each
        QML type namespaces its own enum, so callers must reference members by
        name (\c Badge.Ghost), never by numeric value.
    */
    enum Variant { Default, Secondary, Outline, Destructive, Ghost, Link }

    /*! \qmlproperty int Badge::variant \brief The color style; see \l Variant. Defaults to \c Badge.Default. */
    property int variant: Badge.Default
    /*! \qmlproperty string Badge::text \brief The label text. Empty hides the label. */
    property string text: ""
    /*! \qmlproperty string Badge::iconName \brief Optional leading Lucide icon (kebab-case), painted at 10px. */
    property string iconName: ""
    /*! \qmlproperty string Badge::trailingIconName \brief Optional trailing Lucide icon (kebab-case), painted at 10px. */
    property string trailingIconName: ""

    /*! \qmlproperty list<QtObject> Badge::leading \brief Content slot placed before the icon/label (e.g. a Spinner). */
    property alias leading: leadingSlot.data
    /*! \qmlproperty list<QtObject> Badge::trailing \brief Content slot placed after the label/icon. */
    property alias trailing: trailingSlot.data

    /*! \qmlproperty color Badge::bgColor \brief Background fill; defaults per \l variant. */
    property color bgColor: {
        switch (variant) {
        case Badge.Default: return Theme.primary
        case Badge.Secondary: return Theme.secondary
        // bg-input/20 (light) or bg-input/30 (dark).
        case Badge.Outline: return Theme.alpha(Theme.input, Theme.dark ? 0.3 : 0.2)
        // bg-destructive/10 (light) or bg-destructive/20 (dark).
        case Badge.Destructive: return Theme.alpha(Theme.destructive, Theme.dark ? 0.2 : 0.1)
        default: return "transparent"  // Ghost / Link
        }
    }
    /*! \qmlproperty color Badge::fgColor \brief Text/icon color; defaults per \l variant. */
    property color fgColor: {
        switch (variant) {
        case Badge.Default: return Theme.primaryForeground
        case Badge.Secondary: return Theme.secondaryForeground
        case Badge.Destructive: return Theme.destructive
        case Badge.Link: return Theme.primary
        default: return Theme.foreground  // Outline / Ghost
        }
    }
    /*! \qmlproperty color Badge::borderColor \brief Border color; only drawn for \c Badge.Outline. */
    property color borderColor: Theme.border

    /*! \qmlproperty Rectangle Badge::background \brief The pill background/border rectangle (read-only). */
    readonly property alias background: bg

    // has-data-[icon=inline-start]:pl-1.5 / inline-end:pr-1.5, otherwise px-2.
    readonly property bool _hasLeading: iconName !== "" || leadingSlot.children.length > 0
    readonly property bool _hasTrailing: trailingIconName !== "" || trailingSlot.children.length > 0
    readonly property real _padLeft: _hasLeading ? Theme.space1_5 : Theme.space2
    readonly property real _padRight: _hasTrailing ? Theme.space1_5 : Theme.space2

    implicitHeight: 20                    // h-5
    implicitWidth: _padLeft + row.implicitWidth + _padRight

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Theme.radiusFull                    // rounded-full pill
        color: control.bgColor
        border.width: control.variant === Badge.Outline ? 1 : 0
        border.color: control.borderColor           // border-border
    }

    RowLayout {
        id: row
        anchors.left: parent.left
        anchors.leftMargin: control._padLeft
        anchors.verticalCenter: parent.verticalCenter
        spacing: Theme.space1                        // gap-1

        // Leading content slot (e.g. a Spinner); caller sets its color.
        Item {
            id: leadingSlot
            visible: children.length > 0
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }
        LucideIcon {
            visible: control.iconName !== ""
            name: control.iconName
            size: 10                                 // svg size-2.5
            color: control.fgColor
        }
        Text {
            visible: control.text !== ""
            text: control.text
            color: control.fgColor
            font.pixelSize: 10                       // text-[0.625rem]
            font.weight: Font.Medium
            font.underline: control.variant === Badge.Link
        }
        LucideIcon {
            visible: control.trailingIconName !== ""
            name: control.trailingIconName
            size: 10
            color: control.fgColor
        }
        // Trailing content slot.
        Item {
            id: trailingSlot
            visible: children.length > 0
            implicitWidth: childrenRect.width
            implicitHeight: childrenRect.height
        }
    }
}
