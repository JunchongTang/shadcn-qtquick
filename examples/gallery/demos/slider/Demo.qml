import QtQuick
import Shadcn

// defaultValue={[75]} max={100} step={1} className="w-full max-w-xs"
Slider {
    width: 320                  // max-w-xs
    from: 0
    to: 100
    value: 75
    stepSize: 1
}
