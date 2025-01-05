// Copyright (C) 2024,2025 Robert Meolic, SI-2000 Maribor, Slovenia.

// biddy-bff is free software; you can redistribute it and/or modify it under the terms
// of the GNU General Public License as published by the Free Software Foundation;
// either version 2 of the License, or (at your option) any later version.

// biddy-bff is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
// PARTICULAR PURPOSE. See the GNU General Public License for more details.

// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51 Franklin
// Street, Fifth Floor, Boston, MA 02110-1301 USA.

// QtQuick version is a 1 to 1 mapping to Qt, i.e. Qt 5.X.* supports QtQuick 2.X.
// By including QtQuick 2.N, Qt will create it using the latest available QtQuick version (2.LAST), but it will only give you the features available in 2.N.
// So, by declaring QtQuick 2.N you limit the features to the specified version, but you still benefits from all the bug fixes.
// Thus, you should use the smallest QtQuick 2.N version that you need.
//
// https://en.wikipedia.org/wiki/Qt_Quick
// rpm -qi qt5-qtcore
// rpm -qi qt5-qtdeclarative-qtquick
// rpm -qi sailfishsilica-qt5
// SailfishOS 4.6.0.15 (Sony XA2) uses Qt 5.6.3 and supports QtQuick 2.6, QtQml 2.0, QtQml.Models 2.2, and Sailfish.Silica 1.2
// SailfishOS 5.0.0.43 (Jolla C2) uses Qt 5.6.3 and supports QtQuick 2.6, QtQml 2.0, QtQml.Models 2.2, and Sailfish.Silica 1.2

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: booleanExpressionPage

    property var coveringTableModel:
        (appwindow.activeVariables === 2) ? coveringTableModel2 :
        (appwindow.activeVariables === 3) ? coveringTableModel3 :
        (appwindow.activeVariables === 4) ? coveringTableModel4 :
        (appwindow.activeVariables === 5) ? coveringTableModel5 : null

    onStatusChanged: {
        if (status == PageStatus.Active) {
            pageQM ? pageStack.pushAttached(Qt.resolvedUrl("QM.qml")) : pageStack.pushAttached(Qt.resolvedUrl("About.qml"))
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: booleanExpressionColumn.height
        contentWidth: booleanExpressionColumn.width
        VerticalScrollDecorator {}

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
        width: appwindow.myScreenWidth
        height: (implicitHeight < appwindow.myScreenHeight) ? appwindow.myScreenHeight : implicitHeight
        spacing: appwindow.textSpacingSize

        Row {
            Item {
                width: 1 // dummy value != 0
                height: appwindow.titleTextSize
            }
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Boolean expression")
            color: appwindow.titleTextColor
            //font.bold : true
            font.family: "FreeSans"
            font.pixelSize: appwindow.titleTextSize
        }

        Row {
            Item {
                width: 1 // dummy value != 0
                height: appwindow.tinyTextSize
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            Label {
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
            Label {
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
            width: textsop.contentWidth
            height: textsop.contentHeight
            spacing: appwindow.textSpacingSize

            Label {
                id : textsop
                color: appwindow.textColor1
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
