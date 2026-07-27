import QtQuick
import QtQuick.Layouts
import Shadcn

// loading: show a spinning Spinner inside the button and disable interaction (dim).
RowLayout {
    spacing: 8
    Button { variant: Button.Outline; text: qsTr("Generating"); loading: true }
    Button { variant: Button.Secondary; text: qsTr("Downloading"); loading: true }
}
