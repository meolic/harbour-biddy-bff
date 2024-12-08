import QtQuick 2.5

//import Felgo 3.0
import Sailfish.Silica 1.0

//FlickablePage { // Felgo
Page { // Sailfish OS
    //title: qsTr("Karnaugh Map") // Felgo
    id: karnaughMapPage

    //flickable.contentHeight: karnaughColumn.height // Felgo
    //flickable.contentWidth: karnaughColumn.width // Felgo
    //scrollIndicator.visible: true // Felgo

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
        (appwindow.activeVariables === 5) ? diagram5a.karnaughGrid : null
/*
    property var karnaughGridPart2:
        (appwindow.activeVariables === 2) ? null :
        (appwindow.activeVariables === 3) ? null :
        (appwindow.activeVariables === 4) ? null :
        (appwindow.activeVariables === 5) ? diagram5b.karnaughGrid : null
*/
    property var diagramBorder:
        (appwindow.activeVariables === 2) ? diagram2.diagramBorder :
        (appwindow.activeVariables === 3) ? diagram3.diagramBorder :
        (appwindow.activeVariables === 4) ? diagram4.diagramBorder :
        (appwindow.activeVariables === 5) ? diagram5a.diagramBorder : null
/*
    property var diagramBorderPart2:
        (appwindow.activeVariables === 2) ? null :
        (appwindow.activeVariables === 3) ? null :
        (appwindow.activeVariables === 4) ? null :
        (appwindow.activeVariables === 5) ? diagram5b.diagramBorder : null
*/

    property int circleRadius: 40

    property var colorList: [
         "indigo", "blue", "orchid", "orange", "green", "red", "mediumturquoise", "greenyellow",
         "indigo", "blue", "orchid", "orange", "green", "red", "mediumturquoise", "greenyellow"
    ]

    // Sailfish OS
    /**/
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
    /**/

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

    //Item { // Felgo
    SilicaFlickable { // Sailfish OS
        id: karnaughMapFlickable
        anchors.fill: parent
        contentWidth: karnaughColumn.width // Sailfish OS
        contentHeight: karnaughColumn.height // Sailfish OS
        VerticalScrollDecorator {} // Sailfish OS

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
                    //karnaughGrid.model.allZero()
                    karnaughMapModel.allZero()
                }
            }
            MenuItem {
                text: qsTr("INIT 1")
                onClicked: {
                    //console.log("MENU: " + text)
                    //karnaughGrid.model.allOne()
                    karnaughMapModel.allOne()
                }
            }
            MenuItem {
                text: qsTr("RANDOM")
                onClicked: {
                    //console.log("MENU: " + text)
                    //karnaughGrid.model.allRandom()
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

            Column {
                id: karnaughColumn
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
                    text: qsTr("Karnaugh Map")
                    color: appwindow.titleTextColor
                    //font.bold : true
                    font.family: "FreeSans"
                    font.pixelSize: appwindow.titleTextSize
                }
                /**/

                // this defines one cell in the diagram
                Component {
                    id: diagramCell

                    Item {
                        id: diagramCellItem
                        width: appwindow.diagramCellSize
                        height: appwindow.diagramCellSize
                        Rectangle {
                            id: box
                            parent: karnaughMapPage.karnaughGrid
                            x: diagramCellItem.x;
                            y: diagramCellItem.y;
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
                            //radius: 40 // use 20 on Felgo, use 40 on Sailfish OS
                            color: "transparent"
                            width: cww*appwindow.diagramCellSize+2*appwindow.diagramBorderWidth - 4 // fixed for 4 variables
                            height: chh*appwindow.diagramCellSize+2*appwindow.diagramBorderWidth - 4 // fixed for 4 variables
                            x: karnaughMapPage.diagramBorder.x + cxx*appwindow.diagramCellSize + 2
                            y: karnaughMapPage.diagramBorder.y + cyy*appwindow.diagramCellSize + 2
                            Rectangle {
                                radius: circleRadius
                                color: "transparent"
                                border.color: index === -1 ? "transparent" : colorList[cc%colorList.length]
                                border.width: appwindow.diagramCellBorder
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
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: (appwindow.activeVariables === 2)
                            text: "0"
                            color: appwindow.textColor2
                            width: appwindow.diagramCellSize
                            font.family: "TypeWriter"
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: (appwindow.activeVariables === 2)
                            text: "1"
                            color: appwindow.textColor2
                            width: appwindow.diagramCellSize
                            font.family: "TypeWriter"
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: ((appwindow.activeVariables === 3) || (appwindow.activeVariables === 4))
                            text: "00"
                            color: appwindow.textColor2
                            width: appwindow.diagramCellSize
                            font.family: "TypeWriter"
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: ((appwindow.activeVariables === 3) || (appwindow.activeVariables === 4))
                            text: "01"
                            color: appwindow.textColor2
                            width: appwindow.diagramCellSize
                            font.family: "TypeWriter"
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: ((appwindow.activeVariables === 3) || (appwindow.activeVariables === 4))
                            text: "11"
                            color: appwindow.textColor2
                            width: appwindow.diagramCellSize
                            font.family: "TypeWriter"
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: ((appwindow.activeVariables === 3) || (appwindow.activeVariables === 4))
                            text: "10"
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
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            //id: labelNA
                            visible: (appwindow.activeVariables === 2)
                            width: appwindow.diagramCellSize
                            text: '<font>'+appwindow.variableNA+'</font>'
                            textFormat: Text.RichText
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            //font.capitalization: Font.SmallCaps
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            //id: labelPA
                            visible: (appwindow.activeVariables === 2)
                            width: appwindow.diagramCellSize
                            text: '<font>'+appwindow.variablePA+'</font>'
                            textFormat: Text.RichText
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            //font.capitalization: Font.SmallCaps
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            //id: labelNAPA
                            visible: ((appwindow.activeVariables === 3) || (appwindow.activeVariables === 4))
                            width: appwindow.diagramCellSize
                            text: '<font>'+appwindow.variableNA+' '+appwindow.variableNB+'</font>'
                            textFormat: Text.RichText
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            //font.capitalization: Font.SmallCaps
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            //id: labelNAPB
                            visible: ((appwindow.activeVariables === 3) || (appwindow.activeVariables === 4))
                            width: appwindow.diagramCellSize
                            text: '<font>'+appwindow.variableNA+' '+appwindow.variablePB+'</font>'
                            textFormat: Text.RichText
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            //font.capitalization: Font.SmallCaps
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            //id: labelPAPB
                            visible: ((appwindow.activeVariables === 3) || (appwindow.activeVariables === 4))
                            width: appwindow.diagramCellSize
                            text: '<font>'+appwindow.variablePA+' '+appwindow.variablePB+'</font>'
                            textFormat: Text.RichText
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            //font.capitalization: Font.SmallCaps
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            //id: labelPANB
                            visible: ((appwindow.activeVariables === 3) || (appwindow.activeVariables === 4))
                            width: appwindow.diagramCellSize
                            text: '<font>'+appwindow.variablePA+' '+appwindow.variableNB+'</font>'
                            textFormat: Text.RichText
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            //font.capitalization: Font.SmallCaps
                            font.pixelSize: appwindow.regularTextSize
                        }
                    }
                }

                // this defines left legend
                Component {
                    id: diagramLegendLeftColumn

                    Column {
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: ((appwindow.activeVariables === 2) || (appwindow.activeVariables === 3))
                            height: appwindow.diagramCellSize
                            text: "0"
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: ((appwindow.activeVariables === 2) || (appwindow.activeVariables === 3))
                            height: appwindow.diagramCellSize
                            text: "1"
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: (appwindow.activeVariables === 4)
                            height: appwindow.diagramCellSize
                            text: "00"
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: (appwindow.activeVariables === 4)
                            height: appwindow.diagramCellSize
                            text: "01"
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: (appwindow.activeVariables === 4)
                            height: appwindow.diagramCellSize
                            text: "11"
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: (appwindow.activeVariables === 4)
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
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: (appwindow.activeVariables === 2)
                            height: appwindow.diagramCellSize
                            //width: appwindow.largeTextSize // Felgo
                            text: '<font>'+appwindow.variableNB+'</font>'
                            textFormat: Text.RichText
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            //font.capitalization: Font.SmallCaps
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: (appwindow.activeVariables === 2)
                            height: appwindow.diagramCellSize
                            //width: appwindow.largeTextSize // Felgo
                            text: '<font>'+appwindow.variablePB+'</font>'
                            textFormat: Text.RichText
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            //font.capitalization: Font.SmallCaps
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: (appwindow.activeVariables === 3)
                            height: appwindow.diagramCellSize
                            //width: appwindow.largeTextSize // Felgo
                            text: '<font>'+appwindow.variableNC+'</font>'
                            textFormat: Text.RichText
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            //font.capitalization: Font.SmallCaps
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: (appwindow.activeVariables === 3)
                            height: appwindow.diagramCellSize
                            //width: appwindow.largeTextSize // Felgo
                            text: '<font>'+appwindow.variablePC+'</font>'
                            textFormat: Text.RichText
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            //font.capitalization: Font.SmallCaps
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: (appwindow.activeVariables === 4)
                            height: appwindow.diagramCellSize
                            //width: appwindow.largeTextSize // Felgo
                            text: '<font>'+appwindow.variableNC+' '+appwindow.variableND+'</font>'
                            textFormat: Text.RichText
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            //font.capitalization: Font.SmallCaps
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: (appwindow.activeVariables === 4)
                            height: appwindow.diagramCellSize
                            //width: appwindow.largeTextSize // Felgo
                            text: '<font>'+appwindow.variableNC+' '+appwindow.variablePD+'</font>'
                            textFormat: Text.RichText
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            //font.capitalization: Font.SmallCaps
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: (appwindow.activeVariables === 4)
                            height: appwindow.diagramCellSize
                            //width: appwindow.largeTextSize // Felgo
                            text: '<font>'+appwindow.variablePC+' '+appwindow.variablePD+'</font>'
                            textFormat: Text.RichText
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            //font.capitalization: Font.SmallCaps
                            font.pixelSize: appwindow.regularTextSize
                        }
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            visible: (appwindow.activeVariables === 4)
                            height: appwindow.diagramCellSize
                            //width: appwindow.largeTextSize // Felgo
                            text: '<font>'+appwindow.variablePC+' '+appwindow.variableND+'</font>'
                            textFormat: Text.RichText
                            color: appwindow.textColor2
                            font.family: "TypeWriter"
                            //font.capitalization: Font.SmallCaps
                            font.pixelSize: appwindow.regularTextSize
                        }
                    }
                }

                // KARNAUGH MAP 2x2 (2 VARIABLES)

                Item {
                    id: diagram2
                    //visible: (appwindow.activeVariables === 2)
                    visible: {
                        console.log("KarnaughMap: diagram2 reevaluating visible: "+(appwindow.activeVariables === 2))
                        return (appwindow.activeVariables === 2)
                    }
                    width: parent.width
                    height: 2*appwindow.diagramCellSize + 2*appwindow.diagramBorderWidth + 2*appwindow.diagramCellSize
                    property alias karnaughGrid: karnaughGrid2
                    property alias diagramBorder: diagramBorder2

                    /*
                    Component.onCompleted: {
                        console.log("KarnaughMap: diagram2 Component.onCompleted, visible: "+visible+" ("+appwindow.activeVariables+" variables), model.rowCount()="+karnaughGrid2.model.rowCount())
                    }
                    */

                    // diagramBorder2 is not shown but used for positioning of other elements
                    Rectangle {
                        id: diagramBorder2
                        width: 2*appwindow.diagramCellSize + 2*appwindow.diagramBorderWidth // fixed for 2 variables
                        height: 2*appwindow.diagramCellSize + 2*appwindow.diagramBorderWidth // fixed for 2 variables
                        color: "transparent"
                        border.width: appwindow.diagramBorderWidth
                        border.color: appwindow.bgDiagramLegendColor
                        anchors.centerIn: parent
                        z: 2 // use 6 to debug
                    }

                    // diagramLegendTop2
                    Rectangle {
                        width: 2*appwindow.diagramCellSize+2*appwindow.diagramBorderWidth + 60 // fixed for 2 variables
                        height: appwindow.largeTextSize // (karnaughMapPage.cellSize * 2) / 3
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.bottom: diagramBorder2.top
                        anchors.horizontalCenter: diagramBorder2.horizontalCenter
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenterOffset: appwindow.diagramCellSize / 4 - 4
                            sourceComponent: diagramLegendTopRow
                        }
                    }

                    // diagramLegendBottom2
                    Rectangle {
                        width: 2*appwindow.diagramCellSize+2*appwindow.diagramBorderWidth + 60 // fixed for 2 variables
                        height: appwindow.largeTextSize // (karnaughMapPage.cellSize * 2) / 3
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.top: diagramBorder2.bottom
                        anchors.horizontalCenter: diagramBorder2.horizontalCenter
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.horizontalCenterOffset: appwindow.diagramCellSize / 4 // fixed for 2 variables
                            anchors.verticalCenter: parent.verticalCenter
                            sourceComponent: diagramLegendBottomRow
                        }
                    }

                    // diagramLegendLeft2
                    Rectangle {
                        width: appwindow.largeTextSize // (karnaughMapPage.cellSize * 2) / 3
                        height: 2*appwindow.diagramCellSize+2*appwindow.diagramBorderWidth + 60 // fixed for 2 variables
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.verticalCenter: diagramBorder2.verticalCenter
                        anchors.right: diagramBorder2.left
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            //anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 - 12 // Felgo // fixed for 3 variables
                            anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 // Sailfish OS // fixed for 3 variables
                            sourceComponent: diagramLegendLeftColumn
                        }
                    }

                    // diagramLegendRight2
                    Rectangle {
                        width: appwindow.largeTextSize // (karnaughMapPage.cellSize * 2) / 3
                        height: 2*appwindow.diagramCellSize+2*appwindow.diagramBorderWidth + 60 // fixed for 2 variables
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.verticalCenter: diagramBorder2.verticalCenter
                        anchors.left: diagramBorder2.right
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            //anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 - 12 // Felgo // fixed for 3 variables
                            anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 + 8 // Sailfish OS // fixed for 3 variables
                            sourceComponent: diagramLegendRightColumn
                        }
                    }

                    // this defines diagram
                    GridView {
                        id: karnaughGrid2
                        cellWidth: appwindow.diagramCellSize
                        cellHeight: appwindow.diagramCellSize
                        width: 2*cellWidth
                        height: 2*cellHeight
                        anchors.centerIn: parent
                        model: (appwindow.activeVariables === 2) ? karnaughMapModel2 : null
                        //model: {
                        //    console.log("KarnaughMap: GridView2 reevaluating model, "+appwindow.activeVariables+" variables, model.rowCount()="+karnaughMapModel2.rowCount())
                        //    return karnaughMapModel2
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
                                var value = parent.model.get(index) // use this for C++ Model
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
                    //visible: (appwindow.activeVariables === 3)
                    visible: {
                        console.log("KarnaughMap: diagram3 reevaluating visible: "+(appwindow.activeVariables === 3))
                        return (appwindow.activeVariables === 3)
                    }
                    width: parent.width
                    height: 2*appwindow.diagramCellSize + 2*appwindow.diagramBorderWidth + 2*appwindow.diagramCellSize
                    property alias karnaughGrid: karnaughGrid3
                    property alias diagramBorder: diagramBorder3

                    /*
                    Component.onCompleted: {
                        console.log("KarnaughMap: diagram3 Component.onCompleted, visible: "+visible+" ("+appwindow.activeVariables+" variables), model.rowCount()="+karnaughGrid3.model.rowCount())
                    }
                    */

                    // diagramBorder3 is not shown but used for positioning of other elements
                    Rectangle {
                        id: diagramBorder3
                        width: 4*appwindow.diagramCellSize + 2*appwindow.diagramBorderWidth // fixed for 3 variables
                        height: 2*appwindow.diagramCellSize + 2*appwindow.diagramBorderWidth // fixed for 3 variables
                        color: "transparent"
                        border.width: appwindow.diagramBorderWidth
                        border.color: appwindow.bgDiagramLegendColor
                        anchors.centerIn: parent
                        z: 2 // use 6 to debug
                    }

                    // diagramLegendTop3
                    Rectangle {
                        width: 4*appwindow.diagramCellSize+2*appwindow.diagramBorderWidth + 60 // fixed for 3 variables
                        height: appwindow.largeTextSize // (karnaughMapPage.cellSize * 2) / 3
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.bottom: diagramBorder3.top
                        anchors.horizontalCenter: diagramBorder3.horizontalCenter
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenterOffset: appwindow.diagramCellSize / 4 - 4
                            sourceComponent: diagramLegendTopRow
                        }
                    }

                    // diagramLegendBottom3
                    Rectangle {
                        width: 4*appwindow.diagramCellSize+2*appwindow.diagramBorderWidth + 60 // fixed for 3 variables
                        height: appwindow.largeTextSize // (karnaughMapPage.cellSize * 2) / 3
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
                        width: appwindow.largeTextSize // (karnaughMapPage.cellSize * 2) / 3
                        height: 2*appwindow.diagramCellSize+2*appwindow.diagramBorderWidth + 60 // fixed for 3 variables
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.verticalCenter: diagramBorder3.verticalCenter
                        anchors.right: diagramBorder3.left
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            //anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 - 12 // Felgo // fixed for 3 variables
                            anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 // Sailfish OS // fixed for 3 variables
                            sourceComponent: diagramLegendLeftColumn
                        }
                    }

                    // diagramLegendRight3
                    Rectangle {
                        width: appwindow.largeTextSize // (karnaughMapPage.cellSize * 2) / 3
                        height: 2*appwindow.diagramCellSize+2*appwindow.diagramBorderWidth + 60 // fixed for 3 variables
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.verticalCenter: diagramBorder3.verticalCenter
                        anchors.left: diagramBorder3.right
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            //anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 - 12 // Felgo // fixed for 3 variables
                            anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 + 8 // Sailfish OS // fixed for 3 variables
                            sourceComponent: diagramLegendRightColumn
                        }
                    }

                    // this defines diagram
                    GridView {
                        id: karnaughGrid3
                        cellWidth: appwindow.diagramCellSize
                        cellHeight: appwindow.diagramCellSize
                        width: 4*cellWidth
                        height: 2*cellHeight
                        anchors.centerIn: parent
                        model: (appwindow.activeVariables === 3) ? karnaughMapModel3 : null
                        //model: {
                        //    console.log("KarnaughMap: GridView3 reevaluating model, "+appwindow.activeVariables+" variables, model.rowCount()="+karnaughMapModel3.rowCount())
                        //    return karnaughMapModel3
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
                                var value = parent.model.get(index) // use this for C++ Model
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
                    //visible: (appwindow.activeVariables === 4)
                    visible: {
                        console.log("KarnaughMap: diagram4 reevaluating visible: "+(appwindow.activeVariables === 4))
                        return (appwindow.activeVariables === 4)
                    }
                    width: parent.width
                    height: 4*appwindow.diagramCellSize + 2*appwindow.diagramBorderWidth + 2*appwindow.diagramCellSize
                    property alias karnaughGrid: karnaughGrid4
                    property alias diagramBorder: diagramBorder4

                    /*
                    Component.onCompleted: {
                        console.log("KarnaughMap: diagram4 Component.onCompleted, visible: "+visible+" ("+appwindow.activeVariables+" variables), model.rowCount()="+karnaughGrid4.model.rowCount())
                        //coveringTableModel.sopChanged() // TO DO: MOVE THIS TO TOP SECTION IF NEEDED
                    }
                    */

                    // diagramBorder is not shown but used for positioning of other elements
                    Rectangle {
                        id: diagramBorder4
                        width: 4*appwindow.diagramCellSize + 2*appwindow.diagramBorderWidth // fixed for 4 variables
                        height: 4*appwindow.diagramCellSize + 2*appwindow.diagramBorderWidth // fixed for 4 variables
                        color: "transparent"
                        border.width: appwindow.diagramBorderWidth
                        border.color: appwindow.bgDiagramLegendColor
                        anchors.centerIn: parent
                        z: 2 // use 6 to debug
                    }

                    // diagramLegendTop4
                    Rectangle {
                        width: 4*appwindow.diagramCellSize+2*appwindow.diagramBorderWidth + 60 // fixed for 4 variables
                        height: appwindow.largeTextSize // (karnaughMapPage.cellSize * 2) / 3
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.bottom: diagramBorder4.top
                        anchors.horizontalCenter: diagramBorder4.horizontalCenter
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenterOffset: appwindow.diagramCellSize / 4 - 4 // fixed for 4 variables
                            sourceComponent: diagramLegendTopRow
                        }
                    }

                    // diagramLegendBottom4
                    Rectangle {
                        width: 4*appwindow.diagramCellSize+2*appwindow.diagramBorderWidth + 60 // fixed for 4 variables
                        height: appwindow.largeTextSize // (karnaughMapPage.cellSize * 2) / 3
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
                        width: appwindow.largeTextSize // (karnaughMapPage.cellSize * 2) / 3
                        height: 4*appwindow.diagramCellSize+2*appwindow.diagramBorderWidth + 60 // fixed for 4 variables
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.verticalCenter: diagramBorder4.verticalCenter
                        anchors.right: diagramBorder4.left
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            //anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 - 12 // Felgo // fixed for 4 variables
                            anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 // Sailfish OS // fixed for 4 variables
                            sourceComponent: diagramLegendLeftColumn
                        }
                    }

                    // diagramLegendRight4
                    Rectangle {
                        width: appwindow.largeTextSize // (karnaughMapPage.cellSize * 2) / 3
                        height: 4*appwindow.diagramCellSize+2*appwindow.diagramBorderWidth + 60 // fixed for 4 variables
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.verticalCenter: diagramBorder4.verticalCenter
                        anchors.left: diagramBorder4.right
                        z: 4

                        Loader {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            //anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 - 12 // Felgo // fixed for 4 variables
                            anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 + 8 // Sailfish OS // fixed for 4 variables
                            sourceComponent: diagramLegendRightColumn
                        }
                    }

                    // this defines diagram
                    GridView {
                        id: karnaughGrid4
                        cellWidth: appwindow.diagramCellSize
                        cellHeight: appwindow.diagramCellSize
                        width: 4*cellWidth
                        height: 4*cellHeight
                        anchors.centerIn: parent
                        model: (appwindow.activeVariables === 4) ? karnaughMapModel4 : null
                        //model: {
                        //    console.log("KarnaughMap: GridView4 reevaluating model, "+appwindow.activeVariables+" variables, model.rowCount()="+karnaughMapModel4.rowCount())
                        //    return karnaughMapModel4
                        //}
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
                                var value = parent.model.get(index) // use this for C++ Model
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
                    id: diagram5a
                    //visible: (appwindow.activeVariables === 5)
                    visible: {
                        console.log("KarnaughMap: diagram5a reevaluating visible: "+(appwindow.activeVariables === 5))
                        return (appwindow.activeVariables === 5)
                    }
                    width: parent.width
                    height: 4*appwindow.diagramCellSize + 2*appwindow.diagramBorderWidth + 2*appwindow.diagramCellSize
                    property alias karnaughGrid: karnaughGrid5a
                    property alias diagramBorder: diagramBorder5a

                    /*
                    Component.onCompleted: {
                        console.log("KarnaughMap: diagram5a Component.onCompleted, visible: "+visible+" ("+appwindow.activeVariables+" variables), model.rowCount()="+karnaughGrid5a.model.rowCount())
                    }
                    */

                    // diagramBorder is not shown but used for positioning of other elements
                    Rectangle {
                        id: diagramBorder5a
                    }

                    // this defines diagram
                    GridView {
                        id: karnaughGrid5a
                        cellWidth: appwindow.diagramCellSize
                        cellHeight: appwindow.diagramCellSize
                        width: 4*cellWidth
                        height: 4*cellHeight
                        anchors.centerIn: parent
                        model: (appwindow.activeVariables === 5) ? karnaughMapModel5 : null
                        //model: {
                        //    console.log("KarnaughMap: GridView5a reevaluating model, "+appwindow.activeVariables+" variables, model.rowCount()="+karnaughMapModel5.rowCount())
                        //    return karnaughMapModel5
                        //}
                        delegate: diagramCell
                        z: 2

                        Component.onCompleted: {
                            console.log("KarnaughMap: GridView5a onCompleted visible: "+visible+" ("+appwindow.activeVariables+" variables)")
                        }
                    }

                    // this defines set of circles
                    ListView {
                        model: implicantCircleModel
                        delegate: diagramCircle
                        z: 3
                    }

                }

/*
                Item {
                    id: diagram5b
                    //visible: (appwindow.activeVariables === 5)
                    visible: {
                        console.log("KarnaughMap: diagram5b reevaluating visible: "+(appwindow.activeVariables === 5))
                        return (appwindow.activeVariables === 5)
                    }
                    width: parent.width
                    height: 4*appwindow.diagramCellSize + 2*appwindow.diagramBorderWidth + 2*appwindow.diagramCellSize
                    property alias karnaughGrid: karnaughGrid5b
                    property alias diagramBorder: diagramBorder5b

                    Component.onCompleted: {
                        console.log("KarnaughMap: diagram5b Component.onCompleted, visible: "+visible+" ("+appwindow.activeVariables+" variables), model.rowCount()="+karnaughGrid5b.model.rowCount())
                    }

                    // diagramBorder is not shown but used for positioning of other elements
                    Rectangle {
                        id: diagramBorder5b
                    }

                    // this defines diagram
                    GridView {
                        id: karnaughGrid5b
                        cellWidth: appwindow.diagramCellSize
                        cellHeight: appwindow.diagramCellSize
                        width: 4*cellWidth
                        height: 4*cellHeight
                        anchors.centerIn: parent
                        model: (appwindow.activeVariables === 5) ? karnaughMapModel5 : null
                        //model: {
                        //    console.log("KarnaughMap: GridView5b reevaluating model, "+appwindow.activeVariables+" variables, model.rowCount()="+karnaughMapModel5.rowCount())
                        //    return karnaughMapModel5
                        //}
                        delegate: diagramCell
                        z: 2

                        Component.onCompleted: {
                            console.log("KarnaughMap: GridView5b onCompleted visible: "+visible)
                        }
                    }

                    // this defines set of circles
                    ListView {
                        model: implicantCircleModel
                        delegate: diagramCircle
                        z: 3
                    }
                }
*/

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

                    // StyledButton { // Felgo
                    Button { // Sailfish OS
                        id: buttonPrevious
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
                        text: ""
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
                        height: appwindow.tinyTextSize
                    }
                }

                Row {
                    anchors.horizontalCenter: karnaughColumn.horizontalCenter
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
                    //property int size: appwindow.screenHeight - y - bottomrow.height - karnaughMapPage.textSize / 2 // Felgo
                    property int size: Screen.height - y - bottomrow.height - appwindow.titleTextSize // Sailfish OS
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

                    // AppText { // Felgo
                    Label { // Sailfish OS
                        text: qsTr("BITS:")
                        font.bold : true
                        font.family: "FreeSans"
                        font.pixelSize: karnaughMapPage.textSize/2-4 // just a heuristic, looks good
                    }

                    // AppText { // Felgo
                    Label { // Sailfish OS
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
