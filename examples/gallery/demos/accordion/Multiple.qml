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
        title: qsTr("Notification Settings")
        expanded: true
        Para { text: qsTr("Manage how you receive notifications. You can enable email alerts for updates or push notifications for mobile devices.") }
    }
    AccordionItem {
        title: qsTr("Privacy & Security")
        Para { text: qsTr("Control your privacy settings and security preferences. Enable two-factor authentication, manage connected devices and review active sessions.") }
    }
    AccordionItem {
        title: qsTr("Billing & Subscription")
        last: true
        Para { text: qsTr("View your current plan, payment history and upcoming invoices. Update your payment method or change your subscription tier.") }
    }
}
