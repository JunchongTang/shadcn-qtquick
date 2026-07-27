import QtQuick
import Shadcn

// Error state: invalid=true → border/ring switch to destructive color (mirrors input-otp-invalid).
InputOtp {
    length: 6
    groups: [2, 2, 2]
    value: "000000"
    invalid: true
}
