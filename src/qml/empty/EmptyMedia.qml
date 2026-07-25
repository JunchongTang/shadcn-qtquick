import QtQuick
import QtQuick.Layouts
import LucideIcons

/*!
    \qmltype EmptyMedia
    \inqmlmodule Shadcn
    \inherits Item
    \brief Media slot of an Empty (icon chip / avatar / spinner), matching base-mira EmptyMedia.

    Mirrors \c .cn-empty-media (mb-2; items-center justify-center shrink-0). Two
    variants: \c EmptyMedia.Default (bg-transparent, sized to its content, e.g. an
    avatar) and \c EmptyMedia.Icon (\c .cn-empty-media-icon: bg-muted, size-8,
    rounded-md, inner svg size-4).

    For the icon variant, set \l iconName for a convenience Lucide glyph, or place
    a child (e.g. a Spinner) into the default content slot.
*/
Item {
    id: control

    enum Variant { Default, Icon }

    /*! \qmlproperty enumeration EmptyMedia::variant
        Media variant.
        \value EmptyMedia.Default Transparent, sized to content (avatars).
        \value EmptyMedia.Icon 32px muted rounded chip holding a 16px icon. */
    property int variant: EmptyMedia.Default

    /*! \qmlproperty string EmptyMedia::iconName
        Convenience Lucide icon name shown when \l variant is \c EmptyMedia.Icon. */
    property string iconName: ""

    /*! \qmlproperty list<QtObject> EmptyMedia::content
        Default property: centered media items (avatar, spinner, custom svg). */
    default property alias content: slot.data

    Layout.alignment: Qt.AlignHCenter
    Layout.bottomMargin: Theme.space2    // mb-2 = 8 (adds to the header's gap-1)

    readonly property bool _icon: variant === EmptyMedia.Icon
    implicitWidth: _icon ? 32 : slot.childrenRect.width      // size-8
    implicitHeight: _icon ? 32 : slot.childrenRect.height

    // Rounded muted chip behind the icon variant.
    Rectangle {
        anchors.fill: parent
        visible: control._icon
        radius: Theme.radiusMd           // rounded-md = 8
        color: Theme.muted               // bg-muted
    }

    // Convenience Lucide glyph for the icon variant (svg size-4 = 16, text-foreground).
    LucideIcon {
        anchors.centerIn: parent
        visible: control._icon && control.iconName !== ""
        name: control.iconName
        size: 16
        color: Theme.foreground
    }

    // Centered slot for custom media (avatar, avatar group, spinner).
    Item {
        id: slot
        anchors.centerIn: parent
        implicitWidth: childrenRect.width
        implicitHeight: childrenRect.height
    }
}
