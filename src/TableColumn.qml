import QtQuick

// Table 的声明式列定义。用作 Table.columnItems 的元素:
//   Table {
//       model: […]
//       columnItems: [
//           TableColumn { title: "Status"; key: "status"; width: 150 }
//           TableColumn { title: "Email";  key: "email" }               // 不设 width → 占剩余(fill)
//           TableColumn { title: "Amount"; key: "amount"; width: 120; align: Qt.AlignRight; medium: true
//                         format: v => "$" + v.toFixed(2) }
//       ]
//   }
// 属性与 columns 的 JS 对象一一对应,两种写法可互换。
QtObject {
    property string title: ""
    property string key: ""            // JS 数组模式取行对象字段
    property string role: ""           // item model 模式取的角色(空 → "display")
    property real width: 0             // >0 固定宽;否则 fill(占剩余空间)
    property bool fillWidth: false     // 强制 fill(即便设了 width)
    property real minWidth: 0          // 0 表示不限
    property real maxWidth: 0          // 0 表示不限
    property int align: Text.AlignLeft
    property var format: null          // function(value) -> string
    property bool medium: false        // 加粗
    // 自定义渲染(可选)。与 JS columns 的同名字段一致:
    //   cellDelegate 内经 parent 访问 value/row/rowData/table;headerDelegate 经 parent 访问 column/table。
    property Component cellDelegate: null
    property Component headerDelegate: null
}
