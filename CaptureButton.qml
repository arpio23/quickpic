// Copyright (C) 2017 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0


Button {
    id: btnCapture
    implicitWidth: 100
    implicitHeight: 100
    icon.name: "camera-photo-symbolic"
    icon.width: Math.round(btnCapture.width * 0.5)
    icon.height: Math.round(btnCapture.height * 0.5)
    icon.color: "lightblue"

    background: Rectangle {
        anchors.fill: parent
        color: btnCapture.down ? "red" : "#99000000"
        border.width: 2
        border.color: "lightblue"
        radius: 90
    }

    onClicked: {
        camera.imageCapture.capture()
    }
}