import QtQuick

/*!
    \qmltype BreadcrumbItem
    \inqmlmodule Shadcn
    \inherits Row
    \brief A single breadcrumb entry.

    Maps to shadcn's \c{<li class="inline-flex items-center gap-1">}. Typically
    contains one \l BreadcrumbLink or \l BreadcrumbPage; in dropdown scenarios
    it may also hold a trigger label followed by a chevron-down icon. Children
    are laid out horizontally with a 4px gap.
*/
Row {
    spacing: Theme.space1   // gap-1 = 4
}
