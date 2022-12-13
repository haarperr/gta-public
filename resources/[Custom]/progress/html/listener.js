$(function(){
	let breakProgress = false
	
	window.onload = (e) => {
		window.addEventListener('message', (event) => {
			var item = event.data;
			if (item !== undefined && item.type === "ui") {
				if (item.duration) {
                    $("#body").show();
					createProgress(item.duration)
				} else {
					breakProgress = true
					progress =  document.getElementById('progress'),
					progress.style.width = 0 + "%";
					$("#body").hide();
                }
			}
		});
	};
	
	function createProgress(d) {
		var progressBar = document.getElementById('progressbar'),
		progress =  document.getElementById('progress'),
		parent = progressbar.parentNode,
		duration = d, //seconds
		nbSlide = 1,
		step = parent.offsetWidth / nbSlide,
		cpt = 0;
		for (i = 0; i < nbSlide - 1; i++){
			var node = document.createElement("div");
			node.className = 'step'
			progressBar.appendChild(node);
		}
		var steps = document.getElementsByClassName('step');
		for (index = 0; index < steps.length; index++) {
			steps[index].style.width = (step - 1) * 100 / parent.offsetWidth + "%";
		}
		function updateProgressBar(){
			step = parent.offsetWidth / duration
			if(cpt >= duration * nbSlide || breakProgress){
				breakProgress = false
				cpt = 0;
				progress.style.width = (step * cpt / nbSlide) * 100 / parent.offsetWidth + "%";
				$("#body").hide();
				return
			}else{
				cpt++;
			}
			progress.style.width = (step * cpt / nbSlide) * 100 / parent.offsetWidth + "%";
			setTimeout(updateProgressBar,1000);
		}
		updateProgressBar()
	}
});