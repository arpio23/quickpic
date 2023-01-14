import QtQuick 2.14
import QtQuick.Controls 2.14

Popup {
    id: resolutionListPopup

    property variant currentValue
    // property variant currentItem : model[view.currentIndex]

    property int itemWidth : 200
    property int itemHeight : 40

    width: itemWidth + view.anchors.margins*2
    height: mainWindow.height * 0.7

    signal selected

    ScrollView{
        anchors.fill: parent

        ListView {
        id: view
        model: resolutionModel
        width: parent.width
        anchors.margins: 5
        snapMode: ListView.SnapOneItem
        highlightFollowsCurrentItem: true
        highlight: Rectangle { color: "steelblue"; radius: 2 }
        currentIndex: 0

        delegate: Item {
            width: resolutionListPopup.itemWidth
            height: resolutionListPopup.itemHeight

            Text {
                text: widthR + "x" + heightR

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
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    view.currentIndex = index
                    resolutionListPopup.currentValue = view.currentIndex
                    //resolutionListPopup.selected(modelData.deviceId)
                }
            }
        }
    }
    }

    
}
