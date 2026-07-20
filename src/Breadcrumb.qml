import QtQuick
import QtQuick.Layouts

// shadcn Breadcrumb —— 根容器(= <nav> > <ol class="flex flex-wrap items-center gap-1.5">)。
// 直接放入 BreadcrumbItem / BreadcrumbSeparator 作为子项。
// base-mira: list 用 text-muted-foreground + gap-1.5 + text-xs/relaxed。各子组件自带默认色。
// 注:用 RowLayout 保证 items-center 垂直居中(与官方一致);未实现 flex-wrap(预览为单行,足够贴合)。
RowLayout {
    spacing: Theme.space1_5   // gap-1.5 = 6
}
