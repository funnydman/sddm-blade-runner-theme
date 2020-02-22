import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    id: container
    width: 640
    height: 480

    property int sessionIndex: session.index
    property string userName: userModel.lastUser

    TextConstants { id: textConstants }

    Connections {
	// some stuff here; keep the same at least for now
        target: sddm

        onLoginSucceeded: {
            errorMessage.color = "steelblue"
            errorMessage.text = textConstants.loginSucceeded
        }

        onLoginFailed: {
            password.text = ""
            errorMessage.color = "red"
            errorMessage.text = textConstants.loginFailed
        }
    }

    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        //visible: primaryScreen
        // clock; keep them at least for now
        Clock {
            id: clock
            anchors.margins: 40
            anchors.top: parent.top; anchors.right: parent.right

            color: "white"
            timeFont.family: "Oxygen"
        }

        Rectangle {
            // the main block with inputs 
            id: rectangle
            anchors.centerIn: parent
            width: Math.max(220, mainColumn.implicitWidth + 50)
            height: Math.max(164, mainColumn.implicitHeight + 50)
            color: '#33ffffff' // ARGB
	    border.color: '#ababab'
	    border.width: 1
            radius: 6 

            Column {
                id: mainColumn
                anchors.centerIn: parent
                spacing: 16

                Column {
                    width: 260 // quick fix; there was parent.width
                    spacing: 4
		    //anchors.centerIn: parent
                    Text {
                        id: lblName
                        width: parent.width
			horizontalAlignment: Text.AlignHCenter
			wrapMode: Text.WordWrap
			color: "white"
                        //text: textConstants.userName
                        text: "Hello, %1".arg(userModel.lastUser) // TODO: proper message from translations
                        font.bold: true
                        font.pixelSize: 17
                    }

                }

                Column {
                    width: parent.width
                    spacing : 4
                    //Text {
                    //    id: lblPassword
                    //    width: parent.width
                    //    text: textConstants.password
                    //    font.bold: true
                    //    font.pixelSize: 12
                    //}

                    TextBox {
                        id: password
                        width: parent.width; height: 30
                        font.pixelSize: 14
			color: "#204d3791"
			radius:4
			echoMode: TextInput.Password
		        focus: true
                        // KeyNavigation.backtab: name; KeyNavigation.tab: session
			property string placeholderText: qsTr("&nbsp;&nbsp;Enter password here...")

        		Text {
            			text: password.placeholderText
				textFormat: Text.RichText
            			color: "white"
            			visible: !password.text && !password.activeFocus
				anchors.verticalCenter: parent.verticalCenter
        		}

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(userName, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }

                

                Column {
                    width: parent.width
                    Text {
                        id: errorMessage
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: ""
                        font.pixelSize: 10
                    }
                }

                Row {
                    spacing: 4

                    //anchors.horizontalCenter: parent.horizontalCenter
		    property int btnWidth: Math.max(loginButton.implicitWidth, 80) + 8
	
                    Button {
                        id: loginButton
                        text: textConstants.login
			width: parent.btnWidth
			//color: "#ccc"

                        radius: 4 
                        onClicked: sddm.login(userName, password.text, sessionIndex)

                        //KeyNavigation.backtab: layoutBox; KeyNavigation.tab: shutdownButton
                    }

                }
            }
        }
    }

    Component.onCompleted: {
        if (name.text == "")
            name.focus = true
        else
            password.focus = true
    }
}
