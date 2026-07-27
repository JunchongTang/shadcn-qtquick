import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

// Standalone minimal Tab/focus test (uses the Basic style, same as the main project).
// Run:  qml examples/focus_test.qml      (qml ships with Qt, in Qt's bin directory)
// Purpose: verify whether native Qt Quick Tab focus navigation works in your macOS + Qt environment.
//
// Three scenarios, one column each, for easy comparison:
//   1) Buttons placed directly in the Window (simplest)
//   2) Buttons inside a ScrollView (mimics our Gallery content area)
//   3) Buttons inside a ScrollView + Loader (exact same hierarchy as Gallery)
//
// The top shows the "current focus item" live; press Tab / Shift+Tab to see whether it changes.
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

    // Top readout
    Rectangle {
        id: bar
        width: parent.width; height: 44
        color: "#111"
        Text {
            anchors.centerIn: parent
            text: "Current focus: " + win.focusName + "     (press Tab / Shift+Tab to switch)"
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

        // Scenario 1: directly in Window
        Column {
            width: (parent.width - 32) / 3
            spacing: 8
            Text { text: "1) Directly in Window"; font.bold: true }
            TextField { width: parent.width; placeholderText: "TextField" }
            Button { width: parent.width; text: "A1" }
            Button { width: parent.width; text: "A2" }
            CheckBox { text: "Check A" }
        }

        // Scenario 2: inside ScrollView
        Column {
            width: (parent.width - 32) / 3
            spacing: 8
            Text { text: "2) Inside ScrollView"; font.bold: true }
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

        // Scenario 3: ScrollView + Loader (same structure as Gallery)
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

    // Establish initial focus (same approach as the main project); remove this line to compare whether Tab is dead without initial focus.
    Component.onCompleted: Qt.callLater(function () { win.contentItem.forceActiveFocus() })
}
