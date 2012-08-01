import QtQuick 1.1

Rectangle {
    id: canvas
    height: 100
    width: 25
    color: "black"
    property int value: 20;
    property string label: "none"
    
    FontLoader { id: fancyfont; source: "/usr/share/fonts/TTF/Perfect Dark Zero.ttf" }
    
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#FF2121" }
        GradientStop { position: 0.5; color: "#FF7300" }
        GradientStop { position: 1.0; color: "#91C500" }
    }
    Rectangle {
        x: 0
        y: 0
        opacity: 0.8
        height: (100 - parent.value) / 100 * parent.height
        Behavior on height {
            NumberAnimation { duration: 200 }
        }
        width: parent.width
        color: "black"
    }
    Text {
        y: parent.height
        x: parent.width - 10
        color: "white"
        text: parent.label
        font.family: fancyfont.name
        font.pointSize: 17
        transform: Rotation { angle: 270; origin.x: 0; origin.y: 0 }
    }
}