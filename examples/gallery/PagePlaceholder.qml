import QtQuick
import QtQuick.Layouts
import Shadcn

// Placeholder page for unimplemented components.
PageScaffold {
    description: qsTr("This component has not been ported yet. Examples aligned with ui.shadcn.com will be shown here.")

    Preview {
        title: qsTr("Coming soon")
        RowLayout {
            spacing: 8
            Badge { text: qsTr("Not implemented"); variant: Badge.Outline }
        }
    }
}
