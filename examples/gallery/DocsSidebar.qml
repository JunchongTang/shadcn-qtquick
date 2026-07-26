import QtQuick
import QtQuick.Layouts
import Shadcn

// 文档站左侧导航 —— 列出组件,高亮当前项,未实现项淡显并标 "soon"。
// 可键盘导航:ListView 持焦点时 ↑/↓ 移动光标、Enter/Space 打开当前项;键盘聚焦行显焦点环。
// 选中页(currentId)用 accent 高亮;键盘光标(currentIndex)另有焦点环,两者独立。
Item {
    id: root

    property var model: []
    property string currentId: ""
    signal itemClicked(var item)

    // 暴露内部 ListView,供外部设置初始焦点(使整站键盘导航从冷启动即可用)。
    property alias listView: list

    function _indexOf(id) {
        for (var i = 0; i < root.model.length; i++)
            if (root.model[i].id === id) return i
        return -1
    }
    function _activateCurrent() {
        if (list.currentIndex >= 0 && list.currentIndex < root.model.length)
            root.itemClicked(root.model[list.currentIndex])
    }
    // 选中页变化时,把键盘光标同步到该项。
    onCurrentIdChanged: list.currentIndex = _indexOf(currentId)
    Component.onCompleted: list.currentIndex = _indexOf(currentId)

    // border-r
    Rectangle {
        anchors.right: parent.right
        height: parent.height
        width: 1
        color: Theme.border
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 12          // 内容左内距(对齐官网侧栏,避免贴窗口左缘)
        anchors.rightMargin: 1
        spacing: 0

        Text {
            Layout.leftMargin: 6
            Layout.topMargin: 16
            Layout.bottomMargin: 4
            text: qsTr("Components")
            color: Theme.foreground
            font.pixelSize: Theme.textXs
            font.weight: Font.DemiBold
        }

        ListView {
            id: list
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: root.model
            spacing: 2
            boundsBehavior: Flickable.StopAtBounds
            activeFocusOnTab: true            // 进入 Tab 链
            keyNavigationEnabled: true        // ↑/↓ 移动光标
            keyNavigationWraps: false
            highlightMoveDuration: 0
            highlight: null
            bottomMargin: 16

            // 键盘激活:Enter/Return/Space 打开当前光标项。
            Keys.onReturnPressed: root._activateCurrent()
            Keys.onEnterPressed: root._activateCurrent()
            Keys.onSpacePressed: root._activateCurrent()

            delegate: Item {
                id: navItem
                required property int index
                required property var modelData
                width: ListView.view.width - 16
                x: 8
                implicitHeight: 28

                readonly property bool selected: navItem.modelData.id === root.currentId
                readonly property bool implemented: navItem.modelData.page !== ""
                // 键盘聚焦:列表持焦点且光标落在本行。
                readonly property bool kbFocused: list.activeFocus && list.currentIndex === navItem.index

                Rectangle {
                    id: bg
                    anchors.fill: parent
                    radius: Theme.radiusMd
                    color: navItem.selected ? Theme.accent
                         : hover.hovered ? Theme.alpha(Theme.accent, 0.6) : "transparent"
                    FocusRing { active: navItem.kbFocused; targetRadius: bg.radius }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 6

                    Text {
                        Layout.fillWidth: true
                        text: navItem.modelData.label
                        color: navItem.selected ? Theme.accentForeground
                             : navItem.implemented ? Theme.foreground : Theme.mutedForeground
                        font.pixelSize: Theme.textXs
                        font.weight: navItem.selected ? Font.Medium : Font.Normal
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }
                    Text {
                        visible: !navItem.implemented
                        text: qsTr("soon")
                        color: Theme.mutedForeground
                        font.pixelSize: 9
                        opacity: 0.7
                    }
                }

                HoverHandler { id: hover }
                TapHandler {
                    // 鼠标点击:只选中,不抢焦点 → 鼠标操作不触发键盘焦点环(focus-visible 仅键盘)。
                    onTapped: {
                        list.currentIndex = navItem.index
                        root.itemClicked(navItem.modelData)
                    }
                }
            }
        }
    }
}
