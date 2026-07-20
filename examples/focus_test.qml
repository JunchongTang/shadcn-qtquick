import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// 独立最小 Tab/焦点测试(和主项目一样用 Basic 样式)。
// 运行:  qml examples/focus_test.qml      (qml 随 Qt 附带,在 Qt 的 bin 目录)
// 目的:验证在你的 macOS + Qt 环境里,原生 Qt Quick 的 Tab 焦点导航是否工作。
//
// 三个场景各一列,便于对比:
//   1) 直接放在 Window 里的按钮(最简单)
//   2) 放在 ScrollView 里的按钮(模拟我们 Gallery 的内容区)
//   3) 放在 ScrollView + Loader 里的按钮(和 Gallery 完全一致的层级)
//
// 顶部实时显示"当前焦点项",按 Tab / Shift+Tab 看它是否在变。
Window {
    id: win
    width: 720
    height: 420
    visible: true
    title: "Focus / Tab Test — Basic style"
    color: "white"

    property string focusName: "(none)"
    function _describe(it) {
        if (!it) return "(none)"
        var t = it.toString().split("_QMLTYPE")[0].split("(")[0]
        return t + (it.text !== undefined && it.text !== "" ? (" \"" + it.text + "\"") : "")
    }
    onActiveFocusItemChanged: focusName = _describe(activeFocusItem)

    // 顶部读数
    Rectangle {
        id: bar
        width: parent.width; height: 44
        color: "#111"
        Text {
            anchors.centerIn: parent
            text: "当前焦点: " + win.focusName + "     (按 Tab / Shift+Tab 切换)"
            color: "white"; font.pixelSize: 14
        }
    }

    Row {
        anchors.top: bar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 16
        spacing: 16

        // 场景 1:直接放 Window
        Column {
            width: (parent.width - 32) / 3
            spacing: 8
            Text { text: "1) 直接放 Window"; font.bold: true }
            TextField { width: parent.width; placeholderText: "TextField" }
            Button { width: parent.width; text: "A1" }
            Button { width: parent.width; text: "A2" }
            CheckBox { text: "Check A" }
        }

        // 场景 2:ScrollView 里
        Column {
            width: (parent.width - 32) / 3
            spacing: 8
            Text { text: "2) 在 ScrollView 里"; font.bold: true }
            ScrollView {
                width: parent.width; height: 200
                Column {
                    spacing: 8
                    Button { text: "B1" }
                    Button { text: "B2" }
                    CheckBox { text: "Check B" }
                }
            }
        }

        // 场景 3:ScrollView + Loader(与 Gallery 同构)
        Column {
            width: (parent.width - 32) / 3
            spacing: 8
            Text { text: "3) ScrollView + Loader"; font.bold: true }
            ScrollView {
                width: parent.width; height: 200
                Loader {
                    sourceComponent: Component {
                        Column {
                            spacing: 8
                            Button { text: "C1" }
                            Button { text: "C2" }
                            CheckBox { text: "Check C" }
                        }
                    }
                }
            }
        }
    }

    // 建立初始焦点(和主项目同样的做法);去掉这行可对比"无初始焦点时 Tab 是否死"。
    Component.onCompleted: Qt.callLater(function () { win.contentItem.forceActiveFocus() })
}
