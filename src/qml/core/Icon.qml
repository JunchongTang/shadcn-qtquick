import QtQuick
import LucideIcons

/*!
    \qmltype Icon
    \inqmlmodule Shadcn
    \inherits Item
    \brief Library-agnostic icon slot used by all components.

    Icon renders a canonical icon \l name through a swappable delegate, so the
    whole library's icon set can be changed in one place instead of being hard
    wired to Lucide. Components use \c {Icon { name: ...; size: ...; color: ... }}
    rather than a concrete icon type.

    By default the delegate is \l LucideIcon. Assign \l Theme::iconDelegate a
    \c Component whose root exposes \c name, \c size and \c color to switch the
    entire application to a different icon library; those three properties are
    bound onto the delegate automatically.

    For a one-off custom icon, don't use Icon — components that support it expose
    a \c icon \c Component slot that replaces this whole element.
*/
Item {
    id: root

    /*! The canonical icon name (library-agnostic). Empty hides the icon. */
    property string name: ""
    /*! Icon edge length in px. */
    property int size: 16
    /*! Icon color. */
    property color color: Theme.foreground
    /*!
        The delegate that draws the icon. Defaults to \l Theme::iconDelegate,
        or the built-in Lucide delegate when that is null. A delegate's root
        must expose \c name, \c size and \c color.
    */
    property Component delegate: Theme.iconDelegate

    implicitWidth: size
    implicitHeight: size
    visible: name !== ""

    Component {
        id: lucideDelegate
        LucideIcon {}
    }

    Loader {
        anchors.fill: parent
        sourceComponent: root.delegate ? root.delegate : lucideDelegate
        onLoaded: {
            item.name = Qt.binding(function () { return root.name })
            item.size = Qt.binding(function () { return root.size })
            item.color = Qt.binding(function () { return root.color })
        }
    }
}
