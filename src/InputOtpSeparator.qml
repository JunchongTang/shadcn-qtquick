import QtQuick
import LucideIcons

// shadcn InputOTPSeparator —— 组间分隔符(对标 .cn-input-otp-separator,默认 MinusIcon,size-4)。
Item {
    id: root

    property string iconName: "minus"

    implicitWidth: 16
    implicitHeight: 28

    LucideIcon {
        anchors.centerIn: parent
        name: root.iconName
        size: 16                        // svg size-4
        color: Theme.mutedForeground
    }
}
