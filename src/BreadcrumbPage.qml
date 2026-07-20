import QtQuick

// shadcn BreadcrumbPage —— 当前页(= <span class="cn-breadcrumb-page">,不可点击)。
// base-mira: text-foreground + font-normal。
Text {
    color: Theme.foreground
    font.pixelSize: Theme.textXs        // text-xs
    font.family: Theme.fontSans
    font.weight: Font.Normal            // font-normal
    verticalAlignment: Text.AlignVCenter
}
