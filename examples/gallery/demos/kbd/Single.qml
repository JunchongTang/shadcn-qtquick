import QtQuick
import QtQuick.Layouts
import Shadcn

// 单键:每个 Kbd 独立显示一个按键(修饰符号 / Enter / Esc / 方向键)。
RowLayout {
    spacing: Theme.space2

    Kbd { text: "⌘" }
    Kbd { text: "⇧" }
    Kbd { text: "⏎" }        // Enter
    Kbd { text: "Esc" }
    Kbd { text: "↑" }
}
