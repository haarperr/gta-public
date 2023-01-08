
	
	
	
	
	

$(function(){
	window.onload = (e) => {
        /* 'links' the js with the Nui message from main.lua */
		window.addEventListener('message', (event) => {
			var item = event.data;
			if (item !== undefined && item.type === "ui") {
                /* if the display is true, it will show */
				if (item.display === true) {
                    $("#container").show();
					// $("#abs").hide();
					// $("#hBrake").hide();
					// let deg = Math.floor(parseFloat(item.speed) * 3.6) - 130
					// let degrpm = Math.floor(Math.floor(parseFloat(item.rpm)*100)*2.6-130)
					// let color = "#1dd3ae"
					// if (Math.floor(parseFloat(item.rpm)*100) > 94) {
					// 	color = "#ef4655"
					// 	document.getElementById("gaugerpm").style.filter = 'drop-shadow(6px 6px 4px #ff03035e)';
					// 	document.getElementById("gaugerpm").style.animationPlayState = "running"; 
					// 	document.getElementById("gaugerpm").style.animation = "shake 0.1s"; 
					// 	document.getElementById("gaugerpm").style.animationIterationCount = "infinite";
					// } else {
					// 	document.getElementById("gaugerpm").style.animationPlayState = "paused"; 
					// 	document.getElementById("gaugerpm").style.filter = 'drop-shadow(6px 6px 4px #1dd3ae3f)';
						
					// }
					// if (deg>132) {
					// 	deg=133
					// 	document.getElementById("speed").style.animationPlayState = "running"; 
					// 	document.getElementById("speed").style.animation = "shake 0.1s"; 
					// 	document.getElementById("speed").style.animationIterationCount = "infinite";
					// } else {
					// 	document.getElementById("speed").style.animationPlayState = "paused"; 
					// }
					// document.getElementById("gaugerpm").style.border = "10px solid "+color;
					// document.getElementById("gaugerpm").style.borderBottom = "10px solid transparent";
					// document.getElementById("speed").innerHTML = Math.floor(parseFloat(item.speed) * 3.6);
					// document.getElementById("needlespeed").style.transform = "rotate("+deg+"deg)";
					// document.getElementById("needlerpm").style.transform = "rotate("+degrpm+"deg)";
					// document.getElementById("gear").innerHTML = item.gear;
					// document.getElementById("crash").innerHTML = item.crash;
					// document.getElementById("fuel-p").innerHTML = Math.floor(item.fuel);
					// document.getElementById("fuel-value").style.width = Math.floor(item.fuel)+"%";
					// if (item.crash===true) {
					// 	wiggleHUD()
					// }
					// if(item.phare1===1&&item.phare2===0) {
					// 	document.getElementById("phare").innerHTML = "on";
					// } else if(item.phare1===1&&item.phare2===1){
					// 	document.getElementById("phare").innerHTML = "plein";
					// }	else if(item.phare1===0){
					// 	document.getElementById("phare").innerHTML = "off";
					// }
					// if(item.abs===true){
					// 	$("#abs").show();
					// }
                    // if(item.hBrake===1){
					// 	$("#hBrake").show();
					// }

					// var elem = document.querySelector("#rpmbar");
					// var width = Math.floor(parseFloat(item.rpm)*100) ;
					
					// elem.style.width = width + "%";
					// elem.innerHTML = width  + "%RPM";

				
					/* if the display is false, it will hide */

					if (item.oxygen != null || item.oxygen != undefined) {
						$('#oxygen').show()
					} else {
						$('#oxygen').hide()
					}




					var oxygen = document.querySelector('[id=\'oxygenCircle\']');
					var radiusOxygen = oxygen.r.baseVal.value;
					var circumferenceOxygen = radiusOxygen * 2 * Math.PI;

					oxygen.style.strokeDasharray = `${circumferenceOxygen} ${circumferenceOxygen}`;
					oxygen.style.strokeDashoffset = `${circumferenceOxygen}`;

					function setProgressOxygen(percent) {
						const offset = circumferenceOxygen - ((percent/40)*100) / 100 * circumferenceOxygen;
						oxygen.style.strokeDashoffset = offset;
					}

					setProgressOxygen(item.oxygen);












					document.getElementById("id").innerHTML = item.id;

					var hp = document.querySelector('[id=\'hpCircle\']');
					var radiusHp = hp.r.baseVal.value;
					var circumference = radiusHp * 2 * Math.PI;

					hp.style.strokeDasharray = `${circumference} ${circumference}`;
					hp.style.strokeDashoffset = `${circumference}`;

					function setProgress(percent) {
						const offset = circumference - percent / 100 * circumference;
						hp.style.strokeDashoffset = offset;
					}

					setProgress(item.hp-100);


					


					var food = document.querySelector('[id=\'foodCircle\']');
					var radiusFood = food.r.baseVal.value;
					var circumferenceFood = radiusFood * 2 * Math.PI;

					food.style.strokeDasharray = `${circumferenceFood} ${circumferenceFood}`;
					food.style.strokeDashoffset = `${circumferenceFood}`;

					function setProgressFood(percent) {
						const offset = circumferenceFood - percent / 100 * circumferenceFood;
						food.style.strokeDashoffset = offset;
					}

					setProgressFood(item.food);




					


					var water = document.querySelector('[id=\'waterCircle\']');
					var radiusWater = water.r.baseVal.value;
					var circumferenceWater = radiusWater * 2 * Math.PI;

					water.style.strokeDasharray = `${circumferenceWater} ${circumferenceWater}`;
					water.style.strokeDashoffset = `${circumferenceWater}`;

					function setProgressWater(percent) {
						const offset = circumferenceWater - percent / 100 * circumferenceWater;
						water.style.strokeDashoffset = offset;
					}

					setProgressWater(item.water);

				} else{
                    $("#container").hide();
                }
			}
		});
	};

});