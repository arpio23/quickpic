import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.12
import QtGraphicalEffects 1.0
import QtMultimedia 5.15
import QtQuick.Layouts 1.15

Window {
    id : mainWindow

    width: 400
    height: 800
    visible: true
    color: "black"

    ListModel {
        id: resolutionModel
    }

    Camera {
        id: camera
        captureMode: Camera.CaptureStillImage

        onCameraStateChanged: {
            console.log(camera.cameraState)
        }

        Component.onCompleted: {

            console.log("MAXZOOM: ", camera.maximumDigitalZoom)
            resolutionModel.clear()
            for (var p in camera.imageCapture.supportedResolutions){
                resolutionModel.append({"widthR": camera.imageCapture.supportedResolutions[p].width, "heightR": camera.imageCapture.supportedResolutions[p].height})
            }     

        }
    }

    VideoOutput {
        anchors.fill: parent
        source: camera
        autoOrientation: true

        PinchArea
        {
            property int oldZoom

            MouseArea
            {
                id:dragArea
                hoverEnabled: true
                anchors.fill: parent
                scrollGestureEnabled: false
            }
            anchors.fill:parent
            enabled: true
            pinch.dragAxis: pinch.XAndYAxis
            pinch.maximumX: parent.width
            pinch.maximumY: parent.height
            pinch.maximumScale: 2.0
            pinch.minimumScale: 0.0

            onPinchStarted: {
                oldZoom = camera.digitalZoom
            }

            onPinchUpdated: {
                var newZoom = (Math.round(pinch.scale * 10) - 10) + oldZoom

                if(newZoom >= 0 && newZoom < camera.maximumDigitalZoom){
                    camera.setDigitalZoom(newZoom)
                }
            }
        }
    }


    RowLayout {
        width: parent.width
        height: 100
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        CameraSelect {
            model: QtMultimedia.availableCameras
            onValueChanged: {
                camera.deviceId = value
                resolutionModel.clear()
                for (var p in camera.imageCapture.supportedResolutions){
                    resolutionModel.append({"widthR": camera.imageCapture.supportedResolutions[p].width, "heightR": camera.imageCapture.supportedResolutions[p].height})
                } 
            }
            Layout.alignment : Qt.AlignHCenter
            //anchors.verticalCenter: parent.verticalCenter
        }

        CaptureButton {
            Layout.alignment : Qt.AlignHCenter
            //anchors.centerIn: parent
        }

        Resolution {
            onValueChanged: {
                camera.imageCapture.resolution = camera.imageCapture.supportedResolutions[value]
                console.log("ERROR: " + camera.viewfinder.resolution)
            }

            Layout.alignment : Qt.AlignHCenter


        }
    }

    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 5
        width: 200
        height: 40
        color: "#99000000"
        border.width: 2
        border.color: "lightblue"

        Text {
            text: camera.viewfinder.resolution.width + "x" + camera.viewfinder.resolution.height

            anchors.fill: parent
            anchors.margins: 5
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            color: "white"
            font.bold: true
            style: Text.Raised
            styleColor: "black"
            font.pixelSize: 14
        }
    }

    ZoomControl {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }
}