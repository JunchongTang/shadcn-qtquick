import QtQuick
import QtQuick.Layouts
import Shadcn

Card {
    width: 340
    CardHeader {
        CardTitle { text: qsTr("Subscription & Billing") }
        CardDescription { text: qsTr("Common questions about your account, plans, payments and cancellations.") }
    }
    CardContent {
        Accordion {
            Layout.fillWidth: true
            bordered: false

            component Para: Text {
                Layout.fillWidth: true
                color: Theme.mutedForeground
                font.pixelSize: Theme.textXs
                lineHeight: Theme.lineRelaxed
                lineHeightMode: Text.ProportionalHeight
                wrapMode: Text.Wrap
            }

            AccordionItem {
                title: qsTr("What subscription plans do you offer?")
                expanded: true
                Para { text: qsTr("We offer three tiers: Starter, Professional and Enterprise, each with increasing storage, API access and priority support.") }
            }
            AccordionItem {
                title: qsTr("How does billing work?")
                Para { text: qsTr("Billing occurs automatically at the start of each cycle. We accept major credit cards, PayPal and ACH transfers for enterprise.") }
            }
            AccordionItem {
                title: qsTr("How do I cancel my subscription?")
                last: true
                Para { text: qsTr("You can cancel anytime from your account settings. There are no cancellation fees; access continues until the end of the period.") }
            }
        }
    }
}
