// From https://github.com/qiujames/qiujames.github.io/blob/main/assets/js/tablist-script.js

function tablistClickHandle(evt, tablistName, tabTitle) {
  let i, tabcontent, tablinks;

  // This is to clear the previous clicked content.
  tabcontent = document.getElementsByClassName(tablistName + "-id-content");
  for (i = 0; i < tabcontent.length; i++) {
      tabcontent[i].style.display = "none";
  }

  // Set the tab to be "active".
  tablinks = document.getElementsByClassName(tablistName + "-id-tab");
  for (i = 0; i < tablinks.length; i++) {
      tablinks[i].className = tablinks[i].className.replace(" active", "");
  }

  // Display the clicked tab and set it to active.
  document.getElementById(tablistName + "-" + tabTitle).style.display = "block";
	document.getElementById(tabTitle).className += " active"; // This works if the tab itself wasn't clicked but a link
}

//Scroll button functions
var scrollAmt = 100;
function tablistScrollLeft(evt) {
	var tabs = evt.target.parentNode.querySelector(".visible-links");
	tabs.scrollLeft -= scrollAmt;
}
function tablistScrollRight(evt) {
	var tabs = evt.target.parentNode.querySelector(".visible-links");
	tabs.scrollLeft += scrollAmt;
}

//Show/hide scroll buttons to tablist
function tablistScrollToggle(tabs) {
	var btnScrollLeft = tabs.parentNode.querySelector(".tablist-scroll-left");
	var btnScrollRight = tabs.parentNode.querySelector(".tablist-scroll-right");
	var tabsSL = tabs.scrollLeft
	var tabsSW = tabs.scrollWidth
	var tabsCW = tabs.clientWidth

	//Hide buttons if not needed
	if (tabsSW == tabsCW) {
		btnScrollLeft.style.display = "none";
		btnScrollRight.style.display = "none";
	}
	if (tabsSL == 0) {
		btnScrollLeft.style.opacity = 0;
	} else {
		btnScrollLeft.style.opacity = 1;
	}
	if (tabsSL == tabsSW - tabsCW) {
		btnScrollLeft.style.opacity = 0;
	} else {
		btnScrollLeft.style.opacity = 1;
	}
}
function tablistScrollEvent(evt) {
	tablistScrollToggle(evt.target);
}
