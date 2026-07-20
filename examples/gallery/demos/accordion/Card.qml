import QtQuick
import QtQuick.Layouts
import Shadcn

Card {
    width: 340
    CardHeader {
        CardTitle { text: "Subscription & Billing" }
        CardDescription { text: "Common questions about your account, plans, payments and cancellations." }
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
                title: "What subscription plans do you offer?"
                expanded: true
                Para { text: "We offer three tiers: Starter, Professional and Enterprise, each with increasing storage, API access and priority support." }
            }
            AccordionItem {
                title: "How does billing work?"
                Para { text: "Billing occurs automatically at the start of each cycle. We accept major credit cards, PayPal and ACH transfers for enterprise." }
            }
            AccordionItem {
                title: "How do I cancel my subscription?"
                last: true
                Para { text: "You can cancel anytime from your account settings. There are no cancellation fees; access continues until the end of the period." }
            }
        }
    }
}
