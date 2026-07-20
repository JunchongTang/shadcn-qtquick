import QtQuick
import Shadcn

Progress {
    width: 320
    value: 13
    // 加载后推进到 66%(对标官方 demo 的定时器)
    Component.onCompleted: tick.start()
    Timer { id: tick; interval: 500; onTriggered: parent.value = 66 }
}
