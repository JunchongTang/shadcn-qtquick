import QtQuick
import QtQuick.Layouts
import Shadcn

// Official spinner-size: adjust dimensions via size (size-3 / size-4 default / size-6 / size-8).
RowLayout {
    spacing: Theme.space6                 // gap-6

    Spinner { size: 12 }                  // sm  · size-3
    Spinner { size: 16 }                  // default · size-4
    Spinner { size: 24 }                  // lg  · size-6
    Spinner { size: 32 }                  // size-8
}
