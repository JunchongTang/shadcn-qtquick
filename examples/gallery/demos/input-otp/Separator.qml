import QtQuick
import Shadcn

// With separators: three 2+2+2 groups, InputOtpSeparator auto-inserted between groups (mirrors input-otp-separator).
InputOtp {
    length: 6
    groups: [2, 2, 2]
}
