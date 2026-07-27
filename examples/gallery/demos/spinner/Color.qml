import QtQuick
import QtQuick.Layouts
import Shadcn

// Official spinner-color: override the spinner icon color via color.
// These are demo-only custom colors (Tailwind 500 shade literals), not design tokens, so hex is given directly.
RowLayout {
    spacing: Theme.space6                 // gap-6

    Spinner { size: 24; color: "#ef4444" }   // red-500
    Spinner { size: 24; color: "#22c55e" }   // green-500
    Spinner { size: 24; color: "#3b82f6" }   // blue-500
    Spinner { size: 24; color: "#eab308" }   // yellow-500
    Spinner { size: 24; color: "#a855f7" }   // purple-500
}
