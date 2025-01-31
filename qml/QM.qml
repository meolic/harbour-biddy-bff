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
    id: qmPage

    property var coveringTableModel:
        (appwindow.activeVariables === 2) ? coveringTableModel2 :
        (appwindow.activeVariables === 3) ? coveringTableModel3 :
        (appwindow.activeVariables === 4) ? coveringTableModel4 :
        (appwindow.activeVariables === 5) ? coveringTableModel5 : null

    property int coveringTableFontSize: (coveringTableModel.implicantsSize < 16)
                                        ? (1.1 - 0.04 * coveringTableModel.implicantsSize) * appwindow.titleTextSize
                                        : (coveringTableModel.implicantsSize < 24)
                                          ? (0.95 - 0.02 * coveringTableModel.implicantsSize) * appwindow.titleTextSize
                                          : (0.7 - 0.01 * coveringTableModel.implicantsSize) * appwindow.titleTextSize
    property int coveringTableCellSize: (coveringTableModel.implicantsSize < 16)
                                        ? (1.1 - 0.04 * coveringTableModel.implicantsSize) * appwindow.diagramCellSize
                                        : (coveringTableModel.implicantsSize < 24)
                                          ? (0.8 - 0.02 * coveringTableModel.implicantsSize) * appwindow.diagramCellSize
                                          : (0.56 - 0.01 * coveringTableModel.implicantsSize) * appwindow.diagramCellSize

    onStatusChanged: {
        if (status == PageStatus.Active) {
            pageStack.pushAttached(Qt.resolvedUrl("About.qml"))

            // force recalculation of all dependent variables when model change - needed because (probably) a bug in QML
            /**/
            qmGridHorizontalLegend.model = null
            qmGridHorizontalLegend.model = coveringTableModel
            qmGrid.model = null
            qmGrid.model = coveringTableModel
            qmGridVerticalLegend.model = null
            qmGridVerticalLegend.model = coveringTableModel
            /**/

            /*
            console.log("QM:" + "onsetSize = " + coveringTableModel.onsetSize + ", implicantsSize = " + coveringTableModel.implicantsSize
                              + ", qmPage.coveringTableFontSize = " + qmPage.coveringTableFontSize
                              + ", qmPage.coveringTableCellSize = " + qmPage.coveringTableCellSize
                              + ", qmGridHorizontalLegend.width = " + qmGridHorizontalLegend.width
                              + ", qmGridHorizontalLegend.height = " + qmGridHorizontalLegend.height
                              + ", qmGrid.width = " + qmGrid.width
                              + ", qmGrid.height = " + qmGrid.heigh
                              + ", qmGridVerticalLegend.width = " + qmGridVerticalLegend.width
                              + ", qmGridVerticalLegend.height = " + qmGridVerticalLegend.height
                       )
            */
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: qmColumn.height
        contentWidth: qmColumn.width
        VerticalScrollDecorator {}

    Rectangle {
        anchors.centerIn: parent
        width: qmColumn.width
        height: qmColumn.height
        gradient: Gradient {
            GradientStop { position: 0.0; color: appwindow.bgColor1 }
            GradientStop { position: 0.382; color: appwindow.bgColor2 }
            GradientStop { position: 0.618; color: appwindow.bgColor1 }
            GradientStop { position: 1.0; color: appwindow.bgColor2 }
        }

    Column {
        id: qmColumn
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
            text: qsTr("Quine-McCluskey algorithm")
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
            width: textlog.contentWidth
            spacing: appwindow.textSpacingSize

            Label {
                id : textlog
                text: qsTr(coveringTableModel.qmlog)
                color: appwindow.textColor1
                textFormat: Text.RichText
                font.family: "FreeMono"
                font.capitalization: Font.SmallCaps
                font.pixelSize: appwindow.titleTextSize
            }

        }

        Item {
            width: 1 // dummy value != 0
            height: appwindow.titleTextSize
        }

        // BUTTONS TO CHANGE THE SOLUTION

        Row {
            id: buttonrow
            width: qmPage.width
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5 * buttonrow.width / 72

            Item {
                width: 5 * buttonrow.width / 72
                height: 1 // dummy value != 0
            }

            Button {
                id: buttonPrevious
                enabled: coveringTableModel.numSopSolutions > 1 ? true : false
                text: "<"
                color: appwindow.textColor2
                highlightBackgroundColor: appwindow.textColor2
                highlightColor: appwindow.diagramTextColor
                width: buttonrow.width / 8 // just a heuristic, looks good
                onClicked: {
                    //console.log("BUTTON " + text)
                    coveringTableModel.prevSelectedSopSolution()
                }
            }

            Button {
                id: buttonNumSolutions
                enabled: true
                text: "<font>"+coveringTableModel.selectedSopSolution+" / "+coveringTableModel.numSopSolutions+"</font>"
                color: appwindow.textColor2
                highlightBackgroundColor: appwindow.textColor2
                highlightColor: appwindow.diagramTextColor
                width: buttonrow.width / 3 // just a heuristic, looks good
                onClicked: {
                    //console.log("BUTTON " + text)
                    coveringTableModel.nextSelectedSopSolution()
                }
            }

            Button {
                id: buttonNext
                enabled: coveringTableModel.numSopSolutions > 1 ? true : false
                text: ">"
                color: appwindow.textColor2
                highlightBackgroundColor: appwindow.textColor2
                highlightColor: appwindow.diagramTextColor
                width: buttonrow.width / 8 // just a heuristic, looks good
                onClicked: {
                    //console.log("BUTTON " + text)
                    coveringTableModel.nextSelectedSopSolution()
                }
            }

            Item {
                width: 5 * buttonrow.width / 72
                height: 1 // dummy value != 0
            }

            Connections {
                target: coveringTableModel
                onSopChanged: {
                    //console.log("QM onSopChanged")
                    buttonPrevious.enabled = coveringTableModel.numSopSolutions > 1 ? true : false
                    buttonNext.enabled = coveringTableModel.numSopSolutions > 1 ? true : false
                    buttonNumSolutions.text = "<font>"+coveringTableModel.selectedSopSolution+" / "+coveringTableModel.numSopSolutions+"</font>"
                }
            }

        }

        Item {
            width: 1 // dummy value != 0
            height: appwindow.titleTextSize
        }

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Covering table")
            color: appwindow.textColor1
            //font.bold : true
            font.family: "FreeMono"
            font.capitalization: Font.SmallCaps
            font.pixelSize: appwindow.titleTextSize
        }

        Item {
            width: 1 // dummy value != 0
            height: 0.2 * appwindow.titleTextSize
        }

        Component {
            id: diagramQM

            Item {
                id: diagramQMItem
                visible: index < coveringTableModel.implicantsSize * coveringTableModel.onsetSize
                width: qmGrid.cellWidth
                height: qmGrid.cellHeight
                Rectangle {
                    visible: true
                    anchors.centerIn: parent
                    x: diagramQMItem.x
                    y: diagramQMItem.y + diagramQMItem.height/2
                    width: diagramQMItem.width
                    height: 2
                    color: appwindow.textColor2
                    z: 2
                }
                Rectangle {
                    visible: (covering == "1" || covering == "3") ? true : false
                    anchors.centerIn: parent
                    x: diagramQMItem.x
                    y: diagramQMItem.y + diagramQMItem.height/2
                    width: 2
                    height: diagramQMItem.height
                    color: appwindow.textColor2
                    z: 2
                }
                /*
                Text {
                    text: index
                    visible: true
                    anchors.centerIn: parent
                    x: diagramQMItem.x + diagramQMItem.width/4
                    y: diagramQMItem.y
                    width: diagramQMItem.width/2
                    height: diagramQMItem.height/2
                    color: appwindow.textColor2
                    z: 2
                }
                */
                Rectangle {
                    visible: (covering == "1" || covering == "2") ? true : false
                    anchors.centerIn: parent
                    x: diagramQMItem.x + diagramQMItem.width/4
                    y: diagramQMItem.y
                    width: diagramQMItem.width/2
                    height: diagramQMItem.height/2
                    radius: diagramQMItem.width/2 // create circles
                    color: covering == "1" ? appwindow.titleTextColor : appwindow.textColor1
                    border.width: appwindow.diagramBorderSize
                    border.color: appwindow.bgDiagramLegendColor
                    z: 3
                }
                /*
                Text {
                    text: index
                    visible: true
                    anchors.centerIn: parent
                    x: diagramQMItem.x + diagramQMItem.width/4
                    y: diagramQMItem.y
                    color: appwindow.textColor2
                    z: 2
                }
                */
            }
        }

        Item {
            width: 1 // dummy value != 0
            height: appwindow.titleTextSize
        }

        Row {
            id: qmrow
            anchors.horizontalCenter: parent.horizontalCenter

            Column {

                GridView {
                    id: qmGridHorizontalLegend // IT SHOWS PRIME IMPLICANTS
                    interactive: false
                    layoutDirection: Qt.RightToLeft
                    anchors.horizontalCenter: parent.horizontalCenter
                    cellWidth: qmGrid.cellWidth
                    cellHeight: qmGrid.cellHeight
                    width: coveringTableModel.implicantsSize * cellWidth // we may need +2 to compensate rounding drawbacks
                    height: cellHeight
                    model: coveringTableModel
                    delegate:
                        Item {
                            id: qmGridHorizontalLegendItem
                            visible: index < coveringTableModel.implicantsSize
                            width: qmGridHorizontalLegend.cellWidth
                            height: qmGridHorizontalLegend.cellHeight
                            Text {
                                text: implicant ? implicant + "  " : ""
                                rotation: 90
                                color: appwindow.textColor2
                                anchors.centerIn: parent
                                font.family: "FreeMono"
                                font.capitalization: Font.SmallCaps
                                font.pixelSize: qmPage.coveringTableFontSize
                            }
                        }
                }

                GridView {
                    id: qmGrid
                    interactive: false
                    flow: GridView.FlowTopToBottom
                    layoutDirection: Qt.RightToLeft
                    verticalLayoutDirection: GridView.TopToBottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    cellWidth:  qmPage.coveringTableCellSize
                    cellHeight: qmPage.coveringTableCellSize
                    width: coveringTableModel.implicantsSize * cellWidth
                    height: coveringTableModel.onsetSize * cellHeight
                    model: coveringTableModel
                    delegate: diagramQM
                }
            }

            GridView {
                id: qmGridVerticalLegend // IT SHOWS MINTERMS
                interactive: false
                cellWidth: qmGrid.cellWidth
                cellHeight: qmGrid.cellHeight
                width: cellWidth
                height: coveringTableModel.onsetSize * cellHeight + qmGrid.implicitHeight
                model: coveringTableModel
                delegate:
                    Item {
                        visible: index <= coveringTableModel.onsetSize
                        width: qmGridVerticalLegend.cellWidth
                        height: qmGridVerticalLegend.cellHeight
                        Text {
                            text: minterm ? minterm : ""
                            rotation: 90
                            color: appwindow.titleTextColor
                            anchors.centerIn: parent
                            font.family: "FreeMono"
                            font.capitalization: Font.SmallCaps
                            font.pixelSize: qmPage.coveringTableFontSize
                        }
                    }
            }

        }
    }
    }
    }

}
