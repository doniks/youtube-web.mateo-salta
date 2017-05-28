// ==UserScript==
// @name          Youtube webapp
// @namespace     http://userstyles.org
// @description	  
// @author       
// @homepage      http://userstyles.org/styles/53365
// @include       http://m.youtube.com/*
// @include       https://m.youtube.com/*
// @run-at        document-start
// ==/UserScript==
(function() {
var css = "* {\nfont-family: \"Ubuntu\" !important;\nfont-size: 10pt !important;} \n\n\n 	 \n\n\n 						._muc {\nposition: fixed !important;\nwidth: 100% !important;\nz-index: 10000 !important;\n} \n\n\n										@media screen and (orientation:portrait) {\n#player {\nposition: fixed !important;\nwidth: 100% !important;\ntop: 45px !important;\nbox-shadow:0 2px 2px rgba(0,0,0,0.5);\n}\n} \n\n\n																._mmb {\nposition: relative !important;\nwidth: 100% !important;\ntop: 40px !important;\n\npadding-bottom: 50px !important;\n}	 \n\n\n			"


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
