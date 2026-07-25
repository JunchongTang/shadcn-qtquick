import QtQuick
import QtQuick.Layouts

/*!
    \qmltype EmptyContent
    \inqmlmodule Shadcn
    \inherits ColumnLayout
    \brief Action/content region of an Empty, matching base-mira EmptyContent.

    Mirrors \c .cn-empty-content (flex-col items-center max-w-sm w-full gap-2
    text-xs/relaxed): a centered column, constrained to \l maxWidth, with 8px
    (gap-2) spacing. Holds buttons, input groups, links and similar actions.

    \note Children should set \c{Layout.alignment: Qt.AlignHCenter} (or use a
    centered RowLayout) to be horizontally centered.
*/
ColumnLayout {
    id: control

    /*! \qmlproperty int EmptyContent::maxWidth
        Content width cap (max-w-sm = 384); override to change it. */
    property int maxWidth: 384

    Layout.alignment: Qt.AlignHCenter
    Layout.preferredWidth: maxWidth
    spacing: Theme.space2         // gap-2 = 8
}
