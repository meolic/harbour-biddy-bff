import QtQuick 2.5

//import Felgo 3.0
import Sailfish.Silica 1.0

//FlickablePage { // Felgo
Page { // Sailfish OS
    //title: qsTr("Truth Table") // Felgo
    id: truthTablePage

    //flickable.contentHeight: truthTableColumn.height // Felgo
    //flickable.contentWidth: truthTableColumn.width // Felgo
    //scrollIndicator.visible: true // Felgo

    // Sailfish OS
    /**/
    onStatusChanged: {
        if (status == PageStatus.Active) {
            pageBooleanExpression ? pageStack.pushAttached(Qt.resolvedUrl("BooleanExpression.qml")) :
                pageQM ? pageStack.pushAttached(Qt.resolvedUrl("QM.qml")) : pageStack.pushAttached(Qt.resolvedUrl("About.qml"))
        }
    }
    /**/

    //Item { // Felgo
    SilicaFlickable { // Sailfish OS
        anchors.fill: parent
        contentHeight: truthTableColumn.height // Sailfish OS
        contentWidth: truthTableColumn.width // Sailfish OS
        VerticalScrollDecorator {} // Sailfish OS

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

            Column {
                id: truthTableColumn
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
                    text: qsTr("Truth Table")
                    color: appwindow.titleTextColor
                    //font.bold : true
                    font.family: "FreeSans"
                    font.pixelSize: appwindow.titleTextSize
                }
                /**/

                Item {
                    id: table
                    height: 16 * appwindow.tableRowSize + 2 * appwindow.diagramCellBorder + 1 * appwindow.diagramCellSize
                    width: parent.width

                    /*
                    Component.onCompleted: {
                        console.log("TruthTable: table started")
                    }
                    */

                    // truthTableBorder is now shown but used for positioning of other elements
                    Rectangle {
                        id: truthTableBorder
                        width: 5 * appwindow.diagramCellSize + 2 * appwindow.diagramCellBorder // fixed for 4 variables
                        height: 16 * appwindow.tableRowSize + 2 * appwindow.diagramCellBorder // fixed for 4 variables
                        color: "transparent" // use "red" to debug
                        border.width: appwindow.diagramBorderWidth
                        border.color: appwindow.bgDiagramLegendColor
                        //anchors.centerIn: parent
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        z: 2 // use 6 to debug
                    }

                    Rectangle {
                        id: truthTableLegendTop
                        width: 5*appwindow.diagramCellSize
                        height: appwindow.largeTextSize
                        radius: 0 //appwindow.diagramCellRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.bottom: truthTableBorder.top
                        anchors.left: truthTableBorder.left
                        anchors.leftMargin: appwindow.diagramCellBorder
                        z: 4

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenterOffset: appwindow.diagramCellSize / 4 + 12 // fixed for 4 variables
                            // AppText { // Felgo
                            Label { // Sailfish OS
                                text: '<font>'+appwindow.variableA+'</font>'
                                color: appwindow.textColor2
                                width: appwindow.diagramCellSize
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                            // AppText { // Felgo
                            Label { // Sailfish OS
                                text: '<font>'+appwindow.variableB+'</font>'
                                color: appwindow.textColor2
                                width: appwindow.diagramCellSize
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                            // AppText { // Felgo
                            Label { // Sailfish OS
                                text: '<font>'+appwindow.variableC+'</font>'
                                color: appwindow.textColor2
                                width: appwindow.diagramCellSize
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                            // AppText { // Felgo
                            Label { // Sailfish OS
                                text: '<font>'+appwindow.variableD+'</font>'
                                color: appwindow.textColor2
                                width: appwindow.diagramCellSize
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                            // AppText { // Felgo
                            Label { // Sailfish OS
                                text: ""
                                color: appwindow.textColor2
                                width: appwindow.diagramCellSize
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                        }
                    }

                    Component {
                        id: tableCell

                        Item {
                            id: tableCellItem
                            width: appwindow.diagramCellSize
                            height: appwindow.tableRowSize
                            Rectangle {
                                id: box
                                parent: tableGrid
                                x: tableCellItem.x
                                y: tableCellItem.y
                                width: tableCellItem.width
                                height: tableCellItem.height
                                border.width: 1

                                Text {
                                  anchors.centerIn: parent
                                  text: display
                                  color: (index%5 == 4) ? appwindow.diagramTextColor : appwindow.disabledTextColor
                                  font.family: "FreeSans"
                                  font.pixelSize: appwindow.regularTextSize
                                }
                            }
                        }
                    }

                    GridView {
                        id: tableGrid
                        cellWidth: appwindow.diagramCellSize
                        cellHeight: appwindow.tableRowSize
                        width: 5*cellWidth
                        height: 16*cellHeight
                        //anchors.centerIn: parent
                        anchors.bottom: truthTableBorder.bottom
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
                                if (index%5 != 4) return
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
                    anchors.horizontalCenter: table.horizontalCenter
                    id: textrow

                    // AppText { // Felgo
                    Label { // Sailfish OS
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
