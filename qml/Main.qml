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

ApplicationWindow
{
    id: appwindow
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    // Sony Xperai XA2
    // Display:  1920 × 1080 px

    // Jolla C2 (2024) - Reeder S19 Max Pro S (2023)
    // Size: 179 x 78 x 8.5mm
    // Display:  LCD 60 Hz / 1600 × 720 px / 6.74" / 108.78 cm² / ~ 150 x 70 mm
    // Memory: 8192 MB
    // Storage: 128 GB + 128GB storage (expandable with MicroSD)
    // Chipset: Unisoc Tiger T606 / Spreadtrum T606 / ARM Unisoc @ 1.82 GHz, 1 Processor, 8 Cores
    // Chipset: ARM implementer 65 architecture 8 variant 3 part 3338 revision 1
    // Chipset: 2x 1.6 GHz ARM Cortex-A75 / 6x 1.6 GHz ARM Cortex-A55
    // GPU Type: Mali-G57 MP1 (650 MHz)
    // Connectivity: LTE+ (4.5G), BT 5.0, WLAN 802.11ac
    // Cameras: 64MP / 16MP / 8MP
    // USB: Type-C
    // Other: 3.5mm audio jack, Dual SIM (nano) + microSD

    property string version: "v2024-12-27"

    property int myScreenHeight: _screenHeight
    property int myScreenWidth: _screenWidth

    property int diagramCellSize: myScreenWidth / 9
    property int diagramBorderSize: 2
    property int diagramLegendWidth: diagramCellSize / 2
    property int diagramLegendHeight: 3 * diagramCellSize / 4
    property int diagramGap: 2 * diagramLegendHeight
    property int diagramCircleBorder: diagramCellSize / 10

    property int tableRowSize: (activeVariables < 5) ? myScreenWidth / 12 : myScreenWidth / 20

    property int textSize: diagramCellSize
    property int logoTextSize: textSize
    property int largeTextSize: textSize * 2 / 3
    property int titleTextSize: textSize / 2
    property int regularTextSize: textSize * 2 / 5
    property int smallTextSize: textSize / 3
    property int tinyTextSize: textSize / 4
    property int textSpacingSize: 8

    property color bgColor1: '#041116' // background first color
    property color bgColor2: '#040616' // background second color
    property color bgDiagramColor: '#d3e2f8' // diagram background
    property color bgDiagramLegendColor: '#07162c' // diagram legend background
    property color titleTextColor: '#01A7DD' // logo and title text color
    property color textColor1: '#eee9fb' // regular text color
    property color textColor2: '#d3f8f8' // emphasized text color
    property color diagramTextColor: '#2c1d07' // diagram text color
    property color disabledTextColor: '#888888' // diagram text color

    // ACTIVE TABS

    property bool pageKarnaughMap: true
    property bool pageTruthTable: true
    property bool pageBooleanExpression: false
    property bool pageQM: true

    // NUMBER OF VARIABLES

    property int activeVariables: 4  // reffer from other models to this value as appwindow.activeVariables

    // VARIABLE NAMES

    property string variableA: inputA.text
    property string variableB: inputB.text
    property string variableC: inputC.text
    property string variableD: inputD.text
    property string variableE: inputE.text
    property string variablePA: truthTableModel5.string2html("a")
    property string variablePB: truthTableModel5.string2html("b")
    property string variablePC: truthTableModel5.string2html("c")
    property string variablePD: truthTableModel5.string2html("d")
    property string variablePE: truthTableModel5.string2html("e")
    property string variableNA: truthTableModel5.string2html("*a")
    property string variableNB: truthTableModel5.string2html("*b")
    property string variableNC: truthTableModel5.string2html("*c")
    property string variableND: truthTableModel5.string2html("*d")
    property string variableNE: truthTableModel5.string2html("*e")

    //x: Theme.horizontalPageMargin
    //color: Theme.secondaryHighlightColor
    //font.pixelSize: Theme.fontSizeExtraLarge

    Component.onCompleted: {

        // initial values of variableA, variableB, ... are given in the elements furter in this file

        truthTableModel2.setVariableName(1,variableA)
        truthTableModel3.setVariableName(1,variableA)
        truthTableModel4.setVariableName(1,variableA)
        truthTableModel5.setVariableName(1,variableA)

        truthTableModel2.setVariableName(2,variableB)
        truthTableModel3.setVariableName(2,variableB)
        truthTableModel4.setVariableName(2,variableB)
        truthTableModel5.setVariableName(2,variableB)

        truthTableModel2.setVariableName(3,variableC)
        truthTableModel3.setVariableName(3,variableC)
        truthTableModel4.setVariableName(3,variableC)
        truthTableModel5.setVariableName(3,variableC)

        truthTableModel2.setVariableName(4,variableD)
        truthTableModel3.setVariableName(4,variableD)
        truthTableModel4.setVariableName(4,variableD)
        truthTableModel5.setVariableName(4,variableD)

        truthTableModel2.setVariableName(5,variableE)
        truthTableModel3.setVariableName(5,variableE)
        truthTableModel4.setVariableName(5,variableE)
        truthTableModel5.setVariableName(5,variableE)

        truthTableModel2.allZero()
        truthTableModel3.allZero()
        truthTableModel4.allZero()
        truthTableModel5.allZero()
        pageStack.push(mainPage,{ },PageStackAction.Immediate)
        pageKarnaughMap ? pageStack.pushAttached(Qt.resolvedUrl("KarnaughMap.qml")) :
            pageTruthTable ? pageStack.pushAttached(Qt.resolvedUrl("TruthTable.qml")) :
            pageBooleanExpression ? pageStack.pushAttached(Qt.resolvedUrl("BooleanExpression.qml")) :
            pageQM ? pageStack.pushAttached(Qt.resolvedUrl("QM.qml")) : pageStack.pushAttached(Qt.resolvedUrl("About.qml"))
    }

    Page {
        id: mainPage

        SilicaFlickable {
            anchors.fill: parent
            contentHeight: mainColumn.height
            contentWidth: mainColumn.width
            VerticalScrollDecorator {}

            Component.onCompleted: {
                console.log("Main: SilicaFlickable started")
                console.log("Main: myScreenHeight = " + myScreenHeight)
                console.log("Main: myScreenWidth = " + myScreenWidth)
                console.log("Main: activeVariables = " + activeVariables)
            }

            // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
            PullDownMenu {
                MenuItem {
                    text: qsTr("About")
                    visible: true
                    onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
                }
                MenuItem {
                    text: qsTr("Quine-McCluskey algorithm")
                    visible: pageQM
                    onClicked: {
                        if (pageKarnaughMap == true) pageStack.push(Qt.resolvedUrl("KarnaughMap.qml"),{ },PageStackAction.Immediate)
                        if (pageTruthTable == true) pageStack.push(Qt.resolvedUrl("TruthTable.qml"),{ },PageStackAction.Immediate)
                        if (pageBooleanExpression == true) pageStack.push(Qt.resolvedUrl("BooleanExpression.qml"),{ },PageStackAction.Immediate)
                        if (pageQM == true) pageStack.push(Qt.resolvedUrl("QM.qml"),{ },PageStackAction.Immediate)
                    }
                }
                MenuItem {
                    text: qsTr("Boolean expression")
                    visible: pageBooleanExpression
                    onClicked: {
                        if (pageKarnaughMap == true) pageStack.push(Qt.resolvedUrl("KarnaughMap.qml"),{ },PageStackAction.Immediate)
                        if (pageTruthTable == true) pageStack.push(Qt.resolvedUrl("TruthTable.qml"),{ },PageStackAction.Immediate)
                        if (pageBooleanExpression == true) pageStack.push(Qt.resolvedUrl("BooleanExpression.qml"),{ },PageStackAction.Immediate)
                    }
                }
                MenuItem {
                    text: qsTr("Truth Table")
                    visible: pageTruthTable
                    onClicked: {
                        if (pageKarnaughMap == true) pageStack.push(Qt.resolvedUrl("KarnaughMap.qml"),{ },PageStackAction.Immediate)
                        if (pageTruthTable == true) pageStack.push(Qt.resolvedUrl("TruthTable.qml"),{ },PageStackAction.Immediate)
                    }
                }
                MenuItem {
                    text: qsTr("Karnaugh Map")
                    visible: pageKarnaughMap
                    onClicked: {
                        if (pageKarnaughMap == true) pageStack.push(Qt.resolvedUrl("KarnaughMap.qml"),{ },PageStackAction.Immediate)
                    }
                }
            }
            //PushUpMenu {}
            /**/

            Rectangle {
                anchors.centerIn: parent
                width: mainColumn.width
                height: mainColumn.height
                gradient: Gradient {
                    GradientStop { position: 0.0; color: appwindow.bgColor1 }
                    GradientStop { position: 0.382; color: appwindow.bgColor2 }
                    GradientStop { position: 0.618; color: appwindow.bgColor1 }
                    GradientStop { position: 1.0; color: appwindow.bgColor2 }
                }

            Column {
                id: mainColumn
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

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter

                    /*
                    Image {
                        id: logo
                        source: "bff.png"
                    }
                    */

                    Label {
                        //anchors.bottom: logo.bottom
                        text: qsTr("BFF")
                        color: appwindow.titleTextColor
                        font.bold : true
                        font.family: "FreeSans"
                        font.pixelSize: appwindow.logoTextSize
                    }
                }

                Label {
                    id: mainContent
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Boolean Functions Forever")
                    color: appwindow.textColor2
                    font.bold : true
                    //font.italic: true
                    font.capitalization: Font.SmallCaps
                    font.family: "TypeWriter"
                    font.pixelSize: appwindow.titleTextSize
                }

                Row {
                    Item {
                        width: 1 // dummy value != 0
                        height: appwindow.titleTextSize
                    }
                }

                Row {
                    anchors.left: mainContent.left
                    height: appwindow.largeTextSize
                    Label {
                        text: qsTr("Active tabs:")
                        color: appwindow.textColor1
                        //font.bold : true
                        font.family: "FreeSans"
                        font.pixelSize: appwindow.titleTextSize
                    }
                }

                Row {
                    anchors.left: mainContent.left
                    spacing: appwindow.textSpacingSize

                    Item {
                        width: appwindow.regularTextSize
                        height: appwindow.titleTextSize

                        Label {
                            id: plusKarnaughMap
                            anchors.centerIn: parent
                            z: 4
                            text: pageKarnaughMap ? "+" : "-"
                            color: pageKarnaughMap ? appwindow.titleTextColor : appwindow.disabledTextColor
                            font.bold: pageKarnaughMap ? true : false
                            font.family: "FreeSans"
                            font.pixelSize: appwindow.regularTextSize
                        }

                        Button {
                            anchors.fill: parent
                            z: 2
                            clip: true
                            // text: "X" // DEBUG
                            // color: "yellow" // DEBUG
                            // border.color: "yellow" // DEBUG
                            color: "transparent"
                            highlightBackgroundColor: appwindow.textColor2
                            onClicked: {
                                //console.log("BUTTON plusKarnaughMap")
                                pageKarnaughMap ? pageKarnaughMap = false : pageKarnaughMap = true
                                pageKarnaughMap ? pageStack.pushAttached(Qt.resolvedUrl("KarnaughMap.qml")) :
                                    pageTruthTable ? pageStack.pushAttached(Qt.resolvedUrl("TruthTable.qml")) :
                                    pageBooleanExpression ? pageStack.pushAttached(Qt.resolvedUrl("BooleanExpression.qml")) :
                                    pageQM ? pageStack.pushAttached(Qt.resolvedUrl("QM.qml")) : pageStack.pushAttached(Qt.resolvedUrl("About.qml"))
                            }
                        }
                    }

                    Label {
                        text: qsTr("Karnaugh Map")
                        color: pageKarnaughMap ? appwindow.textColor1 : appwindow.disabledTextColor
                        font.family: "FreeSans"
                        font.pixelSize: appwindow.regularTextSize
                    }

                }

                Row {
                    anchors.left: mainContent.left
                    spacing: appwindow.textSpacingSize

                    Item {
                        width: appwindow.regularTextSize
                        height: appwindow.titleTextSize

                        Label {
                            id: plusTruthTable
                            anchors.centerIn: parent
                            z: 4
                            text: pageTruthTable ? "+" : "-"
                            color: pageTruthTable ? appwindow.titleTextColor : appwindow.disabledTextColor
                            font.bold: pageTruthTable ? true : false
                            font.family: "FreeSans"
                            font.pixelSize: appwindow.regularTextSize
                        }

                        Button {
                            anchors.fill: parent
                            z: 2
                            clip: true
                            // text: "X" // DEBUG
                            // color: "yellow" // DEBUG
                            // border.color: "yellow" // DEBUG
                            color: "transparent"
                            highlightBackgroundColor: appwindow.textColor2
                            onClicked: {
                                //console.log("BUTTON pageTruthTable")
                                pageTruthTable ? pageTruthTable = false : pageTruthTable = true
                                pageKarnaughMap ? pageStack.pushAttached(Qt.resolvedUrl("KarnaughMap.qml")) :
                                    pageTruthTable ? pageStack.pushAttached(Qt.resolvedUrl("TruthTable.qml")) :
                                    pageBooleanExpression ? pageStack.pushAttached(Qt.resolvedUrl("BooleanExpression.qml")) :
                                    pageQM ? pageStack.pushAttached(Qt.resolvedUrl("QM.qml")) : pageStack.pushAttached(Qt.resolvedUrl("About.qml"))
                            }
                        }
                    }

                    Label {
                        text: qsTr("Truth Table")
                        color: pageTruthTable ? appwindow.textColor1 : appwindow.disabledTextColor
                        font.family: "FreeSans"
                        font.pixelSize: appwindow.regularTextSize
                    }

                }

                Row {
                    anchors.left: mainContent.left
                    spacing: appwindow.textSpacingSize

                    Item {
                        width: appwindow.regularTextSize
                        height: appwindow.titleTextSize

                        Label {
                            id: plusBooleanExpression
                            anchors.centerIn: parent
                            z: 4
                            text: pageBooleanExpression ? "+" : "-"
                            color: pageBooleanExpression ? appwindow.titleTextColor : appwindow.disabledTextColor
                            font.bold: pageBooleanExpression ? true : false
                            font.family: "FreeSans"
                            font.pixelSize: appwindow.regularTextSize
                        }

                        Button {
                            anchors.fill: parent
                            z: 2
                            clip: true
                            // text: "X" // DEBUG
                            // color: "yellow" // DEBUG
                            // border.color: "yellow" // DEBUG
                            color: "transparent"
                            highlightBackgroundColor: appwindow.textColor2
                            onClicked: {
                                //console.log("BUTTON pageBooleanExpression")
                                pageBooleanExpression ? pageBooleanExpression = false : pageBooleanExpression = true
                                pageKarnaughMap ? pageStack.pushAttached(Qt.resolvedUrl("KarnaughMap.qml")) :
                                    pageTruthTable ? pageStack.pushAttached(Qt.resolvedUrl("TruthTable.qml")) :
                                    pageBooleanExpression ? pageStack.pushAttached(Qt.resolvedUrl("BooleanExpression.qml")) :
                                    pageQM ? pageStack.pushAttached(Qt.resolvedUrl("QM.qml")) : pageStack.pushAttached(Qt.resolvedUrl("About.qml"))
                            }
                        }
                    }

                    Label {
                        text: qsTr("Boolean expression")
                        color: pageBooleanExpression ? appwindow.textColor1 : appwindow.disabledTextColor
                        font.family: "FreeSans"
                        font.pixelSize: appwindow.regularTextSize
                    }

                }

                Row {
                    anchors.left: mainContent.left
                    spacing: appwindow.textSpacingSize

                    Item {
                        width: appwindow.regularTextSize
                        height: appwindow.titleTextSize

                        Label {
                            id: plusQM
                            anchors.centerIn: parent
                            z: 4
                            text: pageQM ? "+" : "-"
                            color: pageQM ? appwindow.titleTextColor : appwindow.disabledTextColor
                            font.bold: pageQM ? true : false
                            font.family: "FreeSans"
                            font.pixelSize: appwindow.regularTextSize
                        }

                        Button {
                            anchors.fill: parent
                            z: 2
                            clip: true
                            // text: "X" // DEBUG
                            // color: "yellow" // DEBUG
                            // border.color: "yellow" // DEBUG
                            color: "transparent"
                            highlightBackgroundColor: appwindow.textColor2
                            onClicked: {
                                //console.log("BUTTON pageQM")
                                pageQM ? pageQM = false : pageQM = true
                                pageKarnaughMap ? pageStack.pushAttached(Qt.resolvedUrl("KarnaughMap.qml")) :
                                    pageTruthTable ? pageStack.pushAttached(Qt.resolvedUrl("TruthTable.qml")) :
                                    pageBooleanExpression ? pageStack.pushAttached(Qt.resolvedUrl("BooleanExpression.qml")) :
                                    pageQM ? pageStack.pushAttached(Qt.resolvedUrl("QM.qml")) : pageStack.pushAttached(Qt.resolvedUrl("About.qml"))
                            }
                        }
                    }

                    Label {
                        text: qsTr("Quine-McCluskey algorithm")
                        color: pageQM ? appwindow.textColor1 : appwindow.disabledTextColor
                        font.family: "FreeSans"
                        font.pixelSize: appwindow.regularTextSize
                    }

                }

                /*
                Row {
                    anchors.left: mainContent.left
                    height: appwindow.regularTextSize
                    Label {
                        anchors.bottom: parent.bottom
                        text: qsTr("* Not changeable, yet")
                        color: appwindow.textColor1
                        font.family: "FreeSans"
                        font.pixelSize: appwindow.tinyTextSize
                    }
                }
                */

                Row {
                    Item {
                        width: 1 // dummy value != 0
                        height: appwindow.textSize
                    }
                }

                Row {
                    anchors.left: mainContent.left
                    height: appwindow.largeTextSize
                    Label {
                        text: qsTr("Number of variables:")
                        color: appwindow.textColor1
                        //font.bold : true
                        font.family: "FreeSans"
                        font.pixelSize: appwindow.titleTextSize
                    }
                }

                Row {
                    anchors.left: mainContent.left
                    spacing: appwindow.textSpacingSize

                    Button {
                        id: numvar2
                        width: appwindow.diagramCellSize
                        height: appwindow.diagramCellSize
                        border.color: "transparent"
                        color: "transparent"
                        Label {
                            anchors.centerIn: parent
                            text: "2"
                            color: appwindow.textColor1
                            font.family: "FreeSans"
                            font.pixelSize: appwindow.largeTextSize
                        }
                        onClicked: {
                            console.log("BUTTON 2 variables")
                            activeVariables = 2
                            numvar2.border.color = appwindow.titleTextColor
                            numvar3.border.color = "transparent"
                            numvar4.border.color = "transparent"
                            numvar5.border.color = "transparent"
                        }
                    }

                    Button {
                        id: numvar3
                        width: appwindow.diagramCellSize
                        height: appwindow.diagramCellSize
                        border.color: "transparent"
                        color: "transparent"
                        Label {
                            anchors.centerIn: parent
                            text: "3"
                            color: appwindow.textColor1
                            font.family: "FreeSans"
                            font.pixelSize: appwindow.largeTextSize
                        }
                        onClicked: {
                            console.log("BUTTON 3 variables")
                            activeVariables = 3
                            numvar2.border.color = "transparent"
                            numvar3.border.color = appwindow.titleTextColor
                            numvar4.border.color = "transparent"
                            numvar5.border.color = "transparent"
                        }
                    }

                    Button {
                        id: numvar4
                        width: appwindow.diagramCellSize
                        height: appwindow.diagramCellSize
                        border.color: appwindow.titleTextColor
                        color: "transparent"
                        Label {
                            anchors.centerIn: parent
                            text: "4"
                            color: appwindow.textColor1
                            font.family: "FreeSans"
                            font.pixelSize: appwindow.largeTextSize
                        }
                        onClicked: {
                            console.log("BUTTON 4 variables")
                            activeVariables = 4
                            numvar2.border.color = "transparent"
                            numvar3.border.color = "transparent"
                            numvar4.border.color = appwindow.titleTextColor
                            numvar5.border.color = "transparent"
                        }
                    }

                    Button {
                        id: numvar5
                        width: appwindow.diagramCellSize
                        height: appwindow.diagramCellSize
                        border.color: "transparent"
                        color: "transparent"
                        Label {
                            anchors.centerIn: parent
                            text: "5"
                            color: appwindow.textColor1
                            font.family: "FreeSans"
                            font.pixelSize: appwindow.largeTextSize
                        }
                        onClicked: {
                            console.log("BUTTON 5 variables")
                            activeVariables = 5
                            numvar2.border.color = "transparent"
                            numvar3.border.color = "transparent"
                            numvar4.border.color = "transparent"
                            numvar5.border.color = appwindow.titleTextColor
                        }
                    }

                }

                /*
                Row {
                    anchors.left: mainContent.left
                    height: appwindow.regularTextSize
                    Label {
                        anchors.bottom: parent.bottom
                        text: qsTr("* Not changeable, yet")
                        color: appwindow.textColor1
                        font.family: "FreeSans"
                        font.pixelSize: appwindow.tinyTextSize
                    }
                }
                */

                Row {
                    Item {
                        width: 1 // dummy value != 0
                        height: appwindow.textSize
                    }
                }

                Row {
                    anchors.left: mainContent.left
                    height: appwindow.largeTextSize
                    Label {
                        text: qsTr("Variable names:")
                        color: appwindow.textColor1
                        //font.bold : true
                        font.family: "FreeSans"
                        font.pixelSize: appwindow.titleTextSize
                    }
                }

                Row {
                    anchors.left: mainContent.left
                    spacing: appwindow.textSpacingSize

                    Rectangle {
                        enabled: activeVariables >= 1
                        width: appwindow.diagramCellSize
                        height: appwindow.diagramCellSize
                        border.color: appwindow.textColor1
                        color: "transparent"
                        radius: 12
                        border.width: 4

                        TextField {
                            id: inputA
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "a"
                            placeholderText: variablePA
                            textMargin: 0
                            horizontalAlignment: TextInput.AlignHCenter
                            labelVisible: false
                            backgroundStyle: TextEditor.NoBackground
                            //backgroundStyle: TextEditor.FilledBackground
                            color: appwindow.titleTextColor
                            placeholderColor: appwindow.titleTextColor
                            font.family: "TypeWriter"
                            font.pixelSize: appwindow.largeTextSize
                            validator: RegExpValidator { regExp: /./ }
                            strictValidation: true
                            errorHighlight: false
                            onClicked: {
                                truthTableModel2.setVariableName(1,variableA)
                                truthTableModel3.setVariableName(1,variableA)
                                truthTableModel4.setVariableName(1,variableA)
                                truthTableModel5.setVariableName(1,variableA)
                                variablePA = truthTableModel5.string2html("a")
                                variableNA = truthTableModel5.string2html("*a")
                                text = ""
                            }
                        }
                    }

                    Rectangle {
                        enabled: activeVariables >= 2
                        width: appwindow.diagramCellSize
                        height: appwindow.diagramCellSize
                        border.color: appwindow.textColor1
                        color: "transparent"
                        radius: 12
                        border.width: 4

                        TextField {
                            id: inputB
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "b"
                            placeholderText: variablePB
                            textMargin: 0
                            horizontalAlignment: TextInput.AlignHCenter
                            labelVisible: false
                            backgroundStyle: TextEditor.NoBackground
                            //backgroundStyle: TextEditor.FilledBackground
                            color: appwindow.titleTextColor
                            placeholderColor: appwindow.titleTextColor
                            font.family: "TypeWriter"
                            font.pixelSize: appwindow.largeTextSize
                            validator: RegExpValidator { regExp: /./ }
                            strictValidation: true
                            errorHighlight: false
                            onClicked: {
                                truthTableModel2.setVariableName(2,variableB)
                                truthTableModel3.setVariableName(2,variableB)
                                truthTableModel4.setVariableName(2,variableB)
                                truthTableModel5.setVariableName(2,variableB)
                                variablePB = truthTableModel5.string2html("b")
                                variableNB = truthTableModel5.string2html("*b")
                                text = ""
                            }
                        }
                    }

                    Rectangle {
                        enabled: activeVariables >= 3
                        width: appwindow.diagramCellSize
                        height: appwindow.diagramCellSize
                        border.color: appwindow.textColor1
                        color: "transparent"
                        radius: 12
                        border.width: 4

                        TextField {
                            id: inputC
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "c"
                            placeholderText: variablePC
                            textMargin: 0
                            horizontalAlignment: TextInput.AlignHCenter
                            labelVisible: false
                            backgroundStyle: TextEditor.NoBackground
                            //backgroundStyle: TextEditor.FilledBackground
                            color: appwindow.titleTextColor
                            placeholderColor: appwindow.titleTextColor
                            font.family: "TypeWriter"
                            font.pixelSize: appwindow.largeTextSize
                            validator: RegExpValidator { regExp: /./ }
                            strictValidation: true
                            errorHighlight: false
                            onClicked: {
                                truthTableModel2.setVariableName(3,variableC)
                                truthTableModel3.setVariableName(3,variableC)
                                truthTableModel4.setVariableName(3,variableC)
                                truthTableModel5.setVariableName(3,variableC)
                                variablePC = truthTableModel5.string2html("c")
                                variableNC = truthTableModel5.string2html("*c")
                                text = ""
                            }
                        }
                    }

                    Rectangle {
                        enabled: activeVariables >= 4
                        width: appwindow.diagramCellSize
                        height: appwindow.diagramCellSize
                        border.color: appwindow.textColor1
                        color: "transparent"
                        radius: 12
                        border.width: 4

                        TextField {
                            id: inputD
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "d"
                            placeholderText: variablePD
                            textMargin: 0
                            horizontalAlignment: TextInput.AlignHCenter
                            labelVisible: false
                            backgroundStyle: TextEditor.NoBackground
                            //backgroundStyle: TextEditor.FilledBackground
                            color: appwindow.titleTextColor
                            placeholderColor: appwindow.titleTextColor
                            font.family: "TypeWriter"
                            font.pixelSize: appwindow.largeTextSize
                            validator: RegExpValidator { regExp: /./ }
                            strictValidation: true
                            errorHighlight: false
                            onClicked: {
                                truthTableModel2.setVariableName(4,variableD)
                                truthTableModel3.setVariableName(4,variableD)
                                truthTableModel4.setVariableName(4,variableD)
                                truthTableModel5.setVariableName(4,variableD)
                                variablePD = truthTableModel5.string2html("d")
                                variableND = truthTableModel5.string2html("*d")
                                text = ""
                            }
                        }
                    }

                    Rectangle {
                        enabled: activeVariables >= 5
                        width: appwindow.diagramCellSize
                        height: appwindow.diagramCellSize
                        border.color: appwindow.textColor1
                        color: "transparent"
                        radius: 12
                        border.width: 4

                        TextField {
                            id: inputE
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "e"
                            placeholderText: variablePE
                            textMargin: 0
                            horizontalAlignment: TextInput.AlignHCenter
                            labelVisible: false
                            backgroundStyle: TextEditor.NoBackground
                            //backgroundStyle: TextEditor.FilledBackground
                            color: appwindow.titleTextColor
                            placeholderColor: appwindow.titleTextColor
                            font.family: "TypeWriter"
                            font.pixelSize: appwindow.largeTextSize
                            validator: RegExpValidator { regExp: /./ }
                            strictValidation: true
                            errorHighlight: false
                            onClicked: {
                                truthTableModel2.setVariableName(5,variableE)
                                truthTableModel3.setVariableName(5,variableE)
                                truthTableModel4.setVariableName(5,variableE)
                                truthTableModel5.setVariableName(5,variableE)
                                variablePE = truthTableModel5.string2html("e")
                                variableNE = truthTableModel5.string2html("*e")
                                text = ""
                            }
                        }

                    }

                }

                /*
                Row {
                    anchors.left: mainContent.left
                    height: appwindow.regularTextSize
                    Label {
                        anchors.bottom: parent.bottom
                        text: qsTr("* Not changeable, yet")
                        color: appwindow.textColor1
                        font.family: "FreeSans"
                        font.pixelSize: appwindow.tinyTextSize
                    }
                }
                */

                Row {
                    id: datespace
                    property int size: Screen.height - y - date.height - appwindow.titleTextSize
                    Item {
                        width: 1 // dummy value != 0
                        height: (datespace.size < appwindow.titleTextSize) ? appwindow.titleTextSize : datespace.size
                    }
                }

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: date
                    text: version
                    color: appwindow.textColor2
                    //font.bold : true
                    font.family: "FreeSans"
                    font.pixelSize: appwindow.tinyTextSize
                }
            }
            }
        }
    }
}
