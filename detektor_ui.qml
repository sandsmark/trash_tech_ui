import QtQuick 2.6
import QtQuick.Window 2.2

Rectangle {
    id: canvas
    color: "black"
    anchors.fill: parent
    state: "ConsoleState"
    focus: true

    Repeater {
        model: 720
        Rectangle {
            z: 99999
            opacity: 0.4
            color: "black"
            width: canvas.width
            height: 1
            x: 0
            y: 2 * index
        }
    }

    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: "black"
        }
        GradientStop {
            position: 0.5
            color: "#434343"
        }
        GradientStop {
            position: 1.0
            color: "black"
        }
    }

    Keys.onEnterPressed: {
        if (canvas.state == "ConsoleState") {
            canvas.state = "LoadingState"
            event.accepted = true
        }
    }

    Keys.onPressed: {
        if (canvas.state == "ConsoleState") {
            event.accepted = true
            if (event.key === Qt.Key_Return) {
                canvas.state = "LoadingState"
            } else {
                consolescreen.addChar()
            }
        } else {
            if (event.key === Qt.Key_Space) {
                event.accepted = true
                if (canvas.state == "NotStartedState") {
                    canvas.state = "ConsoleState"
                } else if (canvas.state == "LoadingState") {
                    canvas.state = "BusyScreenState"
                } else if (canvas.state == "BusyScreenState") {
                    canvas.state = "DangerousBusyScreenState"
                } else if (canvas.state == "DangerousBusyScreenState") {
                    canvas.state = "BusyScreenState"
                }
            }
        }
    }

    states: [
        State {
            name: "NotStartedState"
            PropertyChanges {
                target: loadscreen
                state: "NotVisibleState"
            }
            PropertyChanges {
                target: consolescreen
                state: "NotVisibleState"
            }
        },
        State {
            name: "ConsoleState"
            PropertyChanges {
                target: consolescreen
                state: "VisibleState"
            }
        },
        State {
            name: "LoadingState"
            PropertyChanges {
                target: loadscreen
                state: "VisibleState"
            }
            PropertyChanges {
                target: consolescreen
                state: "NotVisibleState"
            }
            PropertyChanges {
                target: fancyUiElementsGrid
                x: -2000
            }
        },
        State {
            name: "BusyScreenState"
            PropertyChanges {
                target: consolescreen
                state: "NotVisibleState"
            }
            PropertyChanges {
                target: loadscreen
                state: "NotVisibleState"
            }
            PropertyChanges {
                target: consoletext
                state: "ActiveState"
            }
            PropertyChanges {
                target: bargraph
                state: "ActiveState"
            }
            PropertyChanges {
                target: statusScreen
                state: "ActiveState"
            }
            PropertyChanges {
                target: gaugeScreen
                state: "ActiveState"
            }
            PropertyChanges {
                target: fancyUiElementsGrid
                x: 50
            }
            PropertyChanges {
                target: smallDiagramText
                state: "NormalState"
            }
        },
        State {
            name: "DangerousBusyScreenState"
            PropertyChanges {
                target: consolescreen
                state: "NotVisibleState"
            }
            PropertyChanges {
                target: loadscreen
                state: "NotVisibleState"
            }
            PropertyChanges {
                target: consoletext
                state: "ActiveState"
            }
            PropertyChanges {
                target: bargraph
                state: "ActiveState"
            }
            PropertyChanges {
                target: statusScreen
                state: "ActiveState"
            }
            PropertyChanges {
                target: gaugeScreen
                state: "ActiveState"
            }
            PropertyChanges {
                target: fancyUiElementsGrid
                x: 50
            }
            PropertyChanges {
                target: smallDiagramText
                state: "JammingActivityState"
            }
        }
    ]

    FontLoader {
        id: fancyfont
        source: "Perfect Dark Zero.ttf"
    }

    Rectangle {
        id: consolescreen
        color: "transparent"
        x: 50
        property int displayedCharacters: 0
        property int blinkState: 0
        property string writeText: "/usr/bin/beamcontrol -ui -ra 35.1 -dec 217.4 -intensity 74.0"
        function refreshText() {
            var text = "  <small>»</small>  "
            var realText = ""
            if (displayedCharacters > writeText.length) {
                displayedCharacters = writeText.length
            }
            for (var i = 0; i < displayedCharacters; i++) {
                realText += writeText[i]
            }
            text += realText
            if (blinkState == 1) {
                text += "<span style=\"color: #95FF00\">|</span>"
            }
            consolescreen_text.text = "$" + text
        }
        function addChar() {
            displayedCharacters += 1
            refreshText()
        }
        function blink() {
            if (blinkState == 0) {
                blinkState = 1
            } else {
                blinkState = 0
            }
            refreshText()
        }
        SequentialAnimation {
            running: true
            loops: Animation.Infinite
            PropertyAnimation {
                duration: 400
            }
            ScriptAction {
                script: consolescreen.blink()
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 300
            }
        }
        Behavior on visible {
            PropertyAnimation {
                duration: 300
            }
        }
        states: [
            State {
                name: "NotVisibleState"
                PropertyChanges {
                    target: consolescreen
                    visible: false
                }
                PropertyChanges {
                    target: consolescreen
                    opacity: 0
                }
            },
            State {
                name: "VisibleState"
                PropertyChanges {
                    target: consolescreen
                    visible: true
                }
            }
        ]
        FancyText {
            id: consolescreen_text
            color: "#489C26"
            text: "$"
        }
    }

    Grid {
        id: fancyUiElementsGrid
        x: -2000
        y: 50
        columns: 2
        spacing: 50

        Behavior on x {
            NumberAnimation {
                duration: 300
            }
        }

        Rectangle {
            id: consoletext
            color: "transparent"
            width: canvas.width / 2 - 75
            height: canvas.height / 2 - 75
            state: "NotActiveState"
            clip: true
            states: [
                State {
                    name: "ActiveState"
                    PropertyChanges {
                        target: textappender
                        running: true
                    }
                    PropertyChanges {
                        target: consoletext
                        visible: true
                    }
                    PropertyChanges {
                        target: consoletext
                        opacity: 1
                    }
                },
                State {
                    name: "NotActiveState"
                    PropertyChanges {
                        target: consoletext
                        visible: false
                    }
                }
            ]
            SequentialAnimation {
                id: textappender
                loops: Animation.Infinite
                ScriptAction {
                    script: consoletext.maybeAppendOneLine()
                }
                PropertyAnimation {
                    duration: 50
                }
            }
            ListModel {
                id: consoletext_model
            }
            function maybeAppendOneLine() {
                if (Math.random() > 0.8) {
                    appendOneLine()
                }
            }
            function select(from) {
                var len = from.length
                return from[Math.floor(Math.random() * len)]
            }
            function trashtextGenerator() {
                var sentences = ["Trying to retrieve %n from sensors...", "Waiting for %n measurements...", "Calibrating %n detection unit...", "Received data: %n = %f", "Received data: %n = %f", "Received data: %n = %f", "%n detector has been successfully (re-)initialized."]
                var nouns = ["Flux density", "Antimatter density", "Dark energy", "Dark matter intensity", "Space-time coefficient", "Overflow", "Radiation data", "Temperature coefficient"]
                var sentence = select(sentences)
                sentence = sentence.replace("%n", select(nouns))
                sentence = sentence.replace("%f", Math.round(
                                                Math.random() * 20000) / 100)

                return sentence
            }
            function appendOneLine() {
                consoletext_model.append({
                                             display: trashtextGenerator()
                                         })
                consoletext_text.positionViewAtEnd()
            }
            ListView {
                id: consoletext_text
                anchors.fill: parent
                model: consoletext_model
                delegate: FancyText {
                    font.pointSize: 16
                    color: "#489C26"
                    text: display
                }
            }
        }

        BarGraph {
            id: bargraph
            width: canvas.width / 2 - 75
            height: canvas.height / 2 - 75
            color: "transparent"
            clip: true

            border {
                width: 1
                color: "#777777"
            }
            FancyText {
                id: diagramText
                font.pointSize: 32
                text: "Noise compensation = 74.0"
                x: 25
                y: -5
                SequentialAnimation {
                    running: true
                    loops: Animation.Infinite
                    NumberAnimation {
                        target: diagramText
                        property: "opacity"
                        to: 1.0
                        duration: 150
                    }
                    PropertyAnimation {
                        duration: 300
                    }
                    NumberAnimation {
                        target: diagramText
                        property: "opacity"
                        to: 0.0
                        duration: 150
                    }
                    PropertyAnimation {
                        duration: 100
                    }
                }
            }
            Behavior on x {
                NumberAnimation {
                    duration: 1000
                }
            }
            SequentialAnimation {
                id: graphScroller
                loops: Animation.Infinite
                ScriptAction {
                    script: bargraph.newDataValue()
                }
                PropertyAnimation {
                    duration: 60
                }
            }
        }

        Rectangle {
            id: statusScreen
            color: "transparent"
            width: canvas.width / 2 - 75
            height: canvas.height / 2 - 75
            state: "NotActiveState"
            states: [
                State {
                    name: "ActiveState"
                    PropertyChanges {
                        target: statusScreen
                        visible: true
                    }
                    StateChangeScript {
                        script: graphScroller.running = true
                    }
                },
                State {
                    name: "NotActiveState"
                    PropertyChanges {
                        target: statusScreen
                        visible: false
                    }
                }
            ]

            Grid {
                columns: 2
                spacing: 0
                FancyText {
                    id: fancyText
                    text: "Beam status:"
                }

                FancyText {
                    color: "#80D600"
                    text: "ACTIVE"
                    horizontalAlignment: Text.AlignRight
                }

                FancyText {
                    text: "Cooling system:"
                }
                FancyText {
                    color: "#80D600"
                    text: "ONLINE"
                    horizontalAlignment: Text.AlignRight
                }

                FancyText {
                    text: "Alignment:"
                }
                FancyText {
                    color: "#D6C100"
                    text: "RA: 35.1     DEC: 217.4"
                    horizontalAlignment: Text.AlignRight
                }

                FancyText {
                    text: "Detector Gain:"
                }
                FancyText {
                    color: "#80D600"
                    text: "87.4 dB"
                    horizontalAlignment: Text.AlignRight
                }

                FancyText {
                    color: "white"
                    text: "Emergency recovery system:"
                }
                FancyText {
                    color: "#FF2C2C"
                    font.family: fancyfont.name
                    text: "OFF"
                    horizontalAlignment: Text.AlignRight
                }

                FancyText {
                    color: "white"
                    font.family: fancyfont.name
                    text: "Network connection:"
                }
                FancyText {
                    color: "#80D600"
                    text: "OK"
                    horizontalAlignment: Text.AlignRight
                }

                FancyText {
                    text: "Security system:"
                }
                FancyText {
                    color: canvas.state == "DangerousBusyScreenState" ? "#FF2C2C" : "#80D600"
                    text: canvas.state == "DangerousBusyScreenState" ? "JAMMED" : "ONLINE"
                    horizontalAlignment: Text.AlignRight
                }
            }
        }
        Rectangle {
            id: gaugeScreen
            color: "transparent"
            width: canvas.width / 2 - 75
            height: canvas.height / 2 - 75
            state: "NotActiveState"
            states: [
                State {
                    name: "ActiveState"
                    PropertyChanges {
                        target: gaugeScreen
                        visible: true
                    }
                    StateChangeScript {
                        script: graphScroller.running = true
                    }
                },
                State {
                    name: "NotActiveState"
                    PropertyChanges {
                        target: gaugeScreen
                        visible: false
                    }
                }
            ]

            Grid {
                columns: 1
                Grid {
                    id: rightBottomGrid
                    columns: 4
                    spacing: 50
                    function alterBarValue(bar, defaultValue) {
                        if (bar.value > defaultValue + 10) {
                            bar.value -= 4
                        }
                        if (bar.value < defaultValue - 10) {
                            bar.value += 4
                        }
                        bar.value += Math.random() * 2 - 1
                    }
                    GaugeDisplay {
                        id: temperatureBar
                        height: 200
                        value: 25
                        label: "Temperature"
                        SequentialAnimation {
                            running: true
                            loops: Animation.Infinite
                            ScriptAction {
                                script: rightBottomGrid.alterBarValue(
                                            temperatureBar, 25)
                            }
                            PropertyAnimation {
                                duration: 100
                            }
                        }
                    }
                    GaugeDisplay {
                        id: randomBar
                        height: 200
                        value: 70
                        label: "X05-20"
                        SequentialAnimation {
                            running: true
                            loops: Animation.Infinite
                            ScriptAction {
                                script: rightBottomGrid.alterBarValue(
                                            randomBar, 70)
                            }
                            PropertyAnimation {
                                duration: 100
                            }
                        }
                    }
                    GaugeDisplay {
                        id: intensityBar
                        height: 200
                        value: 56
                        label: "Intensity"
                        SequentialAnimation {
                            running: true
                            loops: Animation.Infinite
                            ScriptAction {
                                script: rightBottomGrid.alterBarValue(
                                            intensityBar, 56)
                            }
                            PropertyAnimation {
                                duration: 100
                            }
                        }
                    }

                    BarGraph {
                        id: smallgraph
                        width: 425
                        height: 200
                        color: "transparent"

                        Component.onCompleted: {
                            for (var i = 0; i < Math.max(200, smallgraph.valueModel.count); i++) {
                                smallgraph.valueModel.append({
                                                                 yvalue: 20 + Math.random(
                                                                             ) * 4 - 2,
                                                                 first_color: "#3B5100",
                                                                 second_color: "#77A200"
                                                             })
                            }
                        }

                        function doAddDefaultData() {
                            for (var i = 0; i < smallgraph.valueModel.count; i++) {
                                var currData = smallgraph.valueModel.get(i)
                                currData.yvalue =  20 + Math.random() * 4 - 2
                                currData.first_color = "#3B5100"
                                currData.second_color = "#77A200"
                            }
                        }

                        function doAddJammingData() {
                            var jammingSequenceData = [2, 3, 5, 10, 20, 40, 90, 140, 200, 270, 0, 0, 0, 0, 1, 10, 20, 40, 60, 80, 60, 40, 20, 10, 1, 0, 0, 0]

                            for (var i = 0; i < jammingSequenceData.length * 4; i++) {
                                var currData = smallgraph.valueModel.get(i)
                                currData.yvalue =  jammingSequenceData[Math.floor(i / 4)] / 2.5
                                currData.first_color = "#FF1717"
                                currData.second_color = "#7A0B0B"
                            }
                        }

                        FancyText {
                            id: smallDiagramText
                            antialiasing: false
                            states: [
                                State {
                                    name: "NormalState"
                                    PropertyChanges {
                                        target: smallDiagramText
                                        text: "No abnormal activity detected."
                                    }
                                    PropertyChanges {
                                        target: smallDiagramText
                                        color: "white"
                                    }
                                    PropertyChanges {
                                        target: smallDiagramText
                                        x: 20
                                    }
                                    PropertyChanges {
                                        target: smallDiagramTextBlink
                                        running: false
                                    }
                                    PropertyChanges {
                                        target: smallDiagramText
                                        opacity: 1
                                    }
                                    StateChangeScript {
                                        script: smallgraph.doAddDefaultData()
                                    }
                                },
                                State {
                                    name: "JammingActivityState"
                                    PropertyChanges {
                                        target: smallDiagramText
                                        text: "JAMMING DETECTED"
                                    }
                                    PropertyChanges {
                                        target: smallDiagramText
                                        color: "#FF2C2C"
                                    }
                                    PropertyChanges {
                                        target: smallDiagramText
                                        x: 60
                                    }
                                    PropertyChanges {
                                        target: smallDiagramTextBlink
                                        running: true
                                    }
                                    StateChangeScript {
                                        script: smallgraph.doAddJammingData()
                                    }
                                }
                            ]
                            x: 20
                            y: 20
                            SequentialAnimation {
                                id: smallDiagramTextBlink
                                running: false
                                loops: Animation.Infinite
                                NumberAnimation {
                                    target: smallDiagramText
                                    property: "opacity"
                                    to: 1.0
                                    duration: 20
                                }
                                PropertyAnimation {
                                    duration: 300
                                }
                                NumberAnimation {
                                    target: smallDiagramText
                                    property: "opacity"
                                    to: 0.0
                                    duration: 20
                                }
                                PropertyAnimation {
                                    duration: 300
                                }
                            }
                        }
                    }
                }
                Rectangle {
                    color: "transparent"
                    id: particleCanvas
                    width: 600
                    height: 175
                    Rectangle {
                        anchors.centerIn: parent
                        FancyText {
                            id: beam_status_text
                            text: "Beam Status: <span style=\"color:yellow\">ADJUSTING...</span>"
                        }
                    }
                    Rectangle {
                        id: crosshair
                        x: 30
                        y: 20
                        Rectangle {
                            id: ray
                            border {
                                width: 1
                                color: "black"
                            }
                            x: 50
                            y: 50
                            z: 100
                            color: "#FF2600"
                            width: 12
                            height: 12
                            radius: 6
                            Behavior on x {
                                NumberAnimation {
                                    duration: 300
                                }
                            }
                            Behavior on y {
                                NumberAnimation {
                                    duration: 300
                                }
                            }
                            function jiggle() {
                                var drift_x = 0
                                var drift_y = 0
                                if (ray.x > 110) {
                                    drift_x -= 9
                                }
                                if (ray.y > 110) {
                                    drift_y -= 9
                                }
                                if (ray.x < 20) {
                                    drift_x += 9
                                }
                                if (ray.y < 20) {
                                    drift_y += 9
                                }

                                // drift towards the center
                                drift_x += (65 - ray.x) * 0.2
                                drift_y += (85 - ray.y) * 0.2

                                drift_x += Math.random() * 36 - 18
                                drift_y += Math.random() * 36 - 18

                                ray.x += drift_x
                                ray.y += drift_y

                                function sqr(x) {
                                    return x * x
                                }
                                var d = Math.sqrt(sqr(ray.x - 65,
                                                      2) + sqr(ray.y - 85))
                                if (d > 65) {
                                    large_circle.color = "#333333"
                                    smaller_circle.color = "#333333"
                                    beam_status_text.text = "Beam Alignment: <span style=\"color:red\">CRITICAL</span>"
                                } else if (d <= 65 && d > 35) {
                                    large_circle.color = "#CFA600"
                                    smaller_circle.color = "#333333"
                                    beam_status_text.text = "Beam Alignment: <span style=\"color:yellow\">ADJUSTING...</span>"
                                } else {
                                    large_circle.color = "#333333"
                                    smaller_circle.color = "#469200"
                                    beam_status_text.text = "Beam Alignment: <span style=\"color:green\">LOCKED</span>"
                                }
                            }
                            function emitWave() {
                                var comp = Qt.createComponent("RayWave.qml")
                                var sprite = comp.createObject(crosshair, {
                                                                   size: 10,
                                                                   xzero: ray.x + 6,
                                                                   yzero: ray.y + 6
                                                               })
                            }

                            SequentialAnimation {
                                running: true
                                loops: Animation.Infinite
                                ScriptAction {
                                    script: ray.jiggle()
                                }
                                PropertyAnimation {
                                    duration: 300
                                }
                            }
                            SequentialAnimation {
                                running: true
                                loops: Animation.Infinite
                                ScriptAction {
                                    script: ray.emitWave()
                                }
                                PropertyAnimation {
                                    duration: 500
                                }
                            }
                        }
                        Rectangle {
                            z: 10
                            y: 10
                            width: 1
                            height: 150
                            color: "white"
                            x: 65
                        }
                        Rectangle {
                            z: 10
                            y: 85
                            x: -10
                            height: 1
                            width: 150
                            color: "white"
                        }
                        Rectangle {
                            x: 0
                            y: 20
                            color: "transparent"
                            id: large_circle
                            width: 130
                            height: 130
                            radius: 65
                            border {
                                width: 1
                                color: "white"
                            }
                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }
                        }
                        Rectangle {
                            x: 30
                            y: 50
                            color: "transparent"
                            id: smaller_circle
                            width: 70
                            height: 70
                            radius: 35
                            border {
                                width: 1
                                color: "white"
                            }
                            Behavior on color {
                                ColorAnimation {
                                    duration: 200
                                }
                            }
                        }
                        Rectangle {
                            x: 62
                            y: 82
                            color: "transparent"
                            width: 6
                            height: 6
                            radius: 3
                            border {
                                width: 1
                                color: "white"
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: loadscreen
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: 400
        height: 40

        FancyText {
            id: loadscreenText
            z: 200
            font.pointSize: 22
            anchors {
                centerIn: parent
                verticalCenterOffset: -5
            }

//            anchors.centerIn: parent
//            anchors.horizontalCenter: parent.horizontalCenter
//            y: -11
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

            Timer {
                id: barAnimTimer
                repeat: false
                onTriggered: {
                    var maxWidth = loadscreen.width - loadscreen.border.width
                    if (bar.width >= maxWidth) {
                        initFinishedAnimation.running = true
                        return
                    }

                    var newWidth = (bar.width + Math.random() * 20 + 1)
                    bar.width = Math.min(newWidth, maxWidth)
                    barAnimTimer.interval = Math.random() * 100 + 10
                    barAnimTimer.start()
                }
            }

            SequentialAnimation {
                id: initFinishedAnimation
                running: false

                PropertyAnimation {
                    target: loadscreenText
                    property: "text"
                    to: "Done."
                    duration: 0
                }
                PropertyAnimation {
                    duration: 500
                }
                ParallelAnimation {
                    NumberAnimation {
                        target: bar
                        property: "opacity"
                        to: 0
                        duration: 200
                    }
                    NumberAnimation {
                        target: loadscreen
                        property: "opacity"
                        to: 0
                        duration: 200
                    }
                }
                PropertyAnimation {
                    target: canvas
                    property: "state"
                    to: "BusyScreenState"
                    duration: 0
                }
            }
        }
        border.color: "black"
        border.width: 2
        color: "black"
        state: "NotVisibleState"
        states: [
            State {
                name: "NotVisibleState"
                PropertyChanges {
                    target: loadscreen
                    visible: false
                }
            },
            State {
                name: "VisibleState"
                PropertyChanges {
                    target: loadscreen
                    visible: true
                }
                PropertyChanges {
                    target: loadscreen
                    opacity: 1
                }
                PropertyChanges {
                    target: barAnimTimer
                    running: true
                }
            }
        ]
        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }
    }
}
