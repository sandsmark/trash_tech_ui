import QtQuick 1.1

Rectangle {
    id: wave
    property int size: 0
    property int xzero: 0
    property int yzero: 0
    x: xzero - size/2
    y: yzero - size/2
    width: size
    height: size
    radius: size/2
    color: "transparent"
    border.width: 2
    border.color: "red"
    ParallelAnimation {
        running: true
        NumberAnimation { target: wave; property: "size"; to: 120; duration: 700 }
        NumberAnimation { target: wave; property: "opacity"; to: 0; duration: 700 }
    }
}