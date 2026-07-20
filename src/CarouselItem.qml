import QtQuick

// Carousel 单个条目 —— 由使用方填入任意内容(default 内容槽)。
// 尺寸随所属 Carousel 视口派生:横向 width = 视口宽 × basis;纵向 height = 视口高 × basis。
// basis 对标 shadcn 的 basis-* 工具类:basis-full=1、basis-1/2=0.5、basis-1/3≈0.333。
// 条目间隔由所属 ListView 的 spacing 提供(对称、不偏移内容);内容满铺本条目。
// 注:早前用单侧左内边距(pl)造间隔但缺 -ml 补偿,会把 basis-full 幻灯片整体推向一侧、
//     导致左右两侧到导航按钮的间隙不对称,故改用 ListView.spacing。
Item {
    id: item

    property real basis: 1.0
    default property alias content: holder.data

    readonly property var _view: ListView.view
    readonly property bool _horizontal: _view ? _view.horizontalFlow : true

    implicitWidth: _view ? (_horizontal ? _view.width * basis : _view.width) : 0
    implicitHeight: _view ? (_horizontal ? _view.height : _view.height * basis) : 0
    width: implicitWidth
    height: implicitHeight

    Item {
        id: holder
        anchors.fill: parent
    }
}
