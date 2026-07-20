import QtQuick

// shadcn BreadcrumbItem —— 单个面包屑项(= <li class="inline-flex items-center gap-1">)。
// 通常内含一个 BreadcrumbLink / BreadcrumbPage;下拉场景可再放触发文本 + chevron-down。
Row {
    spacing: Theme.space1   // gap-1 = 4
    // items-center:等高子项在 Row 中自然对齐。
}
