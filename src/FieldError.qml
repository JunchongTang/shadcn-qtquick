import QtQuick
import QtQuick.Layouts

/*!
    \qmltype FieldError
    \inqmlmodule Shadcn
    \inherits ColumnLayout
    \brief Validation error container (role="alert", destructive text-xs/relaxed).

    Provide a single message via \l text, or an array of messages via \l errors
    (duplicates are removed). More than one message renders as a bulleted list.
    The container hides itself (visible = false) when there is no content.

    \qmlproperty string FieldError::text
    A single error message. Takes precedence over \l errors when non-empty.

    \qmlproperty var FieldError::errors
    An array of error message strings; duplicates are removed before display.
*/
ColumnLayout {
    id: err

    property string text: ""
    property var errors: []

    // Normalised, de-duplicated list of messages.
    readonly property var _list: {
        if (text !== "")
            return [text]
        if (!errors || errors.length === 0)
            return []
        var seen = ({})
        var out = []
        for (var i = 0; i < errors.length; i++) {
            var m = errors[i]
            if (m && !seen[m]) {
                seen[m] = true
                out.push(m)
            }
        }
        return out
    }

    Layout.fillWidth: true
    spacing: Theme.space1
    visible: _list.length > 0

    Repeater {
        model: err._list
        delegate: Text {
            required property string modelData
            Layout.fillWidth: true
            // Prefix a bullet when there is more than one message (list-disc).
            text: err._list.length > 1 ? ("•  " + modelData) : modelData
            color: Theme.destructive
            font.pixelSize: Theme.textXs
            lineHeight: Theme.lineRelaxed
            lineHeightMode: Text.ProportionalHeight
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignLeft
        }
    }
}
