import QtQuick
import Shadcn

// Four-digit PIN: maxLength=4 + digits only (mirrors input-otp-four-digits).
InputOtp {
    length: 4
    pattern: "[0-9]"
}
