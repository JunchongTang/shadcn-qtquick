import QtQuick
import Shadcn

// Disabled state: enabled=false → whole control opacity-50 and rejects input (mirrors input-otp-disabled).
InputOtp {
    length: 6
    groups: [3, 3]
    value: "123456"
    enabled: false
}
