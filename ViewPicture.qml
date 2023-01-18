import QtQuick 2.15
import QtMultimedia 5.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt.labs.folderlistmodel 2.15
import Qt.labs.platform 1.1

Rectangle {
    id: viewRect
    property int index: 0
    property var lastImg: imgModel.get(viewRect.index, "fileUrl")
    signal closed

    color: "black"
    visible: false

    FolderListModel {
        id: imgModel
        folder: StandardPaths.writableLocation(StandardPaths.PicturesLocation)+"/quickpic"
        showDirs: false
        nameFilters: ["*.jpg"]

        onStatusChanged: {
            if(imgModel.status == FolderListModel.Ready){
                viewRect.index = imgModel.count - 1
            }
        }
    }

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
                source: imgModel.get(viewRect.index, "fileUrl")

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
                viewRect.index = imgModel.count - 1
                viewRect.closed();
            }
        }
    }

    Button {
        id: btnPrev
        implicitWidth: 60
        implicitHeight: 60
        anchors.margins: 5
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        icon.name: "go-previous-symbolic"
        icon.width: Math.round(btnPrev.width * 0.5)
        icon.height: Math.round(btnPrev.height * 0.5)
        icon.color: "lightblue"
        Layout.alignment : Qt.AlignHCenter

        background: Rectangle {
            anchors.fill: parent
            color: "#AA000000"
            radius: 90
        }

        onClicked: {
            if((viewRect.index - 1) >= 0 )
                viewRect.index = viewRect.index - 1
        }
    }

    Button {
        id: btnNext
        implicitWidth: 60
        implicitHeight: 60
        anchors.margins: 5
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        icon.name: "go-next-symbolic"
        icon.width: Math.round(btnNext.width * 0.5)
        icon.height: Math.round(btnNext.height * 0.5)
        icon.color: "lightblue"
        visible: viewRect.index < (imgModel.count - 1)
        Layout.alignment : Qt.AlignHCenter

        background: Rectangle {
            anchors.fill: parent
            color: "#AA000000"
            radius: 90
        }

        onClicked: {
            if((viewRect.index + 1) <= (imgModel.count - 1))
                viewRect.index = viewRect.index + 1
        }
    }

    Rectangle {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 5
        width: 200
        height: 50
        color: "#AA000000"
        border.width: 2
        border.color: "lightblue"
        visible: viewRect.index > 0
        Text {
            text: viewRect.index+" / "+(imgModel.count - 1)

            anchors.fill: parent
            anchors.margins: 5
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            color: "white"
            font.bold: true
            style: Text.Raised
            styleColor: "black"
            font.pixelSize: 16
        }
    }
}
