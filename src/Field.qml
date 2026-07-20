import QtQuick
import QtQuick.Layouts

// shadcn Field —— 单个表单字段容器(role="group")。orientation 控制排布。
//   vertical   : 纵向堆叠(标签/控件/描述/错误),子项占满宽度。(gap-2)
//   horizontal : 横排 —— 标签/内容在左、控件在右(按源码书写顺序),默认垂直居中。
//   responsive : 前端为容器查询自适应(窄屏堆叠 / 宽屏横排),QML 侧简化为 horizontal
//                并以注释标注(gallery 宽度足够,统一取横排)。
// 用 GridLayout 单行/单列切换实现两种朝向,避免运行期改基类。
GridLayout {
    id: field

    enum Orientation { Vertical, Horizontal, Responsive }

    property int orientation: Field.Vertical
    // data-invalid → 字段整体进入错误态(子件 FieldLabel/FieldTitle/FieldDescription
    // 可绑定 field.invalid 转破坏色;FieldError 恒为破坏色)。
    property bool invalid: false

    // responsive 简化为横排(见文件头说明)。
    readonly property bool horizontal: orientation === Field.Horizontal
                                       || orientation === Field.Responsive

    Layout.fillWidth: true
    flow: horizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight
    rows: horizontal ? 1 : -1
    columns: horizontal ? -1 : 1
    rowSpacing: Theme.space2        // gap-2
    columnSpacing: Theme.space2
}
