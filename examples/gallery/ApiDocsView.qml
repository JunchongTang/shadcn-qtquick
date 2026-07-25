import QtQuick
import QtWebView
import Shadcn

// Embedded API-reference pane: renders a generated qdoc HTML page in a native
// web view. The URL is fed by Gallery.qml (served over local HTTP by main.cpp,
// since WKWebView refuses file://); navigation controls live in the shared
// content-area toolbar and drive this via the exposed properties/functions.
Item {
    id: root

    property url pageUrl
    readonly property bool canGoBack: web.canGoBack
    readonly property url currentUrl: web.url

    function goBack() { web.goBack() }
    function reload() { web.reload() }

    onPageUrlChanged: if (String(pageUrl) !== "") web.url = pageUrl

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
