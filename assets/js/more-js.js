//Code to run at page load
window.onload = function() {
	//Make social links open in new tab
	var sideA = document.querySelectorAll(".sidebar a");
	sideA.forEach(a => a.target = "_blank");
	
	/*
	//use with onMouseover
	function highlightHrefHandle(evt) {
		var id = evt.href.replace(/.+#/, '');
		document.getElementById(id).className += " highlight";
	}

	//use with onMouseout
	function unhighlightHrefHandle(evt) {
		var id = evt.href.replace(/.+#/i, '');
		document.getElementById(id).className = document.getElementById(id).className.replace(" highlight", "");
	}
	
	//Add highlight event listeners to citation links
	var cites = document.querySelectorAll(".citation");
	cites.forEach(a => a.addEventListener("mouseover", highlightHrefHandle));
	*/
};

