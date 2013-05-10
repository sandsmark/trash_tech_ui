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
            gradient: Gradient {
                GradientStop { position: 1.0; color: first_color }
                GradientStop { position: 0.0; color: second_color }
            }
            Rectangle {
                color: "white"
                width: 2
                height: 2
            }
        }
    }
}