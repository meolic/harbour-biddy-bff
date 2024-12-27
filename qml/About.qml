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
    id: aboutPage

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: aboutColumn.height
        contentWidth: aboutColumn.width
        VerticalScrollDecorator {}

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
        width: Screen.width
        height: (implicitHeight < Screen.height) ? Screen.height : implicitHeight
        spacing: appwindow.textSpacingSize

        Row {
            Item {
                width: 1 // dummy value != 0
                height: appwindow.titleTextSize
            }
        }

        Label {
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

        Label {
            x: appwindow.titleTextSize
            text: qsTr("Copyright (C) 2024,2025 Robert Meolic")
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

        Label {
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

        Label {
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

        Label {
            x: appwindow.titleTextSize
            text: qsTr("I test on Sony XA2 and Jolla C2. <br>Please, use email <u>robert@meolic.com</u><br>to report issues and ideas.")
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

        Label {
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
