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
        title: "Notification Settings"
        expanded: true
        Para { text: "Manage how you receive notifications. You can enable email alerts for updates or push notifications for mobile devices." }
    }
    AccordionItem {
        title: "Privacy & Security"
        Para { text: "Control your privacy settings and security preferences. Enable two-factor authentication, manage connected devices and review active sessions." }
    }
    AccordionItem {
        title: "Billing & Subscription"
        last: true
        Para { text: "View your current plan, payment history and upcoming invoices. Update your payment method or change your subscription tier." }
    }
}
