// ==UserScript==
// @name          Google+ fix
// @namespace     http://userstyles.org
// @description	  Left menu / pictures profile / font size and more
// @author        Amir Story
// @homepage      http://userstyles.org/styles/53365
// @include       http://m.youtube.com/*
// @include       https://m.youtube.com/*
// @run-at        document-start
// ==/UserScript==
(function() {
var css = "* {\nfont-family: \"Ubuntu\" !important;\nfont-size: 10pt !important;}\n\n\n._mutb._mvtb {\nposition: fixed !important;\n top: 45px !important;\n\n z-index: 101 !important;\n}\n\n  \n \n \n ._muc {\nposition: fixed !important;\nwidth: 100% !important;\nz-index: 100 !important;\n}\n\n\n  \n \n#player {\nposition: fixed !important;\nwidth: 100% !important;\ntop: 45px !important;\n}\n\n  \n \n._meub {\nposition: relative !important;\nwidth: 100% !important;\ntop: 100px !important;\n}\nn  \n \n._meb_mjib {\nposition: relative !important;\nwidth: 100% !important;\npadding-top: 50px !important;\npadding-bottom: 40px !important;\n}\n\n  \n \n._mfxb {\nposition: relative !important;\nwidth: 100% !important;\npadding-top: 40px !important;\n}\nn  \n \n._meb_mjib {\nposition: absolute !important;\nwidth: 100% !important;\ntop: -20px !important;\n}\n"


;
if (typeof GM_addStyle != "undefined") {
	GM_addStyle(css);
} else if (typeof PRO_addStyle != "undefined") {
	PRO_addStyle(css);
} else if (typeof addStyle != "undefined") {
	addStyle(css);
} else {
	var node = document.createElement("style");
	node.type = "text/css";
	node.appendChild(document.createTextNode(css));
	var heads = document.getElementsByTagName("head");
	if (heads.length > 0) {
		heads[0].appendChild(node); 
	} else {
		// no head yet, stick it whereever
		document.documentElement.appendChild(node);
	}
}
})();
