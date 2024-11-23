import QtQuick 2.5

//import Felgo 3.0
import Sailfish.Silica 1.0

//FlickablePage { // Felgo
Page { // Sailfish OS
    //title: qsTr("Boolean expression") // Felgo
    id: booleanExpressionPage

    //flickable.contentHeight: booleanExpressionColumn.height // Felgo
    //flickable.contentWidth: booleanExpressionColumn.width // Felgo
    //scrollIndicator.visible: true // Felgo

    property var coveringTableModel: coveringTableModel4

    // Sailfish OS
    /**/
    onStatusChanged: {
        if (status == PageStatus.Active) {
            pageQM ? pageStack.pushAttached(Qt.resolvedUrl("QM.qml")) : pageStack.pushAttached(Qt.resolvedUrl("About.qml"))
        }
    }
    /**/

    //Item { // Felgo
    SilicaFlickable { // Sailfish OS
        anchors.fill: parent
        contentHeight: booleanExpressionColumn.height // Sailfish OS
        contentWidth: booleanExpressionColumn.width // Sailfish OS
        VerticalScrollDecorator {} // Sailfish OS

    Rectangle {
        anchors.centerIn: parent
        width: booleanExpressionColumn.width
        height: booleanExpressionColumn.height
        gradient: Gradient {
            GradientStop { position: 0.0; color: appwindow.bgColor1 }
            GradientStop { position: 0.382; color: appwindow.bgColor2 }
            GradientStop { position: 0.618; color: appwindow.bgColor1 }
            GradientStop { position: 1.0; color: appwindow.bgColor2 }
        }

    Column {
        id: booleanExpressionColumn
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

        // Sailfish OS
        /**/
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Boolean expression")
            color: appwindow.titleTextColor
            //font.bold : true
            font.family: "FreeSans"
            font.pixelSize: appwindow.titleTextSize
        }
        /**/

        Row {
            Item {
                width: 1 // dummy value != 0
                height: appwindow.tinyTextSize
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            // AppText { // Felgo
            Label { // Sailfish OS
                text: qsTr("Not implemented, yet")
                color: appwindow.textColor1
                //font.bold : true
                font.family: "FreeSans"
                font.pixelSize: appwindow.regularTextSize
            }
        }

        // SOP

        Row {
            Item {
                width: 1 // dummy value != 0
                height: appwindow.tinyTextSize
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            // AppText { // Felgo
            Label { // Sailfish OS
                text: qsTr("SOP")
                color: appwindow.titleTextColor
                //font.bold : true
                font.family: "FreeSans"
                font.pixelSize: appwindow.titleTextSize
            }
        }

        Row {
            Item {
                width: 1 // dummy value != 0
                height: appwindow.tinyTextSize / 3
            }
        }

        Row {
            id : textrow
            anchors.horizontalCenter: parent.horizontalCenter
            //width: textsop.implicitWidth // Felgo
            //height: textsop.implicitHeight // Felgo
            width: textsop.contentWidth // Sailfish OS
            height: textsop.contentHeight // Sailfish OS
            spacing: appwindow.textSpacingSize

            // AppText { // Felgo
            Label { // Sailfish OS
                id : textsop
                color: appwindow.textColor1
                //width: implicitWidth // Felgo
                //height: implicitHeight // Felgo
                text: "<font>"+truthTableModel.string2html(coveringTableModel.sop)+"</font>"
                textFormat: Text.RichText
                font.family: "TypeWriter"
                //font.capitalization: Font.SmallCaps
                font.pixelSize: appwindow.titleTextSize
                lineHeightMode: Text.ProportionalHeight
                lineHeight: 1.2
            }
        }

    }
    }
    }
}
