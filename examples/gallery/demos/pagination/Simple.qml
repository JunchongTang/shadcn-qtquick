import QtQuick
import Shadcn

// Minimal pagination with page numbers only (previous / next hidden).
Pagination {
    count: 5
    page: 2
    showPrevNext: false
}
