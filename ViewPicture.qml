import QtQuick 2.15
import QtMultimedia 5.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Rectangle {
    id: viewRect
    property alias source : view.source
    signal closed

    color: "black"
    visible: false

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: parent.width*2
        contentHeight: parent.height*2
        boundsBehavior: Flickable.StopAtBounds
        clip: true

        Item {
            id: imgItm

            width: Math.max(view.width * view.scale, flick.width)
            height: Math.max(view.height * view.scale, flick.height)

            Image {
                id: view
                anchors.centerIn: parent
                autoTransform: true
                transformOrigin: Item.Center
                fillMode: Image.PreserveAspectFit
                smooth: true

                onStatusChanged: {
                    if (view.status == Image.Ready){
                        view.scale = Math.min(flick.width/view.width, flick.height/view.height, 1)
                        imgItm.x = 0
                        imgItm.y = 0
                        flick.returnToBounds()
                    }
                }
            }
        }
    }

    PinchArea {
        anchors.fill: flick
        pinch.target: view
        pinch.maximumScale: 2
        pinch.minimumScale: 0
        pinch.dragAxis: Pinch.XandYAxis

        MouseArea
        {
            anchors.fill: parent
            drag.axis: Drag.XAndYAxis
            drag.target: imgItm
        }
        
        onPinchStarted: {
        }

        onPinchUpdated: {
            flick.contentX += pinch.previousCenter.x - pinch.center.x
            flick.contentY += pinch.previousCenter.y - pinch.center.y
        }

        onPinchFinished: {
            flick.returnToBounds();
        }
    }

    RowLayout {
        width: parent.width
        height: 70
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        Button {
            id: btnClose
            implicitWidth: 70
            implicitHeight: 70
            icon.name: "window-close-symbolic"
            icon.width: Math.round(btnClose.width * 0.5)
            icon.height: Math.round(btnClose.height * 0.5)
            icon.color: "lightblue"
            Layout.alignment : Qt.AlignHCenter

            background: Rectangle {
                anchors.fill: parent
                color: btnClose.down ? "red" : "#99000000"
                border.width: 2
                border.color: "lightblue"
                radius: 90
            }

            onClicked: {
                viewRect.visible = false
                viewRect.closed();
            }
        }
    }
}
