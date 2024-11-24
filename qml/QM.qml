import QtQuick 2.5

//import Felgo 3.0
import Sailfish.Silica 1.0

//FlickablePage { // Felgo
Page { // Sailfish OS
    //title: qsTr("Quine-McCluskey algorithm") // Felgo
    id: qmPage

    //flickable.contentHeight: qmColumn.height // Felgo
    //flickable.contentWidth: qmColumn.width // Felgo
    //scrollIndicator.visible: true // Felgo

    property var coveringTableModel:
        (appwindow.activeVariables === 2) ? coveringTableModel2 :
        (appwindow.activeVariables === 3) ? coveringTableModel3 :
        (appwindow.activeVariables === 4) ? coveringTableModel4 :
        (appwindow.activeVariables === 5) ? coveringTableModel5 : null

    // Sailfish OS
    /**/
    onStatusChanged: {
        if (status == PageStatus.Active) {
            pageStack.pushAttached(Qt.resolvedUrl("About.qml"))
        }
    }
    /**/

    //Item { // Felgo
    SilicaFlickable { // Sailfish OS
        anchors.fill: parent
        contentHeight: qmColumn.height // Sailfish OS
        contentWidth: qmColumn.width // Sailfish OS
        VerticalScrollDecorator {} // Sailfish OS

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
            text: qsTr("Quine-McCluskey algorithm")
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
            width: textlog.contentWidth
            spacing: appwindow.textSpacingSize

            // AppText { // Felgo
            Label { // Sailfish OS
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

            // StyledButton { // Felgo
            Button { // Sailfish OS
                id: buttonPrevious
                enabled: coveringTableModel.numSopSolutions > 1 ? true : false
                text: "<"
                color: appwindow.textColor2
                highlightBackgroundColor: appwindow.textColor2 // Sailfish OS
                highlightColor: appwindow.diagramTextColor // Sailfish OS
                width: buttonrow.width / 8 // just a heuristic, looks good
                onClicked: {
                    //console.log("BUTTON " + text)
                    coveringTableModel.prevSelectedSopSolution()
                }
            }

            // StyledButton { // Felgo
            Button { // Sailfish OS
                id: buttonNumSolutions
                enabled: true
                text: "<font>"+coveringTableModel.selectedSopSolution+" / "+coveringTableModel.numSopSolutions+"</font>"
                color: appwindow.textColor2
                highlightBackgroundColor: appwindow.textColor2 // Sailfish OS
                highlightColor: appwindow.diagramTextColor // Sailfish OS
                width: buttonrow.width / 3 // just a heuristic, looks good
                onClicked: {
                    //console.log("BUTTON " + text)
                    coveringTableModel.nextSelectedSopSolution()
                }
            }

            // StyledButton { // Felgo
            Button { // Sailfish OS
                id: buttonNext
                enabled: coveringTableModel.numSopSolutions > 1 ? true : false
                text: ">"
                color: appwindow.textColor2
                highlightBackgroundColor: appwindow.textColor2 // Sailfish OS
                highlightColor: appwindow.diagramTextColor // Sailfish OS
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

        // AppText { // Felgo
        Label { // Sailfish OS
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Covering table")
            color: appwindow.textColor1
            //font.bold : true
            font.family: "FreeMono"
            font.capitalization: Font.SmallCaps
            font.pixelSize: appwindow.titleTextSize
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
                    border.width: appwindow.diagramBorderWidth
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
            anchors.horizontalCenter: parent.horizontalCenter

            Column {

                GridView {
                    id: qmGridHorizontalLegend // IT SHOWS PRIME IMPLICANTS
                    interactive: false
                    layoutDirection: Qt.RightToLeft
                    anchors.horizontalCenter: parent.horizontalCenter
                    cellWidth: qmGrid.cellWidth
                    cellHeight: qmGrid.cellHeight
                    width: coveringTableModel.implicantsSize * cellWidth
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
                              font.pixelSize: 0.8 * appwindow.titleTextSize
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
                    cellWidth: (coveringTableModel.implicantsSize > 10) ? 0.6 * appwindow.diagramCellSize : 0.8 * appwindow.diagramCellSize
                    cellHeight: 0.8 * appwindow.diagramCellSize
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
                //height: (coveringTableModel.onsetSize + 1) * cellHeight
                height: 16 * cellHeight
                model: coveringTableModel
                delegate:
                    Item {
                      id: qmGridVerticalLegendItem
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
                          font.pixelSize: 0.66 * appwindow.titleTextSize
                      }
                    }
            }

        }

    }
    }
    }

}
