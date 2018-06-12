import QtQuick 2.4
import QtFeedback 5.0
import Ubuntu.Components 1.3
import QtQuick.Window 2.1
import ".."


Item {
    id: bottomEdge
    
  property int hintSize: units.gu(8)

    //property string hintIconName: "up"
    //property alias hintIconSource: hintIcon.source
    //property color hintIconColor: "#000000"
    property bool bottomEdgeEnabled: true


   // property int expandAngle : Screen.orientation == Qt.LandscapeOrientation ? 500 : 360
    //property real expandedPosition: (0.85 - 0.25 * expandAngle/360) * height
    property real collapsedPosition: height - hintSize/7

    
    anchors.fill: parent

    HapticsEffect {
        id: clickEffect
        attackIntensity: 0.0
        attackTime: 50
        intensity: 1.0
        duration: 10
        fadeTime: 50
        fadeIntensity: 0.0
    }

   /* Rectangle {
        id: bgVisual

        z: 1
        visible: bottomEdgeHint.y !== collapsedPosition
        color: "black"
        anchors.fill: parent
        opacity: 0.9 * (((bottomEdge.height - bottomEdgeHint.y) / bottomEdge.height) * 2)

        MouseArea {
            anchors.fill: parent
            enabled: bgVisual.visible
            onClicked: bottomEdgeHint.state = "collapsed"
            z: 1
        }

    } */

    Rectangle {
        id: bottomEdgeHint

        color: "black"
        width: parent.width
        opacity: 0.6
        height: units.gu(6.5)
        //radius: width
        visible: bottomEdgeEnabled

        //anchors.top: parent.bottom - units.gu(1)
        y: collapsedPosition
        z: parent.z + 1

     

       /* Icon {
            id: hintIcon
            width: hintSize/4
            height: width
            name: hintIconName
            color: hintIconColor
            anchors {
                centerIn: parent
                verticalCenterOffset: width * ((bottomEdgeHint.y - expandedPosition)
                                              )
            }
        } */




Rectangle {
width: page.width
height: units.gu(6.5)
anchors.top: page.top
z: parent.z +1
color: "black"


           Label {
           property string timeschar:
                "\u2a09" // leaves a strange space after the x
                //"\u2715" // looks a bit off, because the x is a little thicker than the text
                //"x" // guess what, looks like an x character
                //"\ua058" // doesn't work
text: ( root.playBackSpeedLevel === root.playBackSpeedLevelNormal ) ? "" : timeschar + root.playBackSpeeds[root.playBackSpeedLevel]

 anchors {
 left: parent.left
 leftMargin: units.gu(1)
verticalCenter: parent.verticalCenter
 
 }
//text: "Hello world!"
textSize: Label.Large
color: "white"
}
ActionBar {
anchors {
left: parent.left
bottom: parent.bottom
//center
leftMargin: units.gu(12)}
numberOfSlots: 4
actions: [
Action {
                    text: qsTr("Faster")
                    iconName: "add"
                    onTriggered: {
                        changePlaybackSpeedLevel(+1);
                        console.log(root.playBackSpeedLevel, root.playBackSpeeds[root.playBackSpeedLevel]);
                        webview.url = 'javascript:document.querySelector("video").playbackRate='
                                + root.playBackSpeeds[root.playBackSpeedLevel]
                                + ';' ;
                    }
                },
                Action {
                    text: qsTr("play")
                    iconName: "media-playback-start"
                    onTriggered: {
                        webview.url = "javascript:
player = document.getElementById('movie_player');
state = player.getPlayerState();
if (state == 1) {
  player.pauseVideo();
} else if (state == 2){
  player.playVideo();
}";
                    }
                },
                
               Action {
                    text: qsTr("Slower")
                    iconName: "remove"
                    onTriggered: {
                        changePlaybackSpeedLevel(-1);
                        console.log(root.playBackSpeedLevel, root.playBackSpeeds[root.playBackSpeedLevel]);
                        webview.url = 'javascript:document.querySelector("video").playbackRate='
                                + root.playBackSpeeds[root.playBackSpeedLevel]
                                + ';' ;
                    }
                }
]
}

ActionBar {
anchors {
bottom: parent.bottom
right: parent.right }
numberOfSlots: 4
actions: [Action {
 text: qsTr("Forward")
                    enabled: webview.canGoForward
                    iconName: "go-next"
                    onTriggered: {
                        webview.goForward()
bottomEdgeHint.state = "collapsed"
                        
                    }
},
Action {
 text: qsTr("Reload")
                    iconName: "reload"
                    onTriggered: {
                        webview.reload()
bottomEdgeHint.state = "collapsed"
                    }
},
Action {
  text: qsTr("Back")
                    enabled: webview.canGoBack
                    iconName: "go-previous"
                    onTriggered: {
                        webview.goBack()
bottomEdgeHint.state = "collapsed"
                    }
},

Action {
id: home
                    iconName: "home"
                    onTriggered: {
                        webview.url = 'http://m.youtube.com'
bottomEdgeHint.state = "collapsed"
                    }
                    text: qsTr("Home")
},
Action {
  text: qsTr("Account")
                    iconName: "account"
                    onTriggered: {
                        webview.url = 'https://m.youtube.com/feed/account'
bottomEdgeHint.state = "collapsed"
                    }
},
Action {
text: qsTr("Subscriptions")
                    iconName: "media-playlist"
                    onTriggered: {
                        webview.url = 'https://m.youtube.com/feed/subscriptions'
bottomEdgeHint.state = "collapsed"
                    }                 
}


]
}



}
       

        MouseArea {
            id: mouseArea

            property real previousY: -1
            property string dragDirection: "None"

            z: 1
            anchors.fill: parent
            visible: bottomEdgeEnabled

            preventStealing: true
            drag {
                axis: Drag.YAxis
                target: bottomEdgeHint
                minimumY: expandedPosition
                maximumY: collapsedPosition
            }

            onReleased: {
                if ((dragDirection === "BottomToTop") &&
                        bottomEdgeHint.y < collapsedPosition) {
                    bottomEdgeHint.state = "expanded"
                } else {
                    if (bottomEdgeHint.state === "collapsed") {
                        bottomEdgeHint.y = collapsedPosition
                    }
                    bottomEdgeHint.state = "collapsed"
                }
                previousY = -1
                dragDirection = "None"
            }

            onClicked: {
                if (bottomEdgeHint.y === collapsedPosition)
                    bottomEdgeHint.state = "expanded"
                else
                    bottomEdgeHint.state = "collapsed"
            }

            onPressed: {
                previousY = bottomEdgeHint.y
            }

            onMouseYChanged: {
                var yOffset = previousY - bottomEdgeHint.y
                if (Math.abs(yOffset) <= units.gu(2)) {
                    return
                }
                previousY = bottomEdgeHint.y
                dragDirection = yOffset > 0 ? "BottomToTop" : "TopToBottom"
            }
        }

        state: "collapsed"
        states: [
            State {
                name: "collapsed"
                PropertyChanges {
                    target: bottomEdgeHint
                    y: collapsedPosition
                }
            },
            State {
                name: "expanded"
                PropertyChanges {
                    target: bottomEdgeHint
                    y: expandedPosition
                }
            },

            State {
                name: "floating"
                when: mouseArea.drag.active
            }
        ]

        transitions: [
            Transition {
                to: "expanded"
                SpringAnimation {
                    target: bottomEdgeHint
                    property: "y"
                    spring: 2
                   damping: .2 
                 // epsilon: .05
                }
            },

            Transition {
                to: "collapsed"
                SmoothedAnimation {
                    target: bottomEdgeHint
                    property: "y"
                    duration: UbuntuAnimation.BriskDuration
                }
            }
        ]
    }
}
