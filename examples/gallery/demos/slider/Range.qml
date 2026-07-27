import QtQuick
import Shadcn

// defaultValue={[25, 50]} max={100} step={5} className="w-full max-w-xs"
// Two-thumb range: first/second thumbs, middle segment highlighted.
RangeSlider {
    width: 320                  // max-w-xs
    from: 0
    to: 100
    stepSize: 5
    first.value: 25
    second.value: 50
}
