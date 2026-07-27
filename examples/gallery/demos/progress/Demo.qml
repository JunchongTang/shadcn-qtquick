import QtQuick
import Shadcn

Progress {
    width: 320
    value: 13
    // Advance to 66% after load (mirrors the Official demo's timer)
    Component.onCompleted: tick.start()
    Timer { id: tick; interval: 500; onTriggered: parent.value = 66 }
}
