import QtQuick
import QtQuick.Layouts
import Shadcn

RowLayout {
    spacing: 8

    Badge {
        id: deleting
        text: "Deleting"
        variant: Badge.Destructive
        leading: Spinner { size: 10; color: deleting.fgColor }
    }
    Badge {
        id: generating
        text: "Generating"
        variant: Badge.Secondary
        trailing: Spinner { size: 10; color: generating.fgColor }
    }
}
