import QtQuick
import QtQuick.Layouts

/*!
    \qmltype EmptyHeader
    \inqmlmodule Shadcn
    \inherits ColumnLayout
    \brief Header region wrapping media/title/description, matching base-mira EmptyHeader.

    Mirrors \c .cn-empty-header (flex-col items-center max-w-sm gap-1): a centered
    column constrained to \l maxWidth with 4px (gap-1) spacing. Typically holds an
    EmptyMedia, an EmptyTitle and an EmptyDescription.
*/
ColumnLayout {
    id: control

    /*! \qmlproperty int EmptyHeader::maxWidth
        Content width cap (max-w-sm = 384) so title/description wrap and center;
        override to change it. */
    property int maxWidth: 384

    Layout.alignment: Qt.AlignHCenter
    Layout.preferredWidth: maxWidth
    spacing: Theme.space1    // gap-1 = 4
}
