import QtQuick 2.6

Rectangle {
    z: 1000
    id: wave
    property int size: 0
    property int xzero: 0
    property int yzero: 0
    x: xzero - size / 2
    y: yzero - size / 2
    width: size
    height: size
    radius: size / 2
    color: "transparent"
    border.width: 3
    border.color: "red"
    ParallelAnimation {
        running: true
        NumberAnimation {
            target: wave
            property: "size"
            to: 170
            duration: 900
        }
        NumberAnimation {
            target: wave
            property: "opacity"
            to: 0
            duration: 900
        }
    }
}
