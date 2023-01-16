import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.12
import QtGraphicalEffects 1.0
import QtMultimedia 5.15
import QtQuick.Layouts 1.15
import Qt.labs.settings 1.0

Window {
    id : mainWindow

    width: 400
    height: 800
    visible: true
    color: "black"

    Settings {
        id: settings
        property int resolutionId: 0
        property int cameraId: 0

    }

    ListModel {
        id: resolutionModel
    }

    Camera {
        id: camera
        captureMode: Camera.CaptureStillImage

        focus {
            focusMode: Camera.FocusMacro
            focusPointMode: Camera.FocusPointCustom
        }

        onCameraStateChanged: {
            console.log(camera.cameraState)
        }

        Component.onCompleted: {
            camera.deviceId = settings.cameraId
            resolutionModel.clear()
            for (var p in camera.imageCapture.supportedResolutions){
                resolutionModel.append({"widthR": camera.imageCapture.supportedResolutions[p].width, "heightR": camera.imageCapture.supportedResolutions[p].height})
            }
            camera.imageCapture.resolution = camera.imageCapture.supportedResolutions[settings.resolutionId]
        }
    }

    VideoOutput {
        id: viewfinder
        anchors.fill: parent
        source: camera
        autoOrientation: true

        Rectangle {
            id: focusPointRect
            border {
              width: 4
              color: "steelblue"
          }
          color: "transparent"
          radius: 90
          width: 100
          height: 100
          visible: false

          Timer {
            id: visTm
            interval: 2000; running: false; repeat: false
            onTriggered: focusPointRect.visible = false
        }
    }
}

PinchArea
{
    property int oldZoom

    MouseArea
    {
        id:dragArea
        hoverEnabled: true
        anchors.fill: parent
        scrollGestureEnabled: false

        onClicked: {
            camera.focus.customFocusPoint = Qt.point(mouse.x/dragArea.width, mouse.y/dragArea.height)
            camera.focus.focusMode = Camera.FocusMacro
            focusPointRect.visible = true
            focusPointRect.x = mouse.x - (focusPointRect.width/2)
            focusPointRect.y = mouse.y - (focusPointRect.height/2)
            visTm.start()
            camera.searchAndLock()
        }
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


RowLayout {
    width: parent.width
    height: 100
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter

    CameraSelect {
        model: QtMultimedia.availableCameras
        onValueChanged: {
            camera.deviceId = value
            settings.setValue("cameraId", value)
            resolutionModel.clear()
            for (var p in camera.imageCapture.supportedResolutions){
                resolutionModel.append({"widthR": camera.imageCapture.supportedResolutions[p].width, "heightR": camera.imageCapture.supportedResolutions[p].height})
            } 
        }
        Layout.alignment : Qt.AlignHCenter
    }

    CaptureButton {
        Layout.alignment : Qt.AlignHCenter
    }

    Resolution {
        id: resolutionButton

        onValueChanged: {
            camera.imageCapture.resolution = camera.imageCapture.supportedResolutions[value]
            settings.setValue("resolutionId", value)
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