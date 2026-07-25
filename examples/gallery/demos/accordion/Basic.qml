import QtQuick
import QtQuick.Layouts
import Shadcn

Accordion {
    width: 420

    AccordionItem {
        title: qsTr("Is it accessible?")
        expanded: true
        Text {
            Layout.fillWidth: true
            text: qsTr("Yes. It adheres to the WAI-ARIA design pattern.")
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
            wrapMode: Text.Wrap
        }
    }
    AccordionItem {
        title: qsTr("Is it styled?")
        Text {
            Layout.fillWidth: true
            text: qsTr("Yes. It comes with styles that match the base-mira theme out of the box.")
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
            wrapMode: Text.Wrap
        }
    }
    AccordionItem {
        title: qsTr("Is it animated?")
        last: true
        Text {
            Layout.fillWidth: true
            text: qsTr("Yes. It's animated by default, expanding and collapsing smoothly.")
            color: Theme.mutedForeground
            font.pixelSize: Theme.textXs
            wrapMode: Text.Wrap
        }
    }
}
