import html from "./VehicleComponent.html?raw";
import style from "./VehicleComponent.scss";


export class VehicleComponent extends HTMLElement {
    
    static get observedAttributes() { return ["display","rpm","speed","gear","fuel", "crash"];}

    constructor() {
        super();
        this.attachShadow({mode: 'open'});
        this.shadowRoot!.innerHTML = html;
        const styleElement = document.createElement("style");
        styleElement.innerHTML = style;
        this.shadowRoot?.appendChild(styleElement);
    }

    updateFuel(value: string){
        this.shadowRoot!.querySelector<HTMLElement>('[id="fuel-p"]')!.innerHTML = ""+Math.floor(Number(value));
        this.shadowRoot!.querySelector<HTMLElement>('[id="fuel-value"]')!.style.width = Math.floor(Number(value))+"%";
    }

    updateRpm(rpm:string){
        let degrpm = Math.floor(Math.floor(parseFloat(rpm)*100)*2.6-130)
        let color = "#3b78c3"
        const gauge = this.shadowRoot!.querySelector<HTMLElement>('[id="gaugerpm"]')
        if (Math.floor(parseFloat(rpm)*100) > 94) {
            color = "#ef4655"
            gauge!.style.animationPlayState = "running"; 
            gauge!.style.animation = "shake 0.1s"; 
            gauge!.style.animationIterationCount = "infinite";
        } else {
            gauge!.style.animationPlayState = "paused"; 
            
        }
        gauge!.style.border = "10px solid "+color;
        gauge!.style.borderBottom = "10px solid transparent";
        this.shadowRoot!.querySelector<HTMLElement>('[id="needlerpm"]')!.style.transform = "rotate("+degrpm+"deg)";
    }
    updateSpeed(value:string){
        let deg = Math.floor(parseFloat(value) * 3.6) - 130
        const gauge = this.shadowRoot!.querySelector<HTMLElement>('[id="speed"]')
        if (deg>132) {
            deg=133
            gauge!.style.animationPlayState = "running"; 
            gauge!.style.animation = "shake 0.1s"; 
            gauge!.style.animationIterationCount = "infinite";
        } else {
            gauge!.style.animationPlayState = "paused"; 
        }
        gauge!.innerHTML = ""+Math.floor(parseFloat(value) * 3.6);
        this.shadowRoot!.querySelector<HTMLElement>('[id="needlespeed"]')!.style.transform = "rotate("+deg+"deg)";
    }

    attributeChangedCallback(name: string, oldValue: string, newValue: string) {
        if(name=="crash"){
            this.wiggleHUD()
            return
        }
        if (newValue != oldValue) {
            switch(name) {
                case "display":
                    let bool = true
                    newValue === "true" ? bool = false : bool = true;
                    document.getElementById("VehicleComponent")!.hidden = bool;
                    break;
                case "speed":
                    this.updateSpeed(newValue)
                    break;
                case "rpm":
                    this.updateRpm(newValue)
                    break;
                case "fuel":
                    this.updateFuel(newValue)
                    break;
                case "gear":
                    this.shadowRoot!.querySelector<HTMLElement>('[id="gear"]')!.innerHTML = newValue;
                    break;
            }
        }
    }

    wiggleHUD(){
        const hud = document.getElementById("VehicleComponent")
		hud!.style.animationPlayState = "running"; 
		hud!.style.animation = "crash 0.3s";
	}


}
customElements.define("vehicle-component", VehicleComponent);
