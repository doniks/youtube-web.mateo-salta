import QtQuick 2.4
import Ubuntu.Web 0.2
import Ubuntu.Components 1.3
import com.canonical.Oxide 1.19 as Oxide
import Ubuntu.Components.Popups 1.3
import "UCSComponents"
import Ubuntu.Content 1.1
import "actions" as Actions
import QtMultimedia 5.0
import QtFeedback 5.0
import Ubuntu.Unity.Action 1.1 as UnityActions
import Ubuntu.UnityWebApps 0.1 as UnityWebApps
import "."
import "../config.js" as Conf

MainView {
    id: root
    objectName: "mainView"
    theme.name: "Ubuntu.Components.Themes.SuruDark"

    anchors {
        fill: parent
    }

    applicationName: "youtube-web.mateo-salta"

    anchorToKeyboard: true
    automaticOrientation: true

    property string myUrl: Conf.webappUrl
    property string myPattern: Conf.webappUrlPattern
    property url webviewOverrideFile: Qt.resolvedUrl("WebViewImplOxide.qml")

    property bool blockOpenExternalUrls: false
    property bool runningLocalApplication: false

    property bool openExternalUrlInOverlay: true
    property bool popupBlockerEnabled: true

    property string myUA: Conf.webappUA ? Conf.webappUA : "Mozilla/5.0 (Linux; Android 5.0; Nexus 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.102 Mobile Safari/537.36"

    Page {
        id: page
        header: Rectangle {
            color: "#000000"
            width: parent.width
            height: units.dp(.5)
            z: 1
        }
        anchors {
            fill: parent
            bottom: parent.bottom
        }


        HapticsEffect {
            id: vibration
            attackIntensity: 0.0
            attackTime: 50
            intensity: 1.0
            duration: 10
            fadeTime: 50
            fadeIntensity: 0.0
        }

        SoundEffect {
            id: clicksound
            source: "../sounds/Click.wav"
        }
        WebContext {
            id: webcontext
            userAgent: myUA
            userScripts: [
                Oxide.UserScript {
                    context: "oxide://"
                    url: Qt.resolvedUrl("../userscripts/ubuntutheme.js")
                    matchAllFrames: true
                }
            ]
        }
        WebView {
            id: webview
            signal openUrlExternallyRequested(string url)
            objectName: "webview"
            alertDialog: AlertDialog {}
            confirmDialog: ConfirmDialog {}
            promptDialog: PromptDialog {}
            beforeUnloadDialog: BeforeUnloadDialog {}

            width: parent.width + units.dp(2)
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                bottom: parent.bottom

            }
            // url = 'http://m.youtube.com'

            context: webcontext
            url: myUrl

            preferences.localStorageEnabled: true
            preferences.allowFileAccessFromFileUrls: true
            preferences.allowUniversalAccessFromFileUrls: true
            preferences.appCacheEnabled: true
            preferences.javascriptCanAccessClipboard: true
            filePicker: filePickerLoader.item
            property bool blockOpenExternalUrls: false
            property bool runningLocalApplication: true

            contextualActions: ActionList {

                /// strange...
                Action {
                    text: i18n.tr(webview.contextualData.href.toString())
                    enabled: contextualData.herf.toString()
                }

                /// didn't seem to work without a item that is always triggered...
                Action {
                    text: i18n.tr("Copy Link")
                    enabled: webview.contextualData.href.toString()

                    //contextualData.href.toString()
                    onTriggered: Clipboard.push([webview.contextualData.href])
                }

                Action {
                    text: i18n.tr("Share Link")
                    enabled: webview.contextualData.href.toString()
                    onTriggered: {
                        var component = Qt.createComponent("Share.qml")
                        console.log("component..."+component.status)
                        if (component.status == Component.Ready) {
                            var share = component.createObject(webview)
                            share.onDone.connect(share.destroy)
                            share.shareLink(webview.contextualData.href.toString(), webview.contextualData.title)
                        } else {
                            console.log(component.errorString())
                        }
                    }
                }

                Action {
                    text: i18n.tr("Copy Image")
                    enabled: webview.contextualData.img.toString()
                    onTriggered: Clipboard.push([webview.contextualData.img])
                }
                Action {
                    text: i18n.tr("Download Image")
                    enabled: webview.contextualData.img.toString() && downloadLoader.status == Loader.Ready
                    onTriggered: downloadLoader.item.downloadPicture(webview.contextualData.img)
                }
            }
            selectionActions: ActionList {
                Actions.Copy {
                    onTriggered: {
                        webview.copy()
                    }
                }
            }

            function navigationRequestedDelegate(request) {
                var url = request.url.toString();

                if (Conf.hapticLinks) {
                    vibration.start()
                }

                if (Conf.audibleLinks) {
                    clicksound.play()
                }

                if(isValid(url) == false) {
                    console.warn("Opening remote: " + url);
                    Qt.openUrlExternally(url)
                    request.action = Oxide.NavigationRequest.ActionReject
                }
            }
            Component.onCompleted: {
                preferences.localStorageEnabled = true
                if (Qt.application.arguments[2] != undefined ) {
                    console.warn("got argument: " + Qt.application.arguments[1])
                    if(isValid(Qt.application.arguments[1]) == true) {
                        url = Qt.application.arguments[1]
                    }
                }
                console.warn("url is: " + url)
            }
            onGeolocationPermissionRequested: { request.accept() }

            Loader {
                id: downloadLoader
                source: "Downloader.qml"
                asynchronous: true
            }

            Loader {
                id: filePickerLoader
                source: "ContentPickerDialog.qml"
                asynchronous: true
            }
            
            
            //Sad page
            Loader {
                anchors {
                    fill: webview
                }
                active: webview &&
                        (webProcessMonitor.crashed || (webProcessMonitor.killed && !webview.loading))
                sourceComponent: SadPage {
                    webview: webview
                    objectName: "webviewSadPage"
                }

                WebProcessMonitor {
                    id: webProcessMonitor
                    webview: webview
                }
                asynchronous: true
            }
            Loader {
                anchors {
                    fill: webview
                }
                sourceComponent: ErrorSheet {
                    visible: webview && webview.lastLoadFailed
                    url: webview ? webview.url : ""
                    onRefreshClicked: {
                        if (webview)
                            webview.reload()
                    }
                }
                asynchronous: true
            }

            function isValid (url){
                var pattern = myPattern.split(',');
                for (var i=0; i<pattern.length; i++) {
                    var tmpsearch = pattern[i].replace(/\*/g,'(.*)')
                    var search = tmpsearch.replace(/^https\?:\/\//g, '(http|https):\/\/');
                    if (url.match(search)) {
                        return true;
                    }
                }
                return false;
            }
        }
        
        UnityWebApps.UnityWebApps {
            id: unityWebapps
            name: webappName
            bindee: containerWebView.currentWebview
            actionsContext: actionManager.globalContext
            model: UnityWebApps.UnityWebappsAppModel { searchPath: webappModelSearchPath }
            injectExtraUbuntuApis: runningLocalApplication
            injectExtraContentShareCapabilities: !runningLocalApplication

            Component.onCompleted: {
                preferences.localStorageEnabled = true;
                // Delay bind the property to add a bit of backward compatibility with
                // other unity-webapps-qml modules
                if (unityWebapps.embeddedUiComponentParent !== undefined) {
                    unityWebapps.embeddedUiComponentParent = webapp
                }
            }
        }

        Component {
            id: pickerComponent

            PickerDialog {}
        }

        ThinProgressBar {
            webview: webview
            width: parent.width + units.gu(5)
            z: 2
            anchors {
                //left: parent.left
                // right: parent.right
                horizontalCenter: parent.horizontalCenter
                top: parent.top
            }
        }
        RadialBottomEdge {
            id: nav
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
                    id: account
                    iconName: "account"
                    onTriggered: {
                        webview.url = 'https://m.youtube.com/feed/account'
                    }
                    text: qsTr("Account")
                    
                },
                RadialAction {
                    id: subscriptions
                    iconName: "media-playlist"
                    onTriggered: {
                        webview.url = 'https://m.youtube.com/feed/subscriptions'
                    }
                    text: qsTr("Subscriptions")
                    
                },
                RadialAction {
                    id: trending
                    iconName: "weather-chance-of-storm"
                    onTriggered: {
                        webview.url = 'https://m.youtube.com/feed/trending'
                    }
                    text: qsTr("Trending")
                },
                RadialAction {
                    id: home
                    iconName: "home"
                    onTriggered: {
                        webview.url = 'http://m.youtube.com'
                    }
                    text: qsTr("Home")
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
    
    Loader {
        id: webappContainerWebViewLoader
        objectName: "containerWebviewLoader"
        anchors.fill: parent
        focus: true
    }
    
    PopupWindowController {
        id: popupController
        objectName: "popupController"
        webappUrlPatterns: webview.webappUrlPatterns
        mainWebappView: webview.currentWebview
        blockOpenExternalUrls: true
        mediaAccessDialogComponent: mediaAccessDialogComponent
        //wide: containerWebview.wide
        onInitializeOverlayViewsWithUrls: {
            if (webappContainerWebViewLoader.item) {
                for (var i in urls) {
                    webappContainerWebViewLoader
                    .item
                    .openOverlayForUrl(urls[i])
                }
            }
        }
    }
    
    Connections {
        target: Qt.inputMethod
        onVisibleChanged: nav.visible = !nav.visible
    }
    Connections {
        target: webview
        onFullscreenRequested: webview.fullscreen = fullscreen

        onFullscreenChanged: {
            nav.visible = !webview.fullscreen
            if (webview.fullscreen == true) {
                window.visibility = 5
                width: parent.width + units.dp(2)
            } else {
                window.visibility = 4
                width: parent.width + units.dp(2)
            }
        }
    }
    Connections {
        target: UriHandler
        onOpened: {
            if (uris.length === 0 ) {
                return;
            }
            webview.url = uris[0]
            console.warn("uri-handler request")
        }
    }
}


