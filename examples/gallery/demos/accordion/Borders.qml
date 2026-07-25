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
        title: qsTr("How does billing work?")
        expanded: true
        Para { text: qsTr("We offer monthly and annual plans. Billing is charged at the beginning of each cycle, and you can cancel anytime.") }
    }
    AccordionItem {
        title: qsTr("Is my data secure?")
        Para { text: qsTr("Yes. We use end-to-end encryption, SOC 2 Type II compliance and regular third-party security audits.") }
    }
    AccordionItem {
        title: qsTr("What integrations do you support?")
        last: true
        Para { text: qsTr("We integrate with 500+ popular tools including Slack, Zapier, Salesforce and more, plus a REST API and webhooks.") }
    }
}
