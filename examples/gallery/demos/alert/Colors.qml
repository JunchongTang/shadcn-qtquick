import QtQuick
import Shadcn

// Custom colors (amber), mirroring the official Custom Colors example.
Alert {
    width: 420
    iconName: "triangle-alert"
    title: qsTr("Your subscription will expire in 3 days.")
    description: qsTr("Renew now to avoid service interruption or upgrade to a paid plan to continue using the service.")
    surface: Theme.dark ? "#451a03" : "#fffbeb"        // amber-950 / amber-50
    stroke: Theme.dark ? "#78350f" : "#fde68a"         // amber-900 / amber-200
    titleColor: Theme.dark ? "#fffbeb" : "#78350f"     // amber-50 / amber-900
    descColor: Theme.dark ? "#fde68a" : "#92400e"      // amber-200 / amber-800
}
