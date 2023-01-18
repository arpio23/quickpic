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
        property int cameraId: 0
        property var resArray: []
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

            if(!settings.resArray.length || (settings.resArray.length < QtMultimedia.availableCameras.length)) {
                var arr = []
                for (var i = 0; i < QtMultimedia.availableCameras.length; i++){
                    arr.push(0)
                }
                settings.setValue("resArray", arr)
            }
            camera.deviceId = settings.cameraId
            resolutionModel.clear()
            for (var p in camera.imageCapture.supportedResolutions){
                resolutionModel.append({"widthR": camera.imageCapture.supportedResolutions[p].width, "heightR": camera.imageCapture.supportedResolutions[p].height})
            }
            camera.imageCapture.resolution = camera.imageCapture.supportedResolutions[settings.resArray[camera.deviceId]]
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

    Item {
        id: camZoom
        onScaleChanged: {
            camera.setDigitalZoom(scale)
        }
    }

    PinchArea
    {
        enabled: !photoView.visible

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
        pinch.dragAxis: pinch.XAndYAxis
        pinch.target: camZoom
        pinch.maximumScale: camera.maximumDigitalZoom
        pinch.minimumScale: 0

        onPinchStarted: {
        }

        onPinchUpdated: {
        }
    }


    RowLayout {
        id: btnRow
        width: parent.width
        height: 100
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        visible: !photoView.visible

        CameraSelect {
            model: QtMultimedia.availableCameras
            onValueChanged: {
                camera.deviceId = value
                settings.setValue("cameraId", value)
                resolutionModel.clear()
                for (var p in camera.imageCapture.supportedResolutions){
                    resolutionModel.append({"widthR": camera.imageCapture.supportedResolutions[p].width, "heightR": camera.imageCapture.supportedResolutions[p].height})
                }

                camera.imageCapture.resolution = camera.imageCapture.supportedResolutions[settings.resArray[camera.deviceId]]
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
                settings.resArray[camera.deviceId] = value
                settings.setValue("resArray", settings.resArray)
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

    Rectangle {
        id: imgBtn
        anchors.right: parent.right
        anchors.bottom: btnRow.top
        anchors.margins: 5
        width: 100
        height: 100
        color: "black"

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width: imgBtn.width
                height: imgBtn.height
                Rectangle {
                    anchors.centerIn: parent
                    width: imgBtn.adapt ? imgBtn.width : Math.min(imgBtn.width, imgBtn.height)
                    height: imgBtn.adapt ? imgBtn.height : width
                    radius: 90
                    
                }
            }
        }

        Image {
            anchors.centerIn: parent
            autoTransform: true
            transformOrigin: Item.Center
            fillMode: Image.PreserveAspectFit
            smooth: true
            source: photoView.lastImg
            scale: Math.min(parent.width/width, parent.height/height)
        }
    }

    Rectangle {
        anchors.fill: imgBtn
        color: "transparent"
        border.width: 2
        border.color: "lightblue"
        radius: 90
        MouseArea {
            anchors.fill: parent
            onClicked: photoView.visible = true
        }
    }

    ViewPicture {
        id : photoView
        anchors.fill : parent
        onClosed: camera.start()
        focus: visible
    }
}