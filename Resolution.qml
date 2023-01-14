import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import QtMultimedia 5.15

Item {
    width: 70
    height: 70
    id: cameraListButton
    property alias value : popup.currentValue

    Button {
        id: btnResolution
        anchors.fill: parent
        icon.name: "applications-system-symbolic"
        icon.width: Math.round(btnResolution.width * 0.5)
        icon.height: Math.round(btnResolution.height * 0.5)
        icon.color: "lightblue"

        background: Rectangle {
            anchors.fill: parent
            color: "#99000000"
            border.width: 2
            border.color: "lightblue"
            radius: 90
        }

        onClicked: {
            
            popup.toggle()
        }
    }

    ResolutionListPopup {
        id: popup
        anchors.right: parent.left
        anchors.bottom: parent.top
        anchors.bottomMargin: 16
        visible: opacity > 0

        onSelected: popup.toggle()
    }

}