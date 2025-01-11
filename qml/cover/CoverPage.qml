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

CoverBackground {
    id: mycover
    Label {
        id: label
        anchors.centerIn: parent
        text: qsTr("Boolean Functions Forever")
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-pause"
        }
    }
}
