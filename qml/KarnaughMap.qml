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
import QtQml.Models 2.2
import Sailfish.Silica 1.0

Page {
    id: karnaughMapPage

    property var truthTableModel:
        (appwindow.activeVariables === 2) ? truthTableModel2 :
        (appwindow.activeVariables === 3) ? truthTableModel3 :
        (appwindow.activeVariables === 4) ? truthTableModel4 :
        (appwindow.activeVariables === 5) ? truthTableModel5 : null
    property var implicantCircleModel:
        (appwindow.activeVariables === 2) ? implicantCircleModel2 :
        (appwindow.activeVariables === 3) ? implicantCircleModel3 :
        (appwindow.activeVariables === 4) ? implicantCircleModel4 :
        (appwindow.activeVariables === 5) ? implicantCircleModel5 : null
    property var coveringTableModel:
        (appwindow.activeVariables === 2) ? coveringTableModel2 :
        (appwindow.activeVariables === 3) ? coveringTableModel3 :
        (appwindow.activeVariables === 4) ? coveringTableModel4 :
        (appwindow.activeVariables === 5) ? coveringTableModel5 : null
    property var karnaughMapModel:
        (appwindow.activeVariables === 2) ? karnaughMapModel2 :
        (appwindow.activeVariables === 3) ? karnaughMapModel3 :
        (appwindow.activeVariables === 4) ? karnaughMapModel4 :
        (appwindow.activeVariables === 5) ? karnaughMapModel5 : null
    property var karnaughGrid:
        (appwindow.activeVariables === 2) ? diagram2.karnaughGrid :
        (appwindow.activeVariables === 3) ? diagram3.karnaughGrid :
        (appwindow.activeVariables === 4) ? diagram4.karnaughGrid :
        (appwindow.activeVariables === 5) ? diagram5.karnaughGrid : null
    property var diagramBorder:
        (appwindow.activeVariables === 2) ? diagram2.diagramBorder :
        (appwindow.activeVariables === 3) ? diagram3.diagramBorder :
        (appwindow.activeVariables === 4) ? diagram4.diagramBorder :
        (appwindow.activeVariables === 5) ? diagram5.diagramBorder : null

    property int circleRadius: 40

    property var colorList: [
         "indigo", "blue", "orchid", "orange", "green", "red", "mediumturquoise", "greenyellow",
         "indigo", "blue", "orchid", "orange", "green", "red", "mediumturquoise", "greenyellow"
    ]

    onStatusChanged: {
        if (status == PageStatus.Active) {
            pageTruthTable ? pageStack.pushAttached(Qt.resolvedUrl("TruthTable.qml")) :
                pageBooleanExpression ? pageStack.pushAttached(Qt.resolvedUrl("BooleanExpression.qml")) :
                pageQM ? pageStack.pushAttached(Qt.resolvedUrl("QM.qml")) : pageStack.pushAttached(Qt.resolvedUrl("About.qml"))

            // this page was preloaded before any change on main page
            // we have to refresh all variables that can be changed on the main page
            truthTableModel.setVariableName(1,appwindow.variableA)
            variablePA = truthTableModel.string2html("a")
            variableNA = truthTableModel.string2html("*a")
            truthTableModel.setVariableName(2,appwindow.variableB)
            variablePB = truthTableModel.string2html("b")
            variableNB = truthTableModel.string2html("*b")
            truthTableModel.setVariableName(3,appwindow.variableC)
            variablePC = truthTableModel.string2html("c")
            variableNC = truthTableModel.string2html("*c")
            truthTableModel.setVariableName(4,appwindow.variableD)
            variablePD = truthTableModel.string2html("d")
            variableND = truthTableModel.string2html("*d")
            truthTableModel.setVariableName(5,appwindow.variableE)
            variablePE = truthTableModel.string2html("e")
            variableNE = truthTableModel.string2html("*e")
            coveringTableModel.sopChanged()
        }
    }

    /* WE USE C++ MODEL VIA rootContext()->setContextProperty() */

    /* ALTERNATIVELY, WE COULD USE C++ MODEL DIRECTLY VIA qmlRegisterType() */
    /* HOWEVER, THIS SOLUTION IS TRICKY FOR MULTIPLE VIEWS ON THE SAME MODEL */
    /*
    booleanFunctionModel {
        id: booleanFunctionModel
        onDataChanged: {
            console.log("booleanFunction1 onDataChanged")
        }
    }
    */

    /* ALTERNATIVELY, WE COULD USE A SIMPLE QML MODEL */
    /* AGAIN, THIS SOLUTION IS TRICKY FOR MULTIPLE VIEWS ON THE SAME MODEL */
    /*
    ListModel {
        id: booleanFunctionModel
        property string sop: "----------------"
        function createModel() {
            for (var i=1; i<=16; i++) {
                append({"display": "1"})
            }
        }
        function reportModel() {
            console.log("ListModel: (")
            for (var i=1; i<=16; i++) {
                console.log(get(i).display)
                if (i<16) console.log(",")
            }
            console.log(")")
        }
        function setZero(x) {
            console.log("ListModel(" + x + ") = 0")
            setProperty(x, "display", "0")
        }
        function setOne(x) {
            console.log("ListModel(" + x + ") = 1")
            setProperty(x, "display", "1")
        }
        function getValue(i) {
            return get(i).display
        }
        Component.onCompleted: {createModel()}
    }
    */

    SilicaFlickable {
        id: karnaughMapFlickable
        anchors.fill: parent
        contentWidth: karnaughColumn.width
        contentHeight: karnaughColumn.height
        VerticalScrollDecorator {}

        /*
        Component.onCompleted: {
            console.log("KarnaughMap: SilicaFlickable started")
        }
        */

        /*
        onFlickStarted: {
            console.log("KarnaughMap: SilicaFlickable onFlickStarted")
            if (horizontalVelocity < 0) {
                console.log("KarnaughMap: SilicaFlickable swiped right")
            }
            if (horizontalVelocity > 0) {
                console.log("KarnaughMap: SilicaFlickable swiped left")
            }
        }

        onFlickEnded: {
            console.log("KarnaughMap: SilicaFlickable onFlickEnded")
        }
        */

        PullDownMenu {
            MenuItem {
                text: qsTr("INIT 0")
                onClicked: {
                    //console.log("MENU: " + text)
                    karnaughMapModel.allZero()
                }
            }
            MenuItem {
                text: qsTr("INIT 1")
                onClicked: {
                    //console.log("MENU: " + text)
                    karnaughMapModel.allOne()
                }
            }
            MenuItem {
                text: qsTr("RANDOM")
                onClicked: {
                    //console.log("MENU: " + text)
                    karnaughMapModel.allRandom()
                }
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: karnaughColumn.width
            height: karnaughColumn.height
            gradient: Gradient {
                GradientStop { position: 0.0; color: appwindow.bgColor1 }
                GradientStop { position: 0.382; color: appwindow.bgColor2 }
                GradientStop { position: 0.618; color: appwindow.bgColor1 }
                GradientStop { position: 1.0; color: appwindow.bgColor2 }
            }

            // this defines one cell in the diagram
            Component {
                id: diagramCell

                Item {
                    id: diagramCellItem
                    width: appwindow.diagramCellSize
                    height: appwindow.diagramCellSize
                    Rectangle {
                        parent: karnaughMapPage.karnaughGrid
                        x: diagramCellItem.x;
                        y: (index >= 16) ? diagramCellItem.y + appwindow.diagramGap : diagramCellItem.y; // for 5 variables, there are two diagrams and a gap
                        width: diagramCellItem.width;
                        height: diagramCellItem.height;
                        color: appwindow.bgDiagramColor
                        border.color: appwindow.bgDiagramLegendColor
                        border.width: 1

                        Text {
                          anchors.centerIn: parent
                          text: display
                          color: appwindow.diagramTextColor
                          font.family: "FreeSans"
                          font.pixelSize: appwindow.titleTextSize
                        }

                        /*
                        Component.onCompleted: {
                            console.log("KarnaughMap: diagramCell, index = " + index + ", diagramCellItem.y = " + diagramCellItem.y + ", y = " + y)
                        }
                        */
                    }
                }
            }

            // this defines one circle
            Component {
                id: diagramCircle

                Item {
                    Rectangle {
                        property int cxx: (cx < 0) ? 0 : cx
                        property int cyy: (cy < 0) ? 0 : cy
                        property int cww: ((cx < 0) || (cx+cw > 4)) ? 1 : cw
                        property int chh: ((cy < 0) || (cy+ch > 4)) ? 1 : ch
                        color: "transparent"
                        width: cww*appwindow.diagramCellSize+2*appwindow.diagramBorderSize - 4 // fixed for 4 variables
                        height: chh*appwindow.diagramCellSize+2*appwindow.diagramBorderSize - 4 // fixed for 4 variables
                        x: karnaughMapPage.diagramBorder.x + cxx*appwindow.diagramCellSize + 2
                        y: karnaughMapPage.diagramBorder.y + cyy*appwindow.diagramCellSize + 2
                        Rectangle {
                            radius: circleRadius
                            color: "transparent"
                            border.color: index === -1 ? "transparent" : colorList[cc%colorList.length]
                            border.width: appwindow.diagramCircleBorder
                            anchors
                            {
                                left: parent.left
                                right: parent.right
                                top: parent.top
                                bottom: parent.bottom
                                topMargin    : (cy < 0) ? -40 : 0
                                bottomMargin : (cy+ch > 4) ? -40 : 0
                                leftMargin   : (cx < 0) ? -40 : 0
                                rightMargin  : (cx+cw > 4) ? -40 : 0
                            }
                        }
                    }
                }
            }

            // this defines top legend
            Component {
                id: diagramLegendTopRow

                Row {
                    Label {
                        visible: (appwindow.activeVariables === 2)
                        text: "0"
                        color: appwindow.textColor2
                        width: appwindow.diagramCellSize
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 2)
                        text: "1"
                        color: appwindow.textColor2
                        width: appwindow.diagramCellSize
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: ((appwindow.activeVariables === 3) || (appwindow.activeVariables === 4))
                        text: "00"
                        color: appwindow.textColor2
                        width: appwindow.diagramCellSize
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: ((appwindow.activeVariables === 3) || (appwindow.activeVariables === 4))
                        text: "01"
                        color: appwindow.textColor2
                        width: appwindow.diagramCellSize
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: ((appwindow.activeVariables === 3) || (appwindow.activeVariables === 4))
                        text: "11"
                        color: appwindow.textColor2
                        width: appwindow.diagramCellSize
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: ((appwindow.activeVariables === 3) || (appwindow.activeVariables === 4))
                        text: "10"
                        color: appwindow.textColor2
                        width: appwindow.diagramCellSize
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        text: "000"
                        color: appwindow.textColor2
                        width: appwindow.diagramCellSize
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        text: "001"
                        color: appwindow.textColor2
                        width: appwindow.diagramCellSize
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        text: "011"
                        color: appwindow.textColor2
                        width: appwindow.diagramCellSize
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        text: "010"
                        color: appwindow.textColor2
                        width: appwindow.diagramCellSize
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                }
            }

            // this defines second top legend for 5 variables
            Component {
                id: diagramLegendTopRow2

                Row {
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        text: "100"
                        color: appwindow.textColor2
                        width: appwindow.diagramCellSize
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        text: "101"
                        color: appwindow.textColor2
                        width: appwindow.diagramCellSize
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        text: "111"
                        color: appwindow.textColor2
                        width: appwindow.diagramCellSize
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        text: "110"
                        color: appwindow.textColor2
                        width: appwindow.diagramCellSize
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                }
            }

            // this defines bottom legend
            Component {
                id: diagramLegendBottomRow

                Row {
                    Label {
                        visible: (appwindow.activeVariables === 2)
                        width: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variableNA+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 2)
                        width: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variablePA+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: ((appwindow.activeVariables === 3) || (appwindow.activeVariables === 4))
                        width: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variableNA+' '+appwindow.variableNB+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: ((appwindow.activeVariables === 3) || (appwindow.activeVariables === 4))
                        width: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variableNA+' '+appwindow.variablePB+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: ((appwindow.activeVariables === 3) || (appwindow.activeVariables === 4))
                        width: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variablePA+' '+appwindow.variablePB+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: ((appwindow.activeVariables === 3) || (appwindow.activeVariables === 4))
                        width: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variablePA+' '+appwindow.variableNB+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        width: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variableNA+' '+appwindow.variableNB+' '+appwindow.variableNC+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        font.letterSpacing: -4
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        width: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variableNA+' '+appwindow.variableNB+' '+appwindow.variablePC+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        font.letterSpacing: -4
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        width: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variableNA+' '+appwindow.variablePB+' '+appwindow.variablePC+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        font.letterSpacing: -4
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        width: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variableNA+' '+appwindow.variablePB+' '+appwindow.variableNC+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        font.letterSpacing: -4
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                }
            }

            // this defines second bottom legend for 5 variables
            Component {
                id: diagramLegendBottomRow2

                Row {
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        width: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variablePA+' '+appwindow.variableNB+' '+appwindow.variableNC+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        font.letterSpacing: -4
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        width: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variablePA+' '+appwindow.variableNB+' '+appwindow.variablePC+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        font.letterSpacing: -4
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        width: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variablePA+' '+appwindow.variablePB+' '+appwindow.variablePC+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        font.letterSpacing: -4
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        width: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variablePA+' '+appwindow.variablePB+' '+appwindow.variableNC+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        font.letterSpacing: -4
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                }
            }

            // this defines left legend
            Component {
                id: diagramLegendLeftColumn

                Column {
                    Label {
                        visible: ((appwindow.activeVariables === 2) || (appwindow.activeVariables === 3))
                        height: appwindow.diagramCellSize
                        text: "0"
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: ((appwindow.activeVariables === 2) || (appwindow.activeVariables === 3))
                        height: appwindow.diagramCellSize
                        text: "1"
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: ((appwindow.activeVariables === 4) || (appwindow.activeVariables === 5))
                        height: appwindow.diagramCellSize
                        text: "00"
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: ((appwindow.activeVariables === 4) || (appwindow.activeVariables === 5))
                        height: appwindow.diagramCellSize
                        text: "01"
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: ((appwindow.activeVariables === 4) || (appwindow.activeVariables === 5))
                        height: appwindow.diagramCellSize
                        text: "11"
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: ((appwindow.activeVariables === 4) || (appwindow.activeVariables === 5))
                        height: appwindow.diagramCellSize
                        text: "10"
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                    }
                }
            }

            // this defines right legend
            Component {
                id: diagramLegendRightColumn

                Column {
                    Label {
                        visible: (appwindow.activeVariables === 2)
                        height: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variableNB+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 2)
                        height: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variablePB+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 3)
                        height: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variableNC+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 3)
                        height: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variablePC+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 4)
                        height: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variableNC+' '+appwindow.variableND+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 4)
                        height: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variableNC+' '+appwindow.variablePD+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 4)
                        height: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variablePC+' '+appwindow.variablePD+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 4)
                        height: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variablePC+' '+appwindow.variableND+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        height: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variableND+' '+appwindow.variableNE+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        height: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variableND+' '+appwindow.variablePE+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        height: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variablePD+' '+appwindow.variablePE+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                    Label {
                        visible: (appwindow.activeVariables === 5)
                        height: appwindow.diagramCellSize
                        text: '<font>'+appwindow.variablePD+' '+appwindow.variableNE+'</font>'
                        textFormat: Text.RichText
                        color: appwindow.textColor2
                        font.family: "TypeWriter"
                        //font.capitalization: Font.SmallCaps
                        font.pixelSize: appwindow.regularTextSize
                    }
                }
            }

            Column {
                id: karnaughColumn
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
                    text: qsTr("Karnaugh Map")
                    color: appwindow.titleTextColor
                    //font.bold : true
                    font.family: "FreeSans"
                    font.pixelSize: appwindow.titleTextSize
                }

                // KARNAUGH MAP 2x2 (2 VARIABLES)

                Item {
                    id: diagram2
                    visible: (appwindow.activeVariables === 2)
                    /*
                    visible: {
                        console.log("KarnaughMap: diagram2 reevaluating visible: "+(appwindow.activeVariables === 2))
                        return (appwindow.activeVariables === 2)
                    }
                    */
                    width: parent.width
                    height: 2*appwindow.diagramCellSize + 2*appwindow.diagramBorderSize + 2*appwindow.diagramLegendHeight // fixed for 2 variables
                    property alias karnaughGrid: karnaughGrid2
                    property alias diagramBorder: diagramBorder2

                    /*
                    Component.onCompleted: {
                        console.log("KarnaughMap: diagram2 Component.onCompleted, visible: "+visible+" ("+appwindow.activeVariables+" variables), model.rowCount()="+karnaughGrid.model.rowCount())
                        //coveringTableModel.sopChanged() // TO DO: MOVE THIS TO TOP SECTION IF NEEDED
                    }
                    */

                    // diagramBorder2 is not shown but used for positioning of other elements
                    Rectangle {
                        id: diagramBorder2
                        width: 2*appwindow.diagramCellSize + 2*appwindow.diagramBorderSize // fixed for 2 variables
                        height: 2*appwindow.diagramCellSize + 2*appwindow.diagramBorderSize // fixed for 2 variables
                        color: "transparent"
                        border.width: appwindow.diagramBorderSize
                        border.color: appwindow.bgDiagramLegendColor // use "yellow" to debug
                        //anchors.centerIn: parent
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: appwindow.diagramLegendHeight
                        z: 2 // normal 2, use 6 to debug
                    }

                    // diagramLegendTop2
                    Rectangle {
                        width: diagramBorder2.width + 2*appwindow.diagramLegendWidth
                        height: appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.bottom: diagramBorder2.top
                        anchors.horizontalCenter: diagramBorder2.horizontalCenter
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenterOffset: appwindow.diagramCellSize / 2 // fixed for 2 variables
                            sourceComponent: diagramLegendTopRow
                        }
                    }

                    // diagramLegendBottom2
                    Rectangle {
                        width: diagramBorder2.width + 2*appwindow.diagramLegendWidth
                        height: appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.top: diagramBorder2.bottom
                        anchors.horizontalCenter: diagramBorder2.horizontalCenter
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.horizontalCenterOffset: appwindow.diagramCellSize / 2 // fixed for 2 variables
                            anchors.verticalCenter: parent.verticalCenter
                            sourceComponent: diagramLegendBottomRow
                        }
                    }

                    // diagramLegendLeft2
                    Rectangle {
                        width: appwindow.diagramLegendWidth
                        height: diagramBorder2.height + 2*appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.verticalCenter: diagramBorder2.verticalCenter
                        anchors.right: diagramBorder2.left
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 // fixed for 2 variables
                            sourceComponent: diagramLegendLeftColumn
                        }
                    }

                    // diagramLegendRight2
                    Rectangle {
                        width: appwindow.diagramLegendWidth
                        height: diagramBorder2.height + 2*appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.verticalCenter: diagramBorder2.verticalCenter
                        anchors.left: diagramBorder2.right
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 // fixed for 2 variables
                            sourceComponent: diagramLegendRightColumn
                        }
                    }

                    // this defines diagram
                    GridView {
                        id: karnaughGrid2
                        cellWidth: appwindow.diagramCellSize
                        cellHeight: appwindow.diagramCellSize
                        width: 2*appwindow.diagramCellSize
                        height: 2*appwindow.diagramCellSize
                        anchors.centerIn: parent
                        model: (appwindow.activeVariables === 2) ? karnaughMapModel2 : null
                        //model: {
                        //    console.log("KarnaughMap: GridView2 reevaluating model, "+appwindow.activeVariables+" variables, model.rowCount()="+karnaughMapModel2.rowCount())
                        //    return ((appwindow.activeVariables === 2) ? karnaughMapModel2 : null)
                        //}
                        delegate: diagramCell
                        z: 2

                        Component.onCompleted: {
                            console.log("KarnaughMap: GridView2 onCompleted visible: "+visible+" ("+appwindow.activeVariables+" variables)")
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            preventStealing : false
                            property int index: parent.indexAt(mouseX, mouseY)

                            onClicked: {
                                var value = parent.model.get(index) // we have C++ Model
                                //console.log("karnaughGrid2.onClicked("+index+"/" + value + ")")
                                if (value === " ") {
                                    parent.model.setZero(index)
                                }
                                if (value === "0") {
                                    parent.model.setOne(index)
                                }
                                if (value === "1") {
                                    parent.model.setX(index)
                                }
                                if (value === "X") {
                                    parent.model.setZero(index)
                                }
                            }
                        }
                    }

                    // this defines set of circles
                    ListView {
                        model: implicantCircleModel
                        //model: {
                        //    console.log("KarnaughMap: ListView2 reevaluating model, "+appwindow.activeVariables+" variables")
                        //    return implicantCircleModel
                        //}
                        delegate: diagramCircle
                        z: 3
                    }

                }

                // KARNAUGH MAP 4x2 (3 VARIABLES)

                Item {
                    id: diagram3
                    visible: (appwindow.activeVariables === 3)
                    /*
                    visible: {
                        console.log("KarnaughMap: diagram3 reevaluating visible: "+(appwindow.activeVariables === 3))
                        return (appwindow.activeVariables === 3)
                    }
                    */
                    width: parent.width
                    height: 2*appwindow.diagramCellSize + 2*appwindow.diagramBorderSize + 2*appwindow.diagramLegendHeight // fixed for 3 variables
                    property alias karnaughGrid: karnaughGrid3
                    property alias diagramBorder: diagramBorder3

                    /*
                    Component.onCompleted: {
                        console.log("KarnaughMap: diagram3 Component.onCompleted, visible: "+visible+" ("+appwindow.activeVariables+" variables), model.rowCount()="+karnaughGrid.model.rowCount())
                        //coveringTableModel.sopChanged() // TO DO: MOVE THIS TO TOP SECTION IF NEEDED
                    }
                    */

                    // diagramBorder3 is not shown but used for positioning of other elements
                    Rectangle {
                        id: diagramBorder3
                        width: 4*appwindow.diagramCellSize + 2*appwindow.diagramBorderSize // fixed for 3 variables
                        height: 2*appwindow.diagramCellSize + 2*appwindow.diagramBorderSize // fixed for 3 variables
                        color: "transparent"
                        border.width: appwindow.diagramBorderSize
                        border.color: appwindow.bgDiagramLegendColor // use "yellow" to debug
                        //anchors.centerIn: parent
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: appwindow.diagramLegendHeight
                        z: 2 // normal 2, use 6 to debug
                    }

                    // diagramLegendTop3
                    Rectangle {
                        width: diagramBorder3.width + 2*appwindow.diagramLegendWidth
                        height: appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.bottom: diagramBorder3.top
                        anchors.horizontalCenter: diagramBorder3.horizontalCenter
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenterOffset: appwindow.diagramCellSize / 4 // fixed for 3 variables
                            sourceComponent: diagramLegendTopRow
                        }
                    }

                    // diagramLegendBottom3
                    Rectangle {
                        width: diagramBorder3.width + 2*appwindow.diagramLegendWidth
                        height: appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.top: diagramBorder3.bottom
                        anchors.horizontalCenter: diagramBorder3.horizontalCenter
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.horizontalCenterOffset: appwindow.diagramCellSize / 4 // fixed for 3 variables
                            anchors.verticalCenter: parent.verticalCenter
                            sourceComponent: diagramLegendBottomRow
                        }
                    }

                    // diagramLegendLeft3
                    Rectangle {
                        width: appwindow.diagramLegendWidth
                        height: diagramBorder3.height + 2*appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.verticalCenter: diagramBorder3.verticalCenter
                        anchors.right: diagramBorder3.left
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 // fixed for 3 variables
                            sourceComponent: diagramLegendLeftColumn
                        }
                    }

                    // diagramLegendRight3
                    Rectangle {
                        width: appwindow.diagramLegendWidth
                        height: diagramBorder3.height + 2*appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.verticalCenter: diagramBorder3.verticalCenter
                        anchors.left: diagramBorder3.right
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 // fixed for 3 variables
                            sourceComponent: diagramLegendRightColumn
                        }
                    }

                    // this defines diagram
                    GridView {
                        id: karnaughGrid3
                        cellWidth: appwindow.diagramCellSize
                        cellHeight: appwindow.diagramCellSize
                        width: 4*appwindow.diagramCellSize
                        height: 2*appwindow.diagramCellSize
                        anchors.centerIn: parent
                        model: (appwindow.activeVariables === 3) ? karnaughMapModel3 : null
                        //model: {
                        //    console.log("KarnaughMap: GridView3 reevaluating model, "+appwindow.activeVariables+" variables, model.rowCount()="+karnaughMapModel3.rowCount())
                        //    return ((appwindow.activeVariables === 3) ? karnaughMapModel3 : null)
                        //}
                        delegate: diagramCell
                        z: 2

                        Component.onCompleted: {
                            console.log("KarnaughMap: GridView3 onCompleted visible: "+visible+" ("+appwindow.activeVariables+" variables)")
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            preventStealing : false
                            property int index: parent.indexAt(mouseX, mouseY)

                            onClicked: {
                                var value = parent.model.get(index) // we have C++ Model
                                //console.log("karnaughGrid3.onClicked("+index+"/" + value + ")")
                                if (value === " ") {
                                    parent.model.setZero(index)
                                }
                                if (value === "0") {
                                    parent.model.setOne(index)
                                }
                                if (value === "1") {
                                    parent.model.setX(index)
                                }
                                if (value === "X") {
                                    parent.model.setZero(index)
                                }
                            }
                        }
                    }

                    // this defines set of circles
                    ListView {
                        model: implicantCircleModel
                        //model: {
                        //    console.log("KarnaughMap: ListView3 reevaluating model, "+appwindow.activeVariables+" variables")
                        //    return implicantCircleModel
                        //}
                        delegate: diagramCircle
                        z: 3
                    }

                }

                // KARNAUGH MAP 4x4 (4 VARIABLES)

                Item {
                    id: diagram4
                    visible: (appwindow.activeVariables === 4)
                    /*
                    visible: {
                        console.log("KarnaughMap: diagram4 reevaluating visible: "+(appwindow.activeVariables === 4))
                        return (appwindow.activeVariables === 4)
                    }
                    */

                    width: parent.width
                    height: 4*appwindow.diagramCellSize + 2*appwindow.diagramBorderSize + 2*appwindow.diagramLegendHeight // fixed for 4 variables
                    property alias karnaughGrid: karnaughGrid4
                    property alias diagramBorder: diagramBorder4

                    /**/
                    Component.onCompleted: {
                        console.log("KarnaughMap: diagram4 Component.onCompleted, visible: "+visible+" ("+appwindow.activeVariables+" variables), model.rowCount()="+karnaughGrid.model.rowCount())
                        //coveringTableModel.sopChanged() // TO DO: MOVE THIS TO TOP SECTION IF NEEDED
                    }
                    /**/

                    // diagramBorder4 is not shown but used for positioning of other elements
                    Rectangle {
                        id: diagramBorder4
                        width: 4*appwindow.diagramCellSize + 2*appwindow.diagramBorderSize // fixed for 4 variables
                        height: 4*appwindow.diagramCellSize + 2*appwindow.diagramBorderSize // fixed for 4 variables
                        color: "transparent"
                        border.width: appwindow.diagramBorderSize
                        border.color: appwindow.bgDiagramLegendColor // use "yellow" to debug
                        //anchors.centerIn: parent
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: appwindow.diagramLegendHeight
                        z: 2 // normal 2, use 6 to debug
                    }

                    // diagramLegendTop4
                    Rectangle {
                        width: diagramBorder4.width + 2*appwindow.diagramLegendWidth
                        height: appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.bottom: diagramBorder4.top
                        anchors.horizontalCenter: diagramBorder4.horizontalCenter
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenterOffset: appwindow.diagramCellSize / 4 // fixed for 4 variables
                            sourceComponent: diagramLegendTopRow
                        }
                    }

                    // diagramLegendBottom4
                    Rectangle {
                        width: diagramBorder4.width + 2*appwindow.diagramLegendWidth
                        height: appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.top: diagramBorder4.bottom
                        anchors.horizontalCenter: diagramBorder4.horizontalCenter
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.horizontalCenterOffset: appwindow.diagramCellSize / 4 // fixed for 4 variables
                            anchors.verticalCenter: parent.verticalCenter
                            sourceComponent: diagramLegendBottomRow
                        }
                    }

                    // diagramLegendLeft4
                    Rectangle {
                        width: 3 * appwindow.diagramLegendWidth / 2
                        height: diagramBorder4.height + 2*appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.verticalCenter: diagramBorder4.verticalCenter
                        anchors.right: diagramBorder4.left
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 // fixed for 4 variables
                            sourceComponent: diagramLegendLeftColumn
                        }
                    }

                    // diagramLegendRight4
                    Rectangle {
                        width: 3 * appwindow.diagramLegendWidth / 2
                        height: diagramBorder4.height + 2*appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.verticalCenter: diagramBorder4.verticalCenter
                        anchors.left: diagramBorder4.right
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 // fixed for 4 variables
                            sourceComponent: diagramLegendRightColumn
                        }
                    }

                    // this defines diagram
                    GridView {
                        id: karnaughGrid4
                        cellWidth: appwindow.diagramCellSize
                        cellHeight: appwindow.diagramCellSize
                        width: 4*appwindow.diagramCellSize
                        height: 4*appwindow.diagramCellSize
                        anchors.centerIn: parent
                        //model: (appwindow.activeVariables === 4) ? karnaughMapModel4 : null
                        model: {
                            console.log("KarnaughMap: GridView4 reevaluating model, "+appwindow.activeVariables+" variables, model.rowCount()="+karnaughMapModel4.rowCount())
                            return ((appwindow.activeVariables === 4) ? karnaughMapModel4 : null)
                        }
                        delegate: diagramCell
                        z: 2

                        Component.onCompleted: {
                            console.log("KarnaughMap: GridView4 onCompleted visible: "+visible+" ("+appwindow.activeVariables+" variables)")
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            preventStealing : false
                            property int index: parent.indexAt(mouseX, mouseY)

                            onClicked: {
                                var value = parent.model.get(index) // we have C++ Model
                                //console.log("karnaughGrid4.onClicked("+index+"/" + value + ")")
                                if (value === " ") {
                                    parent.model.setZero(index)
                                }
                                if (value === "0") {
                                    parent.model.setOne(index)
                                }
                                if (value === "1") {
                                    parent.model.setX(index)
                                }
                                if (value === "X") {
                                    parent.model.setZero(index)
                                }
                            }
                        }
                    }

                    // this defines set of circles
                    ListView {
                        model: implicantCircleModel
                        //model: {
                        //    console.log("KarnaughMap: ListView4 reevaluating model, "+appwindow.activeVariables+" variables")
                        //    return implicantCircleModel
                        //}
                        delegate: diagramCircle
                        z: 3
                    }

                }

                // KARNAUGH MAP 4x4 + 4x4 (5 VARIABLES)

                Item {
                    id: diagram5
                    //visible: (appwindow.activeVariables === 5)
                    /**/
                    visible: {
                        console.log("KarnaughMap: diagram5 reevaluating visible: "+(appwindow.activeVariables === 5))
                        return (appwindow.activeVariables === 5)
                    }
                    /**/
                    width: parent.width
                    height: 8*appwindow.diagramCellSize + 4*appwindow.diagramBorderSize + 2*appwindow.diagramLegendHeight + appwindow.diagramGap // fixed for 5 variables
                    property alias karnaughGrid: karnaughGrid5
                    property alias diagramBorder: diagramBorder5

                    /*
                    Component.onCompleted: {
                        console.log("KarnaughMap: diagram5 Component.onCompleted, visible: "+visible+" ("+appwindow.activeVariables+" variables), model.rowCount()="+karnaughGrid.model.rowCount())
                        //coveringTableModel.sopChanged() // TO DO: MOVE THIS TO TOP SECTION IF NEEDED
                    }
                    */

                    // diagramBorder5 is not shown but used for positioning of other elements
                    Rectangle {
                        id: diagramBorder5
                        width: 4*appwindow.diagramCellSize + 2*appwindow.diagramBorderSize // fixed for 5 variables
                        height: 4*appwindow.diagramCellSize + 2*appwindow.diagramBorderSize // fixed for 5 variables
                        color: "transparent"
                        border.width: appwindow.diagramBorderSize
                        border.color: appwindow.bgDiagramLegendColor // use "yellow" to debug
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: appwindow.diagramLegendHeight
                        z: 2 // normal 2, use 6 to debug
                    }

                    // diagramBorder5b is not shown but used for positioning of other elements
                    Rectangle {
                        id: diagramBorder5b
                        width: 4*appwindow.diagramCellSize + 2*appwindow.diagramBorderSize // fixed for 5 variables
                        height: 4*appwindow.diagramCellSize + 2*appwindow.diagramBorderSize // fixed for 5 variables
                        color: "transparent"
                        border.width: appwindow.diagramBorderSize
                        border.color: appwindow.bgDiagramLegendColor // use "green" to debug
                        anchors.horizontalCenter: parent.horizontalCenter
                        y: appwindow.diagramLegendHeight + 4*appwindow.diagramCellSize + appwindow.diagramGap
                        z: 2 // normal 2, use 6 to debug
                    }

                    // diagramLegendTop5
                    Rectangle {
                        width: diagramBorder5.width + 2*appwindow.diagramLegendWidth
                        height: appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.bottom: diagramBorder5.top
                        anchors.horizontalCenter: diagramBorder5.horizontalCenter
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenterOffset: appwindow.diagramCellSize / 8 // fixed for 5 variables
                            sourceComponent: diagramLegendTopRow
                        }
                    }

                    // diagramLegendTop5b
                    Rectangle {
                        width: diagramBorder5b.width + 2*appwindow.diagramLegendWidth
                        height: appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.bottom: diagramBorder5b.top
                        anchors.horizontalCenter: diagramBorder5b.horizontalCenter
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenterOffset: appwindow.diagramCellSize / 8 // fixed for 5 variables
                            sourceComponent: diagramLegendTopRow2
                        }
                    }

                    // diagramLegendBottom5
                    Rectangle {
                        width: diagramBorder5.width + 2*appwindow.diagramLegendWidth
                        height: appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.top: diagramBorder5.bottom
                        anchors.horizontalCenter: diagramBorder5.horizontalCenter
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.horizontalCenterOffset: appwindow.diagramCellSize / 10 // fixed for 5 variables
                            anchors.verticalCenter: parent.verticalCenter
                            sourceComponent: diagramLegendBottomRow
                        }
                    }

                    // diagramLegendBottom5b
                    Rectangle {
                        width: diagramBorder5b.width + 2*appwindow.diagramLegendWidth
                        height: appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.top: diagramBorder5b.bottom
                        anchors.horizontalCenter: diagramBorder5b.horizontalCenter
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.horizontalCenterOffset: appwindow.diagramCellSize / 10 // fixed for 5 variables
                            anchors.verticalCenter: parent.verticalCenter
                            sourceComponent: diagramLegendBottomRow2
                        }
                    }

                    // diagramLegendLeft5
                    Rectangle {
                        width: 3 * appwindow.diagramLegendWidth / 2
                        height: diagramBorder5.height + 2*appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.verticalCenter: diagramBorder5.verticalCenter
                        anchors.right: diagramBorder5.left
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 // fixed for 5 variables
                            sourceComponent: diagramLegendLeftColumn
                        }
                    }

                    // diagramLegendLeft5b
                    Rectangle {
                        width: 3 * appwindow.diagramLegendWidth / 2
                        height: diagramBorder5b.height + 2*appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.verticalCenter: diagramBorder5b.verticalCenter
                        anchors.right: diagramBorder5b.left
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 // fixed for 5 variables
                            sourceComponent: diagramLegendLeftColumn
                        }
                    }

                    // diagramLegendRight5
                    Rectangle {
                        width: 3 * appwindow.diagramLegendWidth / 2
                        height: diagramBorder5.height + 2*appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.verticalCenter: diagramBorder5.verticalCenter
                        anchors.left: diagramBorder5.right
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 // fixed for 5 variables
                            sourceComponent: diagramLegendRightColumn
                        }
                    }

                    // diagramLegendRight5b
                    Rectangle {
                        width: 3 * appwindow.diagramLegendWidth / 2
                        height: diagramBorder5b.height + 2*appwindow.diagramLegendHeight
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.verticalCenter: diagramBorder5b.verticalCenter
                        anchors.left: diagramBorder5b.right
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 // fixed for 5 variables
                            sourceComponent: diagramLegendRightColumn
                        }
                    }

                    // this defines diagram
                    GridView {
                        id: karnaughGrid5
                        cellWidth: appwindow.diagramCellSize
                        cellHeight: appwindow.diagramCellSize
                        width: 4*appwindow.diagramCellSize
                        height: 8*appwindow.diagramCellSize + appwindow.diagramGap
                        anchors.centerIn: parent
                        //model: (appwindow.activeVariables === 5) ? karnaughMapModel5 : null
                        /**/
                        model: {
                            console.log("KarnaughMap: GridView5 reevaluating model, "+appwindow.activeVariables+" variables, model.rowCount()="+karnaughMapModel5.rowCount())
                            return ((appwindow.activeVariables === 5) ? karnaughMapModel5 : null)
                        }
                        /**/
                        delegate: diagramCell
                        z: 2

                        Component.onCompleted: {
                            console.log("KarnaughMap: GridView5 onCompleted visible: "+visible+" ("+appwindow.activeVariables+" variables)")
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            preventStealing : false
                            property int index: (mouseY < 4*appwindow.diagramCellSize) ? parent.indexAt(mouseX, mouseY) :
                                                  (mouseY >= 4*appwindow.diagramCellSize + appwindow.diagramGap ) ? parent.indexAt(mouseX, mouseY - appwindow.diagramGap) : -1

                            onClicked: {
                                var value = parent.model.get(index) // we have C++ Model
                                //console.log("karnaughGrid5.onClicked: " + x + "/" + y + "/" + width + "/" + height)
                                //console.log("karnaughGrid5.onClicked: "+ mouseX + "/" + mouseY)
                                console.log("karnaughGrid5.onClicked("+ index + "/" + value + ")")
                                if (value === " ") {
                                    parent.model.setZero(index)
                                }
                                if (value === "0") {
                                    parent.model.setOne(index)
                                }
                                if (value === "1") {
                                    parent.model.setX(index)
                                }
                                if (value === "X") {
                                    parent.model.setZero(index)
                                }
                            }
                        }
                    }

                    // this defines set of circles
                    ListView {
                        model: implicantCircleModel
                        delegate: diagramCircle
                        z: 3
                    }

                }

                // BUTTONS TO CHANGE THE SOLUTION

                Row {
                    id: buttonrow
                    width: karnaughMapPage.width
                    anchors.horizontalCenter: karnaughColumn.horizontalCenter
                    spacing: 5 * buttonrow.width / 72

                    Item {
                        width: 5 * buttonrow.width / 72
                        height: 1 // dummy value != 0
                    }

                    Button {
                        id: buttonPrevious
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
                        text: ""
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
                            //console.log("KarnaughMap onSopChanged")
                            buttonPrevious.enabled = coveringTableModel.numSopSolutions > 1 ? true : false
                            buttonNext.enabled = coveringTableModel.numSopSolutions > 1 ? true : false
                            buttonNumSolutions.text = "<font>"+coveringTableModel.selectedSopSolution+" / "+coveringTableModel.numSopSolutions+"</font>"
                        }
                    }
                }

                // SOP

                Row {
                    Item {
                        width: 1 // dummy value != 0
                        height: appwindow.smallTextSize
                    }
                }

                Row {
                    anchors.horizontalCenter: karnaughColumn.horizontalCenter
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
                        height: appwindow.tinyTextSize
                    }
                }

                Row {
                    anchors.horizontalCenter: karnaughColumn.horizontalCenter
                    id: textrow

                    Label {
                        id: textrowSop
                        text: ""
                        textFormat: Text.RichText
                        color: appwindow.textColor1
                        font.family: "TypeWriter"
                        font.pixelSize: appwindow.regularTextSize
                        lineHeightMode: Text.ProportionalHeight
                        lineHeight: 1.2
                    }

                    Connections {
                        target: coveringTableModel
                        onSopChanged: {
                            //console.log("KarnaughMap: coveringTableModel.onSopChanged")
                            var soptext = truthTableModel.string2html(coveringTableModel.sop)
                            var idx = 0
                            while (soptext.indexOf("<span></span>") !== -1) {
                                //HTML Character Sets (https://www.w3schools.com/charsets/)
                                //INTERESTING SYMBOLS: &#9964; &#9968; &#9974;
                                //console.log(idx + ": " + colorList[idx%colorList.length])
                                soptext = soptext.replace("<span></span>","<span style=\"color:"+colorList[idx%colorList.length]+"\">&#9964; </span>")
                                idx++
                            }
                            textrowSop.text = "<font>"+soptext+"</font>"
                        }
                    }
                }

                // DEBUG

                /*
                Row {
                    id: bottomrowspace
                    property int size: Screen.height - y - bottomrow.height - appwindow.titleTextSize
                    Item {
                        width: 1 // dummy value != 0
                        height: (bottomrowspace.size < appwindow.titleTextSize) ? appwindow.titleTextSize : bottomrowspace.size
                    }
                }

                /*
                Row {
                    id: bottomrow
                    anchors.horizontalCenter: diagram.horizontalCenter
                    // spacing: 8
                    spacing: 5 * bottomrow.width / 72

                    Label {
                        text: qsTr("BITS:")
                        font.bold : true
                        font.family: "FreeSans"
                        font.pixelSize: karnaughMapPage.textSize/2-4 // just a heuristic, looks good
                    }

                    Label {
                        text: qsTr(karnaughGrid.model.bits)
                        font.family: "FreeMono"
                        font.pixelSize: karnaughMapPage.textSize/2-2 // just a heuristic, looks good
                    }
                }
                */

            } //Column
        } //Rectangle
    } //SilicaFlickable
}
