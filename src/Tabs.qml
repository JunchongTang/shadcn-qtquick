import QtQuick
import QtQuick.Controls.Basic as C

// shadcn Tabs(分段胶囊 · segmented pill)—— 无前缀,基类别名导入(as C)。
// 作为容器:muted 底、radiusMd、内边距 space1,横向排布 TabButton。
// 内容切换交由使用方(StackLayout.currentIndex ↔ Tabs.currentIndex),此处不管理内容。
C.TabBar {
    id: control

    implicitHeight: 32          // h-8
    spacing: 0                  // 默认变体紧贴无间隙,激活胶囊填满
    padding: Theme.space1 - 1   // p-[3px]

    background: Rectangle {
        radius: Theme.radiusMd
        color: Theme.muted
    }
}
