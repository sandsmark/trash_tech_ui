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
            PropertyChanges { target: fancyUiElementsGrid; x: -2000 }
        },
        State {
            name: "BusyScreenState"
            PropertyChanges { target: loadscreen; state: "NotVisibleState" }
            PropertyChanges { target: consoletext; state: "ActiveState" }
            PropertyChanges { target: bargraph; state: "ActiveState" }
            PropertyChanges { target: statusScreen; state: "ActiveState" }
            PropertyChanges { target: gaugeScreen; state: "ActiveState" }
            PropertyChanges { target: fancyUiElementsGrid; x: 50 }
        },
        State {
            name: "DangerousBusyScreenState"
            PropertyChanges { target: messagebox; visible: false }
        }
    ]
    
    FontLoader { id: fancyfont; source: "/usr/share/fonts/TTF/Perfect Dark Zero.ttf" }
    
    Grid {
        id: fancyUiElementsGrid
        x: -2000
        y: 50
        columns: 2
        spacing: 50
        
        Behavior on x {
            NumberAnimation { duration: 300 }
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
                ScriptAction { script: consoletext.maybeAppendOneLine(); }
                PropertyAnimation { duration: 50 }
            }
            ListModel {
                id: consoletext_model
            }
            function maybeAppendOneLine() {
                if ( Math.random() > 0.8 ) {
                    appendOneLine();
                }
            }
            function select(from) {
                var len = from.length;
                return from[Math.floor(Math.random() * len)];
            }
            function trashtextGenerator() {
                var sentences = new Array(
                    "Trying to retrieve %n from sensors...",
                    "Waiting for %n measurements...",
                    "Calibrating %n detection unit...",
                    "Received data: %n = %f",
                    "Received data: %n = %f",
                    "Received data: %n = %f",
                    "%n detector has been successfully (re-)initialized."
                );
                var nouns = new Array(
                    "Flux density",
                    "Antimatter density",
                    "Dark energy",
                    "Dark matter density",
                    "Space-time coefficient",
                    "Overflow",
                    "Radiation data",
                    "Temperature coefficient"
                );
                var sentence = select(sentences);
                sentence = sentence.replace("%n", select(nouns));
                sentence = sentence.replace("%f", Math.round(Math.random() * 20000) / 100);
                
                return sentence;
            }
            function appendOneLine() {
                consoletext_model.append({ display: trashtextGenerator() });
                consoletext_text.positionViewAtEnd();
            }
            ListView {
                id: consoletext_text
                anchors.fill: parent
                model: consoletext_model
                delegate: Text {
                    font.pointSize: 16
                    font.family: fancyfont.name
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
            property int lastValue: 100
            state: "NotActiveState"
            border {
                width: 1
                color: "#777777"
            }
            Text {
                id: diagramText
                font.pointSize: 32
                font.family: fancyfont.name
                text: "Beam Intensity = 74.0 MJy"
                color: "white"
                x: 25
                y: -5
                SequentialAnimation {
                    running: true;
                    loops: Animation.Infinite;
                    NumberAnimation { target: diagramText; property: "opacity"; to: 1.0; duration: 150 }
                    PropertyAnimation { duration: 300 }
                    NumberAnimation { target: diagramText; property: "opacity"; to: 0.0; duration: 150 }
                    PropertyAnimation { duration: 100 }
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
            Behavior on x {
                NumberAnimation { duration: 1000 }
            }
            SequentialAnimation {
                id: "graphScroller"
                loops: Animation.Infinite
                ScriptAction { script: bargraph.newDataValue(); }
                PropertyAnimation { duration: 60 }
            }
            function newDataValue() {
                data[1].positionViewAtEnd();
                lastValue = lastValue + Math.random() * 70 - 35
                if ( lastValue < 200 ) {
                    lastValue += Math.random() * 5
                }
                if ( lastValue > 200 ) {
                    lastValue -= Math.random() * 5
                }
                
                if ( lastValue < 50 ) {
                    lastValue += 10
                }
                else if ( lastValue > 350 ) {
                    lastValue -= 10
                }
                else if ( Math.random() < 0.02 ) {
                    lastValue += Math.random() * 200 - 100
                }
                data[0].append({ yvalue: lastValue })
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
                    PropertyChanges { target: statusScreen; visible: true }
                    StateChangeScript {
                        script: graphScroller.running = true
                    }
                },
                State {
                    name: "NotActiveState"
                    PropertyChanges { target: statusScreen; visible: false }
                }
            ]
            Grid {
                columns: 2
                spacing: 0
                Text {
                    color: "white"
                    font.family: fancyfont.name
                    font.pointSize: 28
                    text: "Beam status:"
                }
                Text {
                    anchors.right: parent.right
                    color: "#80D600"
                    font.family: fancyfont.name
                    font.pointSize: 28
                    text: "ACTIVE"
                    horizontalAlignment: Text.AlignRight
                }
                
                Text {
                    color: "white"
                    font.family: fancyfont.name
                    font.pointSize: 28
                    text: "Cooling system:"
                }
                Text {
                    anchors.right: parent.right
                    color: "#80D600"
                    font.family: fancyfont.name
                    font.pointSize: 28
                    text: "ONLINE"
                    horizontalAlignment: Text.AlignRight
                }
                
                Text {
                    color: "white"
                    font.family: fancyfont.name
                    font.pointSize: 28
                    text: "Alignment:"
                }
                Text {
                    anchors.right: parent.right
                    color: "#D6C100"
                    font.family: fancyfont.name
                    font.pointSize: 28
                    text: "RA: 35.1     DEC: 217.4"
                    horizontalAlignment: Text.AlignRight
                }
                
                Text {
                    color: "white"
                    font.family: fancyfont.name
                    font.pointSize: 28
                    text: "Detector Gain:"
                }
                Text {
                    anchors.right: parent.right
                    color: "#80D600"
                    font.family: fancyfont.name
                    font.pointSize: 28
                    text: "87.4 dB"
                    horizontalAlignment: Text.AlignRight
                }
                
                Text {
                    color: "white"
                    font.family: fancyfont.name
                    font.pointSize: 28
                    text: "Emergency recovery system:"
                }
                Text {
                    anchors.right: parent.right
                    color: "#FF2C2C"
                    font.family: fancyfont.name
                    font.pointSize: 28
                    text: "OFF"
                    horizontalAlignment: Text.AlignRight
                }
                
                Text {
                    color: "white"
                    font.family: fancyfont.name
                    font.pointSize: 28
                    text: "Network connection:"
                }
                Text {
                    anchors.right: parent.right
                    color: "#80D600"
                    font.family: fancyfont.name
                    font.pointSize: 28
                    text: "OK"
                    horizontalAlignment: Text.AlignRight
                }
                
                Text {
                    color: "white"
                    font.family: fancyfont.name
                    font.pointSize: 28
                    text: "Security system:"
                }
                Text {
                    anchors.right: parent.right
                    color: "#80D600"
                    font.family: fancyfont.name
                    font.pointSize: 28
                    text: "ONLINE"
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
                    PropertyChanges { target: gaugeScreen; visible: true }
                    StateChangeScript {
                        script: graphScroller.running = true
                    }
                },
                State {
                    name: "NotActiveState"
                    PropertyChanges { target: gaugeScreen; visible: false }
                }
            ]
            
            Grid {
                columns: 1
                Grid {
                    id: rightBottomGrid
                    columns: 4
                    spacing: 50
                    function alterBarValue(bar, defaultValue) {
                        if ( bar.value > defaultValue + 10 ) {
                            bar.value -= 4;
                        }
                        if ( bar.value < defaultValue - 10 ) {
                            bar.value += 4;
                        }
                        bar.value += Math.random()*2 - 1
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
                                script: rightBottomGrid.alterBarValue(temperatureBar, 25)
                            }
                            PropertyAnimation { duration: 100 }
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
                                script: rightBottomGrid.alterBarValue(randomBar, 70)
                            }
                            PropertyAnimation { duration: 100 }
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
                                script: rightBottomGrid.alterBarValue(intensityBar, 56)
                            }
                            PropertyAnimation { duration: 100 }
                        }
                    }
                    BarGraph {
                        id: smallgraph
                        width: 425
                        height: 200
                        color: "transparent"
                        SequentialAnimation {
                            loops: Animation.Infinite
                            running: true
                            ScriptAction {
                                script: smallgraph.data[0].append({ yvalue: 20 + Math.random()*4-2 })
                            }
                            PropertyAnimation { duration: 10 }
                        }
                        Text {
                            id: smallDiagramText
                            font.pointSize: 28
                            font.family: fancyfont.name
                            text: "No abnormal activity detected."
                            color: "white"
                            x: 20
                            y: 20
                            SequentialAnimation {
                                running: false;
                                loops: Animation.Infinite;
                                NumberAnimation { target: diagramText; property: "opacity"; to: 1.0; duration: 150 }
                                PropertyAnimation { duration: 300 }
                                NumberAnimation { target: diagramText; property: "opacity"; to: 0.0; duration: 150 }
                                PropertyAnimation { duration: 100 }
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
                        id: crosshair
                        x: 30
                        y: 20
                        Rectangle {
                            id: ray
                            x: 50
                            y: 50
                            z: 10
                            color: "#FF2600"
                            width: 8
                            height: 8
                            radius: 4
                            Behavior on x {
                                NumberAnimation { duration: 100 }
                            }
                            Behavior on y {
                                NumberAnimation { duration: 100 }
                            }
                            function jiggle() {
                                ray.x += Math.random() * 8 - 4
                                ray.y += Math.random() * 8 - 4
                                if ( ray.x > 110 ) {
                                    ray.x -= 3
                                }
                                if ( ray.y > 110 ) {
                                    ray.y -= 3
                                }
                                if ( ray.x < 20 ) {
                                    ray.x += 3
                                }
                                if ( ray.y < 20 ) {
                                    ray.y += 3
                                }
                                var d = Math.sqrt(ray.x*ray.x + ray.y*ray.y);
                                if ( d )
                            }
                            function emitWave() {
                                var comp = Qt.createComponent("RayWave.qml");
                                var sprite = comp.createObject(crosshair, {
                                    "size": 10,
                                    "xzero": ray.x + 3,
                                    "yzero": ray.y + 3
                                });
                            }
                            SequentialAnimation {
                                running: true
                                loops: Animation.Infinite
                                ScriptAction { script: ray.jiggle() }
                                PropertyAnimation { duration: 100 }
                            }
                            SequentialAnimation {
                                running: true
                                loops: Animation.Infinite
                                ScriptAction { script: ray.emitWave() }
                                PropertyAnimation { duration: 500 }
                            }
                        }
                        Rectangle {
                            y: 10
                            width: 1
                            height: 150
                            color: "white"
                            x: 65
                        }
                        Rectangle {
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
                            width: 130
                            height: 130
                            radius: 65
                            border {
                                width: 1
                                color: "white"
                            }
                        }
                        Rectangle {
                            x: 30
                            y: 50
                            color: "transparent"
                            width: 70
                            height: 70
                            radius: 35
                            border {
                                width: 1
                                color: "white"
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
        height: 30
        Text {
            id: loadscreenText
            z: 200
            font {
                pointSize: 22
                family: fancyfont.name
            }
            anchors.horizontalCenter: parent.horizontalCenter
//             anchors.verticalCenter: parent.verticalCenter
            y: -11
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