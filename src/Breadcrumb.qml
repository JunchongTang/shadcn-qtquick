import QtQuick
import QtQuick.Layouts

/*!
    \qmltype Breadcrumb
    \inqmlmodule Shadcn
    \inherits RowLayout
    \brief Root container for a breadcrumb trail.

    Maps to shadcn's \c{<nav> > <ol class="flex flex-wrap items-center gap-1.5">}.
    Place \l BreadcrumbItem and \l BreadcrumbSeparator instances directly as
    children; each child supplies its own color and font (base-mira applies
    \c{text-muted-foreground} + \c{text-xs/relaxed} at list level, replicated
    per-child here since QML has no CSS inheritance).

    A RowLayout is used so children are vertically centered (\c items-center):
    Layout.alignment defaults to \c{Qt.AlignVCenter | Qt.AlignLeft}.

    \note flex-wrap is not implemented; the trail is rendered on a single row,
    which is sufficient for the reference previews.
*/
RowLayout {
    spacing: Theme.space1_5   // gap-1.5 = 6
}
