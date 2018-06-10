The very best youtube experience on your mobile device.

Runs as a webapp separately from your browser. Features customized playback and navigation buttons.

Building
========

It is based on Ogra's alternate webapp containter [1][2].

run:

    clickable

or:

    clickable --sdk 16.04

Development
===========

This is a "webapp", in the sense that it displays a single browser window, showing youtube. However, technically it is just a regular qml app that happens to feature one large webview. Consequently, you have all the possibilities of regular qml / UT SDK.

In addition, a youtube specific aspect is that you interact with this particular website and the media player embedded in it. It can be helpful to inspect it like this [3]:

on the device
-------------

run:

    ubuntu-app-launch webbrowser-app --inspector

and navigate to youtube

on your desktop
---------------

navigate to http://IPADDRESSOFYOURDEVICE:9221 using chromium or chrome browser

start inspecting

[1] http://bazaar.launchpad.net/~ogra/junk/alternate-webapp-container/files

[2] https://open-store.io/app/webapp-creator.jujuyeh

[3] https://daker.me/2013/11/web-apps-remote-debugging-on-ubuntu-touch.html

