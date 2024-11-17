import QtQuick 2.5

//import Felgo 3.0
import Sailfish.Silica 1.0

// FELGO
// You get free licenseKeys from https://felgo.com/licenseKey
// With a licenseKey you can:
//  * Publish your games & apps for the app stores
//  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
//  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
//licenseKey: "<generate one from https://felgo.com/licenseKey>"

// App // Felgo
ApplicationWindow // Sailfish OS
{
    id: appwindow
    cover: Qt.resolvedUrl("cover/CoverPage.qml") // Sailfish OS
    allowedOrientations: defaultAllowedOrientations // Sailfish OS

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

    property string version: "v2024-11-17"

    property int myScreenHeight: _screenHeight
    property int myScreenWidth: _screenWidth

    property int diagramCellSize: myScreenWidth / 9 // use 60 on Felgo, use 120 on XA2
    property int diagramCellBorder: 8 // // use 4 on Felgo, use 8 on Sailfish OS
    property int diagramBorderWidth: 2 // // use 2 on Felgo, use 2 on Sailfish OS
    property int tableRowSize: 60 // use 30 on Felgo, use 60 on Sailfish OS
    property int textSpacingSize: 8 // use 8 on Felgo, use 8 on Sailfish OS

    property int textSize: diagramCellSize
    property int logoTextSize: textSize
    property int largeTextSize: textSize * 2 / 3
    property int titleTextSize: textSize / 2
    property int regularTextSize: textSize * 2 / 5
    property int smallTextSize: textSize / 3
    property int tinyTextSize: textSize / 4

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

    property int numVariables: 4 // TO DO

    // VARIABLE NAMES

    property string variableA: inputA.text
    property string variableB: inputB.text
    property string variableC: inputC.text
    property string variableD: inputD.text
    property string variableE: inputE.text
    property string variablePA: truthTableModel.string2html("a")
    property string variablePB: truthTableModel.string2html("b")
    property string variablePC: truthTableModel.string2html("c")
    property string variablePD: truthTableModel.string2html("d")
    property string variablePE: truthTableModel.string2html("e")
    property string variableNA: truthTableModel.string2html("*a")
    property string variableNB: truthTableModel.string2html("*b")
    property string variableNC: truthTableModel.string2html("*c")
    property string variableND: truthTableModel.string2html("*d")
    property string variableNE: truthTableModel.string2html("*e")

    //x: Theme.horizontalPageMargin
    //color: Theme.secondaryHighlightColor
    //font.pixelSize: Theme.fontSizeExtraLarge

    Component.onCompleted: {
        karnaughMapModel.allZero()
        pageStack.push(mainPage,{ },PageStackAction.Immediate) // Sailfish OS
        pageKarnaughMap ? pageStack.pushAttached(Qt.resolvedUrl("KarnaughMap.qml")) :
            pageTruthTable ? pageStack.pushAttached(Qt.resolvedUrl("TruthTable.qml")) :
            pageBooleanExpression ? pageStack.pushAttached(Qt.resolvedUrl("BooleanExpression.qml")) :
            pageQM ? pageStack.pushAttached(Qt.resolvedUrl("QM.qml")) : pageStack.pushAttached(Qt.resolvedUrl("About.qml"))
    }

    // NavigationStack { // Felgo

    Page {
        //navigationBarHidden: true // Felgo
        id: mainPage

        //Item { // Felgo
        SilicaFlickable { // Sailfish OS
            anchors.fill: parent
            contentHeight: mainColumn.height // Sailfish OS
            contentWidth: mainColumn.width // Sailfish OS
            VerticalScrollDecorator {} // Sailfish OS

            /**/
            Component.onCompleted: {
                console.log("Main: SilicaFlickable started")
                console.log("Main: myScreenHeight = " + myScreenHeight)
                console.log("Main: myScreenWidth = " + myScreenWidth)
                console.log("Main: numVariables = " + numVariables)
            }
            /**/

            // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
            // Sailfish OS
            /**/
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

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter

                    /*
                    Image {
                        id: logo
                        source: "bff.png"
                    }
                    */

                    // AppText { // Felgo
                    Label { // Sailfish OS
                        //anchors.bottom: logo.bottom
                        text: qsTr("BFF")
                        color: appwindow.titleTextColor
                        font.bold : true
                        font.family: "FreeSans"
                        font.pixelSize: appwindow.logoTextSize
                    }
                }

                // AppText { // Felgo
                Label { // Sailfish OS
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
                    // AppText { // Felgo
                    Label { // Sailfish OS
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

                        // AppText { // Felgo
                        Label { // Sailfish OS
                            id: plusKarnaughMap
                            anchors.centerIn: parent
                            z: 4
                            text: pageKarnaughMap ? "+" : "-"
                            color: pageKarnaughMap ? appwindow.titleTextColor : appwindow.disabledTextColor
                            font.bold: pageKarnaughMap ? true : false
                            font.family: "FreeSans"
                            font.pixelSize: appwindow.regularTextSize
                        }

                        // StyledButton { // Felgo
                        Button { // Sailfish OS
                            anchors.fill: parent
                            z: 2
                            clip: true
                            // text: "X" // DEBUG
                            // color: "yellow" // DEBUG
                            // border.color: "yellow" // DEBUG
                            color: "transparent"
                            highlightBackgroundColor: appwindow.textColor2 // Sailfish OS
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

                    // AppText { // Felgo
                    Label { // Sailfish OS
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

                        // AppText { // Felgo
                        Label { // Sailfish OS
                            id: plusTruthTable
                            anchors.centerIn: parent
                            z: 4
                            text: pageTruthTable ? "+" : "-"
                            color: pageTruthTable ? appwindow.titleTextColor : appwindow.disabledTextColor
                            font.bold: pageTruthTable ? true : false
                            font.family: "FreeSans"
                            font.pixelSize: appwindow.regularTextSize
                        }

                        // StyledButton { // Felgo
                        Button { // Sailfish OS
                            anchors.fill: parent
                            z: 2
                            clip: true
                            // text: "X" // DEBUG
                            // color: "yellow" // DEBUG
                            // border.color: "yellow" // DEBUG
                            color: "transparent"
                            highlightBackgroundColor: appwindow.textColor2 // Sailfish OS
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

                    // AppText { // Felgo
                    Label { // Sailfish OS
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

                        // AppText { // Felgo
                        Label { // Sailfish OS
                            id: plusBooleanExpression
                            anchors.centerIn: parent
                            z: 4
                            text: pageBooleanExpression ? "+" : "-"
                            color: pageBooleanExpression ? appwindow.titleTextColor : appwindow.disabledTextColor
                            font.bold: pageBooleanExpression ? true : false
                            font.family: "FreeSans"
                            font.pixelSize: appwindow.regularTextSize
                        }

                        // StyledButton { // Felgo
                        Button { // Sailfish OS
                            anchors.fill: parent
                            z: 2
                            clip: true
                            // text: "X" // DEBUG
                            // color: "yellow" // DEBUG
                            // border.color: "yellow" // DEBUG
                            color: "transparent"
                            highlightBackgroundColor: appwindow.textColor2 // Sailfish OS
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

                    // AppText { // Felgo
                    Label { // Sailfish OS
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

                        // AppText { // Felgo
                        Label { // Sailfish OS
                            id: plusQM
                            anchors.centerIn: parent
                            z: 4
                            text: pageQM ? "+" : "-"
                            color: pageQM ? appwindow.titleTextColor : appwindow.disabledTextColor
                            font.bold: pageQM ? true : false
                            font.family: "FreeSans"
                            font.pixelSize: appwindow.regularTextSize
                        }

                        // StyledButton { // Felgo
                        Button { // Sailfish OS
                            anchors.fill: parent
                            z: 2
                            clip: true
                            // text: "X" // DEBUG
                            // color: "yellow" // DEBUG
                            // border.color: "yellow" // DEBUG
                            color: "transparent"
                            highlightBackgroundColor: appwindow.textColor2 // Sailfish OS
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

                    // AppText { // Felgo
                    Label { // Sailfish OS
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
                    // AppText { // Felgo
                    Label { // Sailfish OS
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
                        //height: appwindow.largeTextSize // Felgo
                        height: appwindow.textSize // Sailfish OS
                    }
                }

                Row {
                    anchors.left: mainContent.left
                    height: appwindow.largeTextSize
                    // AppText { // Felgo
                    Label { // Sailfish OS
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
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            anchors.centerIn: parent
                            text: "2"
                            color: appwindow.textColor1
                            font.family: "FreeSans"
                            font.pixelSize: appwindow.largeTextSize
                        }
                        onClicked: {
                            console.log("BUTTON 2 variables")
                            numVariables = 2
                            truthTableModel.setNumVariables(2)
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
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            anchors.centerIn: parent
                            text: "3"
                            color: appwindow.textColor1
                            font.family: "FreeSans"
                            font.pixelSize: appwindow.largeTextSize
                        }
                        onClicked: {
                            console.log("BUTTON 3 variables")
                            numVariables = 3
                            truthTableModel.setNumVariables(3)
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
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            anchors.centerIn: parent
                            text: "4"
                            color: appwindow.textColor1
                            font.family: "FreeSans"
                            font.pixelSize: appwindow.largeTextSize
                        }
                        onClicked: {
                            console.log("BUTTON 4 variables")
                            numVariables = 4
                            truthTableModel.setNumVariables(4)
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
                        // AppText { // Felgo
                        Label { // Sailfish OS
                            anchors.centerIn: parent
                            text: "5"
                            color: appwindow.textColor1
                            font.family: "FreeSans"
                            font.pixelSize: appwindow.largeTextSize
                        }
                        onClicked: {
                            console.log("BUTTON 5 variables")
                            numVariables = 5
                            truthTableModel.setNumVariables(5)
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
                    // AppText { // Felgo
                    Label { // Sailfish OS
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
                        //height: appwindow.largeTextSize // Felgo
                        height: appwindow.textSize // Sailfish OS
                    }
                }

                Row {
                    anchors.left: mainContent.left
                    height: appwindow.largeTextSize
                    // AppText { // Felgo
                    Label { // Sailfish OS
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
                        enabled: numVariables >= 1
                        width: appwindow.diagramCellSize
                        height: appwindow.diagramCellSize
                        border.color: appwindow.textColor1
                        color: "transparent"
                        radius: 12
                        border.width: 4 //appwindow.diagramCellBorder

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
                                truthTableModel.setVariableName(1,variableA)
                                variablePA = truthTableModel.string2html("a")
                                variableNA = truthTableModel.string2html("*a")
                                text = ""
                            }
                        }
                    }

                    Rectangle {
                        enabled: numVariables >= 2
                        width: appwindow.diagramCellSize
                        height: appwindow.diagramCellSize
                        border.color: appwindow.textColor1
                        color: "transparent"
                        radius: 12
                        border.width: 4 //appwindow.diagramCellBorder

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
                                truthTableModel.setVariableName(2,variableB)
                                variablePB = truthTableModel.string2html("b")
                                variableNB = truthTableModel.string2html("*b")
                                text = ""
                            }
                        }
                    }

                    Rectangle {
                        enabled: numVariables >= 3
                        width: appwindow.diagramCellSize
                        height: appwindow.diagramCellSize
                        border.color: appwindow.textColor1
                        color: "transparent"
                        radius: 12
                        border.width: 4 //appwindow.diagramCellBorder

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
                                truthTableModel.setVariableName(3,variableC)
                                variablePC = truthTableModel.string2html("c")
                                variableNC = truthTableModel.string2html("*c")
                                text = ""
                            }
                        }
                    }

                    Rectangle {
                        enabled: numVariables >= 4
                        width: appwindow.diagramCellSize
                        height: appwindow.diagramCellSize
                        border.color: appwindow.textColor1
                        color: "transparent"
                        radius: 12
                        border.width: 4 //appwindow.diagramCellBorder

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
                                truthTableModel.setVariableName(4,variableD)
                                variablePD = truthTableModel.string2html("d")
                                variableND = truthTableModel.string2html("*d")
                                text = ""
                            }
                        }
                    }

                    Rectangle {
                        enabled: numVariables >= 5
                        width: appwindow.diagramCellSize
                        height: appwindow.diagramCellSize
                        border.color: appwindow.textColor1
                        color: "transparent"
                        radius: 12
                        border.width: 4 //appwindow.diagramCellBorder

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
                                truthTableModel.setVariableName(5,variableE)
                                variablePE = truthTableModel.string2html("e")
                                variableNE = truthTableModel.string2html("*e")
                                text = ""
                            }
                        }

                    }

                }

                /*
                Row {
                    anchors.left: mainContent.left
                    height: appwindow.regularTextSize
                    // AppText { // Felgo
                    Label { // Sailfish OS
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
                    //property int size: appwindow.screenHeight - y - date.height - appwindow.titleTextSize // Felgo
                    property int size: Screen.height - y - date.height - appwindow.titleTextSize // Sailfish OS
                    Item {
                        width: 1 // dummy value != 0
                        height: (datespace.size < appwindow.titleTextSize) ? appwindow.titleTextSize : datespace.size
                    }
                }

                //AppText { // Felgo
                Label { // Sailfish OS
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
    

    /* FELGO */
    /*
    }
                                pageKarnaughMap ? pageStack.pushAttached(Qt.resolvedUrl("KarnaughMap.qml")) :
                                    pageTruthTable ? pageStack.pushAttached(Qt.resolvedUrl("TruthTable.qml")) :
                                    pageBooleanExpression ? pageStack.pushAttached(Qt.resolvedUrl("BooleanExpression.qml")) :
                                    pageQM ? pageStack.pushAttached(Qt.resolvedUrl("QM.qml")) : pageStack.pushAttached(Qt.resolvedUrl("About.qml"))

    Component {
        id: karnaughMapPage
        KarnaughMap { }
    }

    Component {
        id: truthTablePage
        TruthTable { }
    }

    Component {
        id: sopPage
        SOP { }
    }

    Component {
        id: qmPage
        QM { }
    }

    Component {
        id: aboutPage
        About { }
    }
    */

}
