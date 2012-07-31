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
         GradientStop { position: 0.5; color: "#434343" }
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
        },
        State {
            name: "BusyScreenState"
            PropertyChanges { target: loadscreen; state: "NotVisibleState" }
            PropertyChanges { target: consoletext; state: "ActiveState" }
        },
        State {
            name: "DangerousBusyScreenState"
            PropertyChanges { target: messagebox; visible: false }
        }
    ]
    
    Rectangle {
        id: consoletext
        color: "transparent"
        x: 50
        y: 50
        width: canvas.width / 2 - 50
        height: canvas.height / 2 - 50
        state: "NotActiveState"
        clip: true
        states: [
            State {
                name: "ActiveState"
                PropertyChanges { target: textappender; running: true }
                PropertyChanges { target: consoletext; visible: true }
                PropertyChanges { target: consoletext; opacity: 1 }
            },
            State {
                name: "NotActiveState"
                PropertyChanges { target: consoletext; visible: false }
            }
        ]
        SequentialAnimation {
            id: "textappender"
            loops: Animation.Infinite
            ScriptAction { script: consoletext.appendOneLine(); }
            PropertyAnimation { duration: 100 }
        }
        ListModel {
            id: consoletext_model
            ListElement {
                display: "Foobar"
            }
            ListElement {
                display: "Foobar"
            }
            ListElement {
                display: "Foobar"
            }
        }
        function appendOneLine() {
            consoletext_model.append({ display: "new text" });
            consoletext_text.positionViewAtEnd();
        }
        ListView {
            id: consoletext_text
            anchors.fill: parent
            model: consoletext_model
            delegate: Text {
                color: "#489C26"
                text: display
            }
        }
    }
    
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
                PropertyAnimation { target: canvas; property: "state"; to: "BusyScreenState"; duration: 0 }
            }
        }
        border.color: "black"
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