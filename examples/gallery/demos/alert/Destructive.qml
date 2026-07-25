import QtQuick
import Shadcn

Alert {
    width: 420
    variant: Alert.Destructive
    iconName: "circle-alert"
    title: qsTr("Payment failed")
    description: qsTr("Your payment could not be processed. Please check your payment method and try again.")
}
