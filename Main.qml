import QtQuick 2.2
import Ubuntu.Web 0.2
import Ubuntu.Components 1.1
import com.canonical.Oxide 1.0 as Oxide
import "UCSComponents"
import "."

MainView {
    objectName: "mainView"
    applicationName: "google-plus.ogra"

    useDeprecatedToolbar: false
//    property string myUrl: "http://www.zeit.de/"
//    property string myPattern: "https?://*.zeit.de/" 
//    property string myUrl: "http://www.heise.de/"
//    property string myPattern: "https?://*.heise.de/"
    property string myUrl: "https://plus.google.com/"
    property string myPattern: "https?://plus.google.*/*,https?://accounts.google.*/*,https?://accounts.google.co.*/*,https?://www.google.*/accounts/*"

    property string myUA: "Mozilla/5.0 (Linux; Android 5.0; Nexus 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.102 Mobile Safari/537.36"

    Page {
        id: page


        WebContext {
            id: webcontext
            userAgent: myUA
        }
        WebView {
            id: webview
            anchors.fill: parent
            width: parent.width
            height: parent.height

            context: webcontext
            function navigationRequestedDelegate(request) {
                var url = request.url.toString();
                var pattern = myPattern.split(',');
                var isvalid = false;
                for (var i=0; i<pattern.length; i++) {
                    var tmpsearch = pattern[i].replace(/\*/g,'(.*)')
                    var search = tmpsearch.replace(/^https\?:\/\//g, '(http|https):\/\/');
                    if (url.match(search)) {
                       isvalid = true;
                       break
                    }
                } 
                if(isvalid == false) {
                    console.warn("Opening remote: " + url);
                    Qt.openUrlExternally(url)
                    request.action = Oxide.NavigationRequest.ActionReject
                }
            }
            Component.onCompleted: {
                url = myUrl
            }
        }
        ThinProgressBar {
            webview: webview

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
        }
        RadialBottomEdge {
            visible: true
            actions: [
                RadialAction {
                    id: reload
                    iconName: "reload"
                    onTriggered: {
                        webview.reload()
                    }
                    text: qsTr("Reload")
                },
                RadialAction {
                    id: forward
                    enabled: webview.canGoForward
                    iconName: "go-next"
                    onTriggered: {
                        webview.goForward()
                    }
                   text: qsTr("Forward")
                 },
                RadialAction {
                    id: back
                    enabled: webview.canGoBack
                    iconName: "go-previous"
                    onTriggered: {
                        webview.goBack()
                    }
                    text: qsTr("Back")
                }
            ]
        }
    }
}
