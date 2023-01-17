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

    Image {
        id: view
        anchors.fill: parent
        autoTransform: true
        fillMode: Image.PreserveAspectFit
        smooth: true
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
