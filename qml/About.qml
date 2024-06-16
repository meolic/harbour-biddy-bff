import QtQuick 2.5

//import Felgo 3.0
import Sailfish.Silica 1.0

//FlickablePage { // Felgo
Page { // Sailfish OS
    //navigationBarHidden: true // Felgo
    id: aboutPage

    //flickable.contentHeight: aboutColumn.height // Felgo
    //flickable.contentWidth: aboutColumn.width // Felgo
    //scrollIndicator.visible: true // Felgo

    //Item { // Felgo
    SilicaFlickable { // Sailfish OS
        anchors.fill: parent
        contentHeight: aboutColumn.height // Sailfish OS
        contentWidth: aboutColumn.width // Sailfish OS
        VerticalScrollDecorator {} // Sailfish OS

    Rectangle {
        anchors.centerIn: parent
        width: aboutColumn.width
        height: aboutColumn.height
        gradient: Gradient {
            GradientStop { position: 0.0; color: appwindow.bgColor1 }
            GradientStop { position: 0.382; color: appwindow.bgColor2 }
            GradientStop { position: 0.618; color: appwindow.bgColor1 }
            GradientStop { position: 1.0; color: appwindow.bgColor2 }
        }

    Column {
        id: aboutColumn
        anchors.centerIn: parent
        //width: appwindow.screenWidth // Felgo
        //height: (implicitHeight < appwindow.screenHeight) ? appwindow.screenHeight : implicitHeight // Felgo
        width: Screen.width // Sailfish OS
        height: (implicitHeight < Screen.height) ? Screen.height : implicitHeight // Sailfish OS
        spacing: appwindow.textSpacingSize

        Row {
            Item {
                width: 1 // dummy value != 0
                height: appwindow.titleTextSize
            }
        }

        // AppText { // Felgo
        Label { // Sailfish OS
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("About")
            color: appwindow.titleTextColor
            //font.bold : true
            font.family: "FreeSans"
            font.pixelSize: appwindow.titleTextSize
        }

        Row {
            Item {
                width: 1 // dummy value != 0
                height: appwindow.titleTextSize
            }
        }

        // AppText { // Felgo
        Label { // Sailfish OS
            x: appwindow.titleTextSize
            text: qsTr("Copyright (C) 2024 Robert Meolic")
            //font.bold : true
            color: appwindow.textColor2
            font.family: "FreeSans"
            font.pixelSize: appwindow.smallTextSize
        }

        Row {
            Item {
                width: 1 // dummy value != 0
                height: appwindow.tinyTextSize
            }
        }

        Row {
            Item {
                width: 1 // dummy value != 0
                height: appwindow.tinyTextSize
            }
        }

        // AppText { // Felgo
        Label { // Sailfish OS
            x: appwindow.titleTextSize
            text: qsTr("With respect to a great but unfortunately<br>abandoned project KARMA from LogiCS lab<br>at UFRGS, Brasil.")
            //font.bold : true
            color: appwindow.textColor1
            font.family: "FreeSans"
            font.pixelSize: appwindow.smallTextSize
        }

        Row {
            Item {
                width: 1 // dummy value != 0
                height: appwindow.tinyTextSize
            }
        }

        // AppText { // Felgo
        Label { // Sailfish OS
            x: appwindow.titleTextSize
            text: qsTr("This app is a Sailfish OS exclusive!<br>It integrates a complex C library Biddy.")
            //font.bold : true
            color: appwindow.textColor2
            font.family: "FreeSans"
            font.pixelSize: appwindow.smallTextSize
        }

        Row {
            Item {
                width: 1 // dummy value != 0
                height: appwindow.tinyTextSize
            }
        }

        // AppText { // Felgo
        Label { // Sailfish OS
            x: appwindow.titleTextSize
            text: qsTr("I can test on Sony XA2 and Sailfish 4, only.<br>Please, use email <u>robert@meolic.com</u><br>to report issues and ideas.")
            //font.bold : true
            color: appwindow.textColor1
            font.family: "FreeSans"
            font.pixelSize: appwindow.smallTextSize
        }

        Row {
            id: gplspace
            property int size: (Screen.height - y - gpl.height - appwindow.titleTextSize) / 1
            Item {
                width: 1 // dummy value != 0
                height: (gplspace.size < appwindow.titleTextSize) ? appwindow.titleTextSize : gplspace.size
            }
        }

        // AppText { // Felgo
        Label { // Sailfish OS
            id: gpl
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr(
                "This is free sofware.<br>Check GNU General Public License."
            )
            //font.bold : true
            color: appwindow.textColor2
            font.family: "FreeSans"
            font.pixelSize: appwindow.tinyTextSize
        }
    }
    }
    }
}
