import QtQuick 1.1
import Qt 4.7

Rectangle {
    id: canvas
    color: "black"
    width: 1440
    height: 900
    state: "NotStartedState"
    focus: true
    
    Repeater {
        model: 720
        Rectangle {
            z: 99999
            opacity: 0.4
            color: "black"
            width: 1440
            height: 1
            x: 0
            y: 2*index
        }
    }
    
    gradient: Gradient {
         GradientStop { position: 0.0; color: "black" }
         GradientStop { position: 0.5; color: "#535353" }
         GradientStop { position: 1.0; color: "black" }
    }
    
    Keys.onPressed: {
        event.accepted = true;
        if ( canvas.state == "NotStartedState" ) {
            canvas.state = "LoadingState";
        }
    }
    
    states: [
        State {
            name: "NotStartedState"
            PropertyChanges { target: loadscreen; state: "NotVisibleState" }
        },
        State {
            name: "LoadingState"
            PropertyChanges { target: loadscreen; state: "VisibleState" }
            StateChangeScript {
                name: "run_loadscreen"
                script: {
                }
            }
        },
        State {
            name: "BusyScreenState"
            PropertyChanges { target: loadscreen; state: "NotVisibleState" }
        },
        State {
            name: "DangerousBusyScreenState"
            PropertyChanges { target: messagebox; visible: false }
        }
    ]
    
    Rectangle {
        id: loadscreen
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: 400
        height: 30
        Text {
            id: loadscreenText
            z: 200
            font {
                pointSize: 10
                family: "monospace"
            }
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: "Initializing..."
        }
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            Repeater {
                y: -100
                model: 4
                Rectangle {
                    color: "white"
                    width: 8
                    height: 8
                    x: (index * 16) % 32 - 16
                    y: Math.floor(index / 2) * 16 - 100
                }
            }
        }
        Rectangle {
            id: bar
            x: 1
            y: 1
            width: 0
            height: parent.height - 2
            color: "#489C26"
            SequentialAnimation {
                id: run_bar
                running: false
                NumberAnimation { target: bar; property: "width"; to: loadscreen.width - loadscreen.border.width; duration: 2000 }
                PropertyAnimation { target: loadscreenText; property: "text"; to: "Done."; duration: 0 }
                PropertyAnimation { duration: 500 }
                ParallelAnimation {
                    NumberAnimation { target: bar; property: "opacity"; to: 0; duration: 200 }
                    NumberAnimation { target: loadscreen; property: "opacity"; to: 0; duration: 200 }
                }
            }
        }
        border.color: "#3A5539"
        border.width: 2
        color: "black"
        state: "NotVisibleState"
        states: [
            State {
                name: "NotVisibleState"
                PropertyChanges { target: loadscreen; visible: false }
            },
            State {
                name: "VisibleState"
                PropertyChanges { target: loadscreen; visible: true }
                PropertyChanges { target: loadscreen; opacity: 1 }
                PropertyChanges { target: run_bar; running: true }
            }
        ]
        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }
}