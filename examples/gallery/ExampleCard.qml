import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Shadcn

// 文档站示例卡片 —— 对齐 ui.shadcn.com:标题/描述在卡片之上;
// 单张卡片内「预览在上 + 代码区融合在下」,代码默认折叠(渐隐 + View Code),点击展开。
ColumnLayout {
    id: card

    property string title: ""
    property string description: ""
    property url source                 // 示例 qml 文件 URL(qrc:/demos/...)
    property int previewMinHeight: 220
    property string code: ""
    property bool codeExpanded: false

    readonly property int _collapsedCodeH: 92
    readonly property int _lineCount: code === "" ? 1 : code.split("\n").length

    // 由 source 推导出的可复制路径,形如 Component/ButtonGroup/Orientation
    //   qrc:/demos/button-group/Orientation.qml → 组件目录转 PascalCase + 文件名。
    readonly property string cardPath: {
        var m = String(source).match(/demos\/([^/]+)\/([^/]+)\.qml$/)
        if (!m)
            return ""
        var comp = m[1].split("-").map(function (w) {
            return w.charAt(0).toUpperCase() + w.slice(1)
        }).join("")
        return "Component/" + comp + "/" + m[2]
    }

    Layout.fillWidth: true
    spacing: 8

    // ==== 标题 +(右侧)复制路径按钮 ====
    RowLayout {
        Layout.fillWidth: true
        visible: card.title !== ""
        spacing: 8

        Text {
            text: card.title
            color: Theme.foreground
            font.pixelSize: 20
            font.weight: Font.DemiBold
        }
        Item { Layout.fillWidth: true }

        // 复制路径:点击把 cardPath 写入剪贴板,并短暂显示 √ 反馈。
        IconButton {
            id: copyBtn
            visible: card.cardPath !== ""
            iconName: copyBtn._copied ? qsTr("check") : qsTr("copy")
            variant: IconButton.Ghost
            size: IconButton.Small
            property bool _copied: false
            onClicked: {
                SourceReader.copyToClipboard(card.cardPath)
                copyBtn._copied = true
                copiedTimer.restart()
                var w = Window.window
                if (w && typeof w.notifyCopied === "function")
                    w.notifyCopied(card.cardPath)
            }
            Timer {
                id: copiedTimer
                interval: 1200
                onTriggered: copyBtn._copied = false
            }
        }
    }
    Text {
        Layout.fillWidth: true
        visible: card.description !== ""
        text: card.description
        color: Theme.mutedForeground
        font.pixelSize: Theme.textSm
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }

    // ==== 融合卡片:预览 + 代码 ====
    Rectangle {
        Layout.fillWidth: true
        Layout.topMargin: 4
        implicitHeight: previewArea.implicitHeight + seam.height + codeArea.implicitHeight
        radius: Theme.radiusLg
        color: Theme.card
        border.width: Theme.overlayRingWidth
        border.color: Theme.overlayRing
        clip: true

        Column {
            anchors.fill: parent

            // ---- 预览区 ----
            Item {
                id: previewArea
                width: parent.width
                implicitHeight: Math.max(card.previewMinHeight, previewLoader.implicitHeight + 56)

                Loader {
                    id: previewLoader
                    anchors.centerIn: parent
                    source: card.source
                    // 若 demo 声明 fillCard:true(宽表等),让它填满卡片宽度(留 24px 边距),
                    // 随卡片/窗口变宽而变宽;否则保持其固有尺寸并居中。
                    onLoaded: if (item && item.fillCard === true)
                        item.width = Qt.binding(function () { return Math.max(320, previewArea.width - 48) })
                }
            }

            // ---- 分隔线 ----
            Rectangle {
                id: seam
                width: parent.width
                height: 1
                color: Theme.border
            }

            // ---- 代码区(可折叠)----
            Item {
                id: codeArea
                width: parent.width
                implicitHeight: card.codeExpanded
                    ? Math.min(codeText.implicitHeight + 32, 420)
                    : card._collapsedCodeH

                // Muted background; bottom corners rounded to match the card
                // (the card's clip only clips to its rectangular bounds).
                Rectangle {
                    anchors.fill: parent
                    color: Theme.muted
                    bottomLeftRadius: Theme.radiusLg
                    bottomRightRadius: Theme.radiusLg
                }

                // 代码 + 行号(展开时可滚)。折叠时禁用交互,让滚轮穿透到页面,
                // 不被这块代码区域截获(对齐官网:未展开不在代码区滚动)。
                ScrollView {
                    id: codeScroll
                    anchors.fill: parent
                    anchors.margins: 16
                    clip: true
                    enabled: card.codeExpanded
                    contentWidth: codeRow.implicitWidth

                    Row {
                        id: codeRow
                        spacing: 16
                        Text {
                            text: {
                                var s = ""
                                for (var i = 1; i <= card._lineCount; i++)
                                    s += i + (i < card._lineCount ? qsTr("\n") : "")
                                return s
                            }
                            color: Theme.alpha(Theme.mutedForeground, 0.6)
                            font.family: Theme.fontMono
                            font.pixelSize: Theme.textXs
                            lineHeight: 1.5
                            lineHeightMode: Text.ProportionalHeight
                            horizontalAlignment: Text.AlignRight
                        }
                        Text {
                            id: codeText
                            text: card.code
                            color: Theme.foreground
                            font.family: Theme.fontMono
                            font.pixelSize: Theme.textXs
                            lineHeight: 1.5
                            lineHeightMode: Text.ProportionalHeight
                            textFormat: Text.PlainText
                        }
                    }
                }

                // 折叠时底部渐隐(底部两角圆角,与卡片一致)
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 48
                    visible: !card.codeExpanded
                    bottomLeftRadius: Theme.radiusLg
                    bottomRightRadius: Theme.radiusLg
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Theme.alpha(Theme.muted, 0) }
                        GradientStop { position: 1.0; color: Theme.muted }
                    }
                }

                // View Code / Collapse 按钮
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: card.codeExpanded ? 10 : 6
                    text: card.codeExpanded ? qsTr("Collapse") : qsTr("View Code")
                    size: Button.Sm
                    variant: Button.Outline
                    onClicked: card.codeExpanded = !card.codeExpanded
                }
            }
        }
    }

    // ==== 读取示例源码(C++ SourceReader 用 QFile 直读 qrc)====
    function loadCode() {
        card.code = String(card.source) === "" ? "" : SourceReader.read(card.source)
    }
    onSourceChanged: loadCode()
    Component.onCompleted: loadCode()
}
