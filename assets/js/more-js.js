//Code to run at page load
window.onload = function() {
	//Make social links open in new tab
	var sideA = document.querySelectorAll(".sidebar a");
	sideA.forEach(a => a.target = "_blank");
};
