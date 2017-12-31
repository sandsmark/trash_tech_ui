import QtQuick 2.6

Rectangle {
    id: bargraph

    state: "NotActiveState"
    property int lastValue: 100
    property int isInJammingSequence: 0

    property alias valueModel: diagramEntries

    function newDataValue() {
        barListView.positionViewAtEnd()
        if (canvas.state == "DangerousBusyScreenState"
                && isInJammingSequence == 0) {
            if (Math.random() < 0.1) {
                isInJammingSequence = 1
            }
        }
        if (isInJammingSequence > 0) {
            var jammingSequenceData = [2, 3, 5, 10, 20, 40, 90, 140, 200, 270, 0, 0, 0, 0, 1, 10, 20, 40, 60, 80, 60, 40, 20, 10, 1, 0, 0, 0]
            if (isInJammingSequence >= jammingSequenceData.length) {
                isInJammingSequence = 0
            } else {
                isInJammingSequence += 1
            }
            diagramEntries.append({
                               yvalue: jammingSequenceData[isInJammingSequence],
                               first_color: "#FF1717",
                               second_color: "#7A0B0B"
                           })
        } else {
            // default behaviour
            lastValue = lastValue + Math.random() * 70 - 35
            if (lastValue < 200) {
                lastValue += Math.random() * 5
            }
            if (lastValue > 200) {
                lastValue -= Math.random() * 5
            }

            if (lastValue < 50) {
                lastValue += 10
            } else if (lastValue > 350) {
                lastValue -= 10
            } else if (Math.random() < 0.02) {
                lastValue += Math.random() * 200 - 100
            }
            diagramEntries.append({
                               yvalue: lastValue,
                               first_color: "#3B5100",
                               second_color: "#77A200"
                           })
        }
    }

    ListModel {
        id: diagramEntries
    }

    ListView {
        id: barListView
        anchors.fill: parent
        model: diagramEntries
        spacing: 2
        orientation: ListView.Horizontal
        delegate: Rectangle {
            height: yvalue
            y: bargraph.height - yvalue
            width: 2
            opacity: 0.6

            property int animDuration: Math.random() * 500
            Behavior on y {
                NumberAnimation {
                    duration: animDuration
                }
            }
            Behavior on height {
                NumberAnimation {
                    duration: animDuration
                }
            }

            gradient: Gradient {
                GradientStop {
                    position: 1.0
                    color: first_color
                }
                GradientStop {
                    position: 0.0
                    color: second_color
                }
            }
            Rectangle {
                color: "white"
                width: 2
                height: 2
            }
        }
    }
    states: [
        State {
            name: "ActiveState"
            StateChangeScript {
                script: graphScroller.running = true
            }
        },
        State {
            name: "NotActiveState"
        }
    ]
}
