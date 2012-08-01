import QtQuick 1.1

Rectangle {
    id: canvas
    ListModel {
        id: diagramEntries
    }
    ListView {
        anchors.fill: parent
        model: diagramEntries
        spacing: 2
        orientation: ListView.Horizontal
        delegate: Rectangle {
            height: yvalue
            y: canvas.height - yvalue
            width: 2
            opacity: 0.6
            color: "#77A200"
            gradient: Gradient {
                GradientStop { position: 1.0; color: "#3B5100" }
                GradientStop { position: 0.0; color: "#77A200" }
            }
            Rectangle {
                color: "white"
                width: 2
                height: 2
            }
        }
    }
}