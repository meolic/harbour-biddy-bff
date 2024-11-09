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
                    karnaughGrid.model.allZero()
                }
            }
            MenuItem {
                text: qsTr("INIT 1")
                onClicked: {
                    //console.log("MENU: " + text)
                    karnaughGrid.model.allOne()
                }
            }
            MenuItem {
                text: qsTr("RANDOM")
                onClicked: {
                    //console.log("MENU: " + text)
                    karnaughGrid.model.allRandom()
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

                // KARNAUGH MAP 4x4

                Item {
                    id: diagram
                    width: parent.width
                    height: 4*appwindow.diagramCellSize + 2*appwindow.diagramBorderWidth + 2*appwindow.diagramCellSize

                    /*
                    Component.onCompleted: {
                        console.log("KarnaughMap: diagram started")
                    }
                    */

                    // diagramBorder is now shown but used for positioning of other elements
                    Rectangle {
                        id: diagramBorder
                        width: 4*appwindow.diagramCellSize + 2*appwindow.diagramBorderWidth // fixed for 4 variables
                        height: 4*appwindow.diagramCellSize + 2*appwindow.diagramBorderWidth // fixed for 4 variables
                        color: "transparent"
                        border.width: appwindow.diagramBorderWidth
                        border.color: appwindow.bgDiagramLegendColor
                        anchors.centerIn: parent
                        z: 2 // use 6 to debug
                    }

                    Rectangle {
                        id: diagramLegendTop
                        width: 4*appwindow.diagramCellSize+2*appwindow.diagramBorderWidth + 60 // fixed for 4 variables
                        height: appwindow.largeTextSize // (karnaughMapPage.cellSize * 2) / 3
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.bottom: diagramBorder.top
                        anchors.horizontalCenter: diagramBorder.horizontalCenter
                        z: 4

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenterOffset: appwindow.diagramCellSize / 4 - 4 // fixed for 4 variables
                            // AppText { // Felgo
                            Label { // Sailfish OS
                                text: "00"
                                color: appwindow.textColor2
                                width: appwindow.diagramCellSize
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                            // AppText { // Felgo
                            Label { // Sailfish OS
                                text: "01"
                                color: appwindow.textColor2
                                width: appwindow.diagramCellSize
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                            // AppText { // Felgo
                            Label { // Sailfish OS
                                text: "11"
                                color: appwindow.textColor2
                                width: appwindow.diagramCellSize
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                            // AppText { // Felgo
                            Label { // Sailfish OS
                                text: "10"
                                color: appwindow.textColor2
                                width: appwindow.diagramCellSize
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                        }
                    }

                    // diagramLegendBottom
                    Rectangle {
                        id: diagramLegendBottom
                        width: 4*appwindow.diagramCellSize+2*appwindow.diagramBorderWidth + 60 // fixed for 4 variables
                        height: appwindow.largeTextSize // (karnaughMapPage.cellSize * 2) / 3
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.top: diagramBorder.bottom
                        anchors.horizontalCenter: diagramBorder.horizontalCenter
                        z: 4

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.horizontalCenterOffset: appwindow.diagramCellSize / 4 // fixed for 4 variables
                            anchors.verticalCenter: parent.verticalCenter
                            // AppText { // Felgo
                            Label { // Sailfish OS
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
                                id: labelNAPB
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
                                id: labelPAPB
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
                                id: labelPANB
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

                    // diagramLegendLeft
                    Rectangle {
                        id: diagramLegendLeft
                        width: appwindow.largeTextSize // (karnaughMapPage.cellSize * 2) / 3
                        height: 4*appwindow.diagramCellSize+2*appwindow.diagramBorderWidth + 60 // fixed for 4 variables
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.verticalCenter: diagramBorder.verticalCenter
                        anchors.right: diagramBorder.left
                        z: 4

                        Column {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            //anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 - 12 // Felgo // fixed for 4 variables
                            anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 // Sailfish OS // fixed for 4 variables
                            // AppText { // Felgo
                            Label { // Sailfish OS
                                height: appwindow.diagramCellSize
                                text: "00"
                                color: appwindow.textColor2
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                            // AppText { // Felgo
                            Label { // Sailfish OS
                                height: appwindow.diagramCellSize
                                text: "01"
                                color: appwindow.textColor2
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                            // AppText { // Felgo
                            Label { // Sailfish OS
                                height: appwindow.diagramCellSize
                                text: "11"
                                color: appwindow.textColor2
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                            // AppText { // Felgo
                            Label { // Sailfish OS
                                height: appwindow.diagramCellSize
                                text: "10"
                                color: appwindow.textColor2
                                font.family: "TypeWriter"
                                font.pixelSize: appwindow.regularTextSize
                            }
                        }
                    }

                    // diagramLegendRight
                    Rectangle {
                        id: diagramLegendRight
                        width: appwindow.largeTextSize // (karnaughMapPage.cellSize * 2) / 3
                        height: 4*appwindow.diagramCellSize+2*appwindow.diagramBorderWidth + 60 // fixed for 4 variables
                        radius: circleRadius
                        color: appwindow.bgDiagramLegendColor
                        anchors.verticalCenter: diagramBorder.verticalCenter
                        anchors.left: diagramBorder.right
                        z: 4

                        Column {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            //anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 - 12 // Felgo // fixed for 4 variables
                            anchors.verticalCenterOffset: appwindow.diagramCellSize / 4 + 8 // Sailfish OS // fixed for 4 variables
                            // AppText { // Felgo
                            Label { // Sailfish OS
                                id: labelNCND
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
                                id: labelNCPD
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
                                id: labelPCPD
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
                                id: labelPCND
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

                    // this defines one cell in the diagram
                    Component {
                        id: diagramCell

                        Item {
                            id: diagramCellItem
                            width: appwindow.diagramCellSize
                            height: appwindow.diagramCellSize
                            Rectangle {
                                id: box
                                parent: karnaughGrid
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
                                x: diagramBorder.x + cxx*appwindow.diagramCellSize + 2
                                y: diagramBorder.y + cyy*appwindow.diagramCellSize + 2
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

                    // this defines diagram
                    GridView {
                        id: karnaughGrid
                        cellWidth: appwindow.diagramCellSize
                        cellHeight: appwindow.diagramCellSize
                        width: 4*cellWidth
                        height: 4*cellHeight
                        anchors.centerIn: parent
                        model: karnaughMapModel
                        delegate: diagramCell
                        z: 2

                        MouseArea {
                            id: gridArea
                            anchors.fill: parent
                            hoverEnabled: true
                            preventStealing : false
                            property int index: karnaughGrid.indexAt(mouseX, mouseY)

                            onClicked: {
                                var value = karnaughGrid.model.get(index) // use this for C++ Model
                                //var value = karnaughGrid.model.get(index).display // use this for QML ListModel
                                //console.log("karnaughGrid.onClicked("+index+"/" + value + ")")
                                if (value === " ") {
                                    karnaughGrid.model.setZero(index)
                                }
                                if (value === "0") {
                                    karnaughGrid.model.setOne(index)
                                }
                                if (value === "1") {
                                    karnaughGrid.model.setX(index)
                                }
                                if (value === "X") {
                                    karnaughGrid.model.setZero(index)
                                }
                            }
                        }
                    }

                    // this defines set of circles
                    ListView {
                        id: circleSet
                        model: implicantCircleModel
                        delegate: diagramCircle
                        z: 3
                    }

                    Component.onCompleted: {
                        //console.log("KarnaughMap diagram: Component.onCompleted")
                        coveringTableModel.sopChanged()
                    }

                }

                // BUTTONS TO CHANGE THE SOLUTION

                Row {
                    id: buttonrow
                    width: karnaughMapPage.width
                    anchors.horizontalCenter: diagram.horizontalCenter
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
                    anchors.horizontalCenter: diagram.horizontalCenter
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
                    anchors.horizontalCenter: diagram.horizontalCenter
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
