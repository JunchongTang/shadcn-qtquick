import QtQuick
import Shadcn

// defaultValue={[50]} max={100} step={1} disabled className="w-full max-w-xs"
Slider {
    width: 320                  // max-w-xs
    from: 0
    to: 100
    value: 50
    stepSize: 1
    enabled: false
}
