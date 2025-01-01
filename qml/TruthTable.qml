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
    id: truthTablePage

    property var truthTableModel:
        (appwindow.activeVariables === 2) ? truthTableModel2 :
        (appwindow.activeVariables === 3) ? truthTableModel3 :
        (appwindow.activeVariables === 4) ? truthTableModel4 :
        (appwindow.activeVariables === 5) ? truthTableModel5 : null
    property var coveringTableModel:
        (appwindow.activeVariables === 2) ? coveringTableModel2 :
        (appwindow.activeVariables === 3) ? coveringTableModel3 :
        (appwindow.activeVariables === 4) ? coveringTableModel4 :
        (appwindow.activeVariables === 5) ? coveringTableModel5 : null
    property var tableGrid: table.tableGrid
    property int truthtablesize: appwindow.activeVariables + 1
    property int truthtablelines: truthTableModel.rowCount() / truthtablesize

    onStatusChanged: {
        if (status == PageStatus.Active) {
            pageBooleanExpression ? pageStack.pushAttached(Qt.resolvedUrl("BooleanExpression.qml")) :
                pageQM ? pageStack.pushAttached(Qt.resolvedUrl("QM.qml")) : pageStack.pushAttached(Qt.resolvedUrl("About.qml"))
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: truthTableColumn.height
        contentWidth: truthTableColumn.width
        VerticalScrollDecorator {}

        PullDownMenu {
            MenuItem {
                text: qsTr("INIT 0")
                onClicked: {
                    //console.log("MENU: " + text)
                    tableGrid.model.allZero()
                }
            }
            MenuItem {
                text: qsTr("INIT 1")
                onClicked: {
                    //console.log("MENU: " + text)
                    tableGrid.model.allOne()
                }
            }
            MenuItem {
                text: qsTr("RANDOM")
                onClicked: {
                    //console.log("MENU: " + text)
                    tableGrid.model.allRandom()
                }
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: truthTableColumn.width
            height: truthTableColumn.height
            gradient: Gradient {
                GradientStop { position: 0.0; color: appwindow.bgColor1 }
                GradientStop { position: 0.382; color: appwindow.bgColor2 }
                GradientStop { position: 0.618; color: appwindow.bgColor1 }
                GradientStop { position: 1.0; color: appwindow.bgColor2 }
            }

            Component {
                id: tableCell

                Item {
                    id: tableCellItem
                    width: appwindow.diagramCellSize
                    height: appwindow.tableRowSize
                    Rectangle {
                        parent: truthTablePage.tableGrid
                        x: tableCellItem.x
                        y: tableCellItem.y
                        width: tableCellItem.width
                        height: tableCellItem.height
                        color: appwindow.bgDiagramColor
                        border.color: appwindow.bgDiagramLegendColor
                        border.width: 1

                        Text {
                          anchors.centerIn: parent
                          text: display
                          color: (index % truthTablePage.truthtablesize === appwindow.activeVariables) ? appwindow.diagramTextColor : appwindow.disabledTextColor
                          font.family: "FreeSans"
                          font.pixelSize: appwindow.regularTextSize
                        }

                        /*
                        Component.onCompleted: {
                            console.log("TruthTable: tableCell, index = " + index + ", tableCellItem.y = " + tableCellItem.y + ", y = " + y)
                        }
                        */
                    }
                }
            }

            Column {
                id: truthTableColumn
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
                    text: qsTr("Truth Table")
                    color: appwindow.titleTextColor
                    //font.bold : true
                    font.family: "FreeSans"
                    font.pixelSize: appwindow.titleTextSize
                }

                Item {
                    id: table
                    width: parent.width
                    height: truthTablePage.truthtablelines * appwindow.tableRowSize + 2 * appwindow.diagramBorderSize + 1 * appwindow.diagramLegendHeight
                    property alias tableGrid: tableGrid

                    /*
                    Component.onCompleted: {
                        console.log("TruthTable: Component.onCompleted "+" ("+appwindow.activeVariables+" variables), model.rowCount()="+tableGrid.model.rowCount())
                    }
                    */

                    // truthTableBorder is now shown but used for positioning of other elements
                    Rectangle {
                        id: truthTableBorder
                        width: truthTablePage.truthtablesize * appwindow.diagramCellSize + 2 * appwindow.diagramBorderSize
                        height: truthTablePage.truthtablelines * appwindow.tableRowSize + 2 * appwindow.diagramBorderSize
                        color: "transparent"
                        border.width: appwindow.diagramBorderSize
                        border.color: appwindow.bgDiagramLegendColor // use "yellow" to debug
                        //anchors.centerIn: parent
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: appwindow.diagramLegendHeight

                        z: 2 // normal 2, use 6 to debug
                    }

                    Rectangle {
                        id: truthTableLegendTop
                        width: truthTablePage.truthtablesize * appwindow.diagramCellSize
                        height: appwindow.diagramLegendHeight
                        radius: 0
                        color: appwindow.bgDiagramLegendColor
                        anchors.bottom: truthTableBorder.top
                        anchors.horizontalCenter: truthTableBorder.horizontalCenter
                        z: 4

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenterOffset: 4 * appwindow.diagramCellSize / 10
                            Label {
                                text: '<font>'+appwindow.variableA+'</font>'
                                color: appwindow.textColor2
                                width: appwindow.diagramCellSize
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                            Label {
                                text: '<font>'+appwindow.variableB+'</font>'
                                color: appwindow.textColor2
                                width: appwindow.diagramCellSize
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                            Label {
                                visible: (appwindow.activeVariables > 2)
                                text: '<font>'+appwindow.variableC+'</font>'
                                color: appwindow.textColor2
                                width: appwindow.diagramCellSize
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                            Label {
                                visible: (appwindow.activeVariables > 3)
                                text: '<font>'+appwindow.variableD+'</font>'
                                color: appwindow.textColor2
                                width: appwindow.diagramCellSize
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                            Label {
                                visible: (appwindow.activeVariables > 4)
                                text: '<font>'+appwindow.variableE+'</font>'
                                color: appwindow.textColor2
                                width: appwindow.diagramCellSize
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                            Label {
                                text: ""
                                color: appwindow.textColor2
                                width: appwindow.diagramCellSize
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                        }
                    }

                    GridView {
                        id: tableGrid
                        cellWidth: appwindow.diagramCellSize
                        cellHeight: appwindow.tableRowSize
                        width: truthTablePage.truthtablesize * appwindow.diagramCellSize
                        height: truthTablePage.truthtablelines * appwindow.tableRowSize
                        anchors.bottom: truthTableBorder.bottom // not centerIn, because legend is only on the top
                        anchors.horizontalCenter: truthTableBorder.horizontalCenter
                        model: truthTableModel
                        delegate: tableCell
                        z: 2

                        MouseArea {
                            id: gridArea
                            anchors.fill: parent
                            hoverEnabled: true
                            preventStealing : true
                            property int index: tableGrid.indexAt(mouseX, mouseY)

                            onClicked: {
                                var value = tableGrid.model.get(index) // use this for C++ TruthTableModel
                                //var value = tableGrid.model.get(index).display // use this for QML ListModel
                                if (index % truthTablePage.truthtablesize !== appwindow.activeVariables) return
                                //console.log("onClicked("+((index-4)/5)+"/" + value + ")")
                                if (value === " ") {
                                    tableGrid.model.setZero(index)
                                }
                                if (value === "0") {
                                    tableGrid.model.setOne(index)
                                }
                                if (value === "1") {
                                    tableGrid.model.setX(index)
                                }
                                if (value === "X") {
                                    tableGrid.model.setZero(index)
                                }
                            }
                        }
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
                    anchors.horizontalCenter: table.horizontalCenter
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
                    anchors.horizontalCenter: table.horizontalCenter
                    id: textrow

                    Label {
                        id: textrowSop
                        text: ""
                        textFormat: Text.RichText
                        color: appwindow.textColor1
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                        lineHeightMode: Text.ProportionalHeight
                        lineHeight: 1.1
                    }

                    Connections {
                        target: coveringTableModel
                        onSopChanged: {
                            //console.log("KarnaughMap: coveringTableModel.onSopChanged")
                            var soptext = truthTableModel.string2html(coveringTableModel.sop)
                            textrowSop.text = "<font>"+soptext+"</font>"
                        }
                    }
                }

            } //Column
        } //Rectangle
    } //SilicaFlickable
}
