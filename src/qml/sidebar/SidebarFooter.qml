import QtQuick
import QtQuick.Layouts

/*!
    \qmltype SidebarFooter
    \inqmlmodule Shadcn
    \inherits Item
    \brief The bottom region of a \l Sidebar.

    SidebarFooter is the QML port of shadcn's \c SidebarFooter
    (\c .cn-sidebar-footer). It applies \c p-2 padding (8px) around its children
    and stacks them vertically with \c gap-2 (8px) spacing.

    \sa Sidebar, SidebarHeader
*/
Item {
    id: control

    /*! \qmlproperty list<QtObject> SidebarFooter::content
        Default child list, stacked vertically inside the padded column. */
    default property alias content: inner.data

    Layout.fillWidth: true
    implicitHeight: inner.implicitHeight + 16   // p-2 (8px top + 8px bottom)

    ColumnLayout {
        id: inner
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 8                       // p-2
        spacing: 8                               // gap-2
    }
}
