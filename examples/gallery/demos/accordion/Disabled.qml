import QtQuick
import QtQuick.Layouts
import Shadcn

Accordion {
    width: 460

    component Para: Text {
        Layout.fillWidth: true
        color: Theme.mutedForeground
        font.pixelSize: Theme.textXs
        lineHeight: Theme.lineRelaxed
        lineHeightMode: Text.ProportionalHeight
        wrapMode: Text.Wrap
    }

    AccordionItem {
        title: qsTr("Can I access my account history?")
        expanded: true
        Para { text: qsTr("Yes, you can view your complete account history including all transactions, plan changes and support tickets in the Account History section.") }
    }
    AccordionItem {
        title: qsTr("Premium feature information")
        enabled: false
        Para { text: qsTr("This section contains information about premium features. Upgrade your plan to access this content.") }
    }
    AccordionItem {
        title: qsTr("How do I update my email address?")
        last: true
        Para { text: qsTr("You can update your email address in your account settings. You'll receive a verification email at your new address to confirm the change.") }
    }
}
