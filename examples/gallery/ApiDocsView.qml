import QtQuick
import QtQuick.Layouts
import QtWebView
import Shadcn

// Embedded API-reference pane: renders a generated qdoc HTML page in a native
// web view, with a thin toolbar (back / reload / open externally). Fed a
// file:// URL by Gallery.qml; QtWebView is initialized in main.cpp.
ColumnLayout {
    id: root

    property url pageUrl

    spacing: 0

    onPageUrlChanged: if (String(pageUrl) !== "") web.url = pageUrl

    // ==== Toolbar ====
    RowLayout {
        Layout.fillWidth: true
        Layout.leftMargin: 8
        Layout.rightMargin: 8
        Layout.topMargin: 6
        Layout.bottomMargin: 6
        spacing: 4

        IconButton {
            iconName: "arrow-left"
            variant: IconButton.Ghost
            size: IconButton.Small
            enabled: web.canGoBack
            onClicked: web.goBack()
        }
        IconButton {
            iconName: "rotate-cw"
            variant: IconButton.Ghost
            size: IconButton.Small
            onClicked: web.reload()
        }
        Text {
            Layout.fillWidth: true
            text: qsTr("API Reference")
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        IconButton {
            iconName: "external-link"
            variant: IconButton.Ghost
            size: IconButton.Small
            onClicked: Qt.openUrlExternally(web.url)
        }
    }
    Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: Theme.border }

    // ==== Web view ====
    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true

        WebView {
            id: web
            anchors.fill: parent
            url: root.pageUrl
        }

        // Centered spinner while a page loads (Spinner runs while visible).
        Spinner {
            anchors.centerIn: parent
            visible: web.loading
        }
    }
}
