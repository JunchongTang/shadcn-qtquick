import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Shadcn

// Docs site example card — matches ui.shadcn.com: title/description above the card;
// within a single card "preview on top + code area fused below", code collapsed by default (fade + View Code), click to expand.
ColumnLayout {
    id: card

    property string title: ""
    property string description: ""
    property url source                 // Example qml file URL (qrc:/demos/...)
    property int previewMinHeight: 220
    property string code: ""
    property bool codeExpanded: false

    readonly property int _collapsedCodeH: 92
    readonly property int _lineCount: code === "" ? 1 : code.split("\n").length
    // Expanded code height derived purely from the line count (each mono line
    // renders at ~textXs*1.75, i.e. 21px for textXs=12). Computing it — rather
    // than reading the code Text's implicitHeight — keeps codeArea.implicitHeight
    // a pure arithmetic value that can never enter a binding loop; the code Text
    // lives inside a fill-anchored ScrollView, which otherwise risks a transient
    // implicitHeight loop during the ScrollView's content init.
    readonly property int _codeContentH: _lineCount * Math.round(Theme.textXs * 1.75)

    // Copyable path derived from source, e.g. Component/ButtonGroup/Orientation
    //   qrc:/demos/button-group/Orientation.qml → component directory to PascalCase + file name.
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

    // ==== Title + (right) copy-path button ====
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

        // Copy path: on click write cardPath to the clipboard and briefly show a √ confirmation.
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

    // ==== Fused card: preview + code ====
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

            // ---- Preview area ----
            Item {
                id: previewArea
                width: parent.width
                implicitHeight: Math.max(card.previewMinHeight, previewLoader.implicitHeight + 56)

                Loader {
                    id: previewLoader
                    anchors.centerIn: parent
                    source: card.source
                    // If the demo declares fillCard:true (wide tables, etc.), let it fill the card width (leaving a 24px margin),
                    // growing as the card/window widens; otherwise keep its intrinsic size and center it.
                    onLoaded: if (item && item.fillCard === true)
                        item.width = Qt.binding(function () { return Math.max(320, previewArea.width - 48) })
                }
            }

            // ---- Separator line ----
            Rectangle {
                id: seam
                width: parent.width
                height: 1
                color: Theme.border
            }

            // ---- Code area (collapsible) ----
            Item {
                id: codeArea
                width: parent.width
                // Height is computed from the line count (card._codeContentH) plus
                // the 32px ScrollView margins, capped at 420 — never read from a
                // child Item's implicitHeight, so this can't form a binding loop.
                implicitHeight: card.codeExpanded
                    ? Math.min(card._codeContentH + 32, 420)
                    : card._collapsedCodeH

                // Muted background; bottom corners rounded to match the card
                // (the card's clip only clips to its rectangular bounds).
                Rectangle {
                    anchors.fill: parent
                    color: Theme.muted
                    bottomLeftRadius: Theme.radiusLg
                    bottomRightRadius: Theme.radiusLg
                }

                // Code + line numbers (scrollable when expanded). When collapsed, disable interaction so the wheel passes through to the page,
                // rather than being captured by this code area (matches the official site: no scrolling in the code area while collapsed).
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

                // Bottom fade when collapsed (bottom two corners rounded, matching the card)
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

                // View Code / Collapse button
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

    // ==== Read example source (C++ SourceReader reads qrc directly via QFile) ====
    function loadCode() {
        card.code = String(card.source) === "" ? "" : SourceReader.read(card.source)
    }
    onSourceChanged: loadCode()
    Component.onCompleted: loadCode()
}
