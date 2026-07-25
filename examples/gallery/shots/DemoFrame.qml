import QtQuick
import Shadcn

// Generic wrapper for a demo hero shot: a themed surface with the demo loaded
// and centered. The demo URL and an optional forced content width are supplied
// via the `shotSource` / `shotContentWidth` context properties (see shooter.cpp).
// The loaded item is sized explicitly to its implicit size because Layout-rooted
// demos do not self-size as a Loader's item.
Rectangle {
    id: frame
    color: Theme.background
    property int pad: 24
    property Item content: ld.item

    implicitWidth: (content ? content.width : 0) + pad * 2
    implicitHeight: (content ? content.height : 0) + pad * 2
    width: implicitWidth
    height: implicitHeight

    Loader {
        id: ld
        anchors.centerIn: parent
        source: (typeof shotSource !== "undefined") ? shotSource : ""
        onLoaded: {
            if (!item)
                return
            var cw = (typeof shotContentWidth !== "undefined") ? shotContentWidth : 0
            var ch = (typeof shotContentHeight !== "undefined") ? shotContentHeight : 0
            item.width = Qt.binding(function() { return cw > 0 ? cw : item.implicitWidth })
            item.height = Qt.binding(function() { return ch > 0 ? ch : item.implicitHeight })
        }
    }
}
