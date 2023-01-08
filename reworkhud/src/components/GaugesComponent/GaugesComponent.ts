import html from "./GaugesComponent.html?raw";
import style from "./GaugesComponent.scss";
import json from "../../data/Gauges.json";


// @WatchAttribute('oxygen', 'updateOxygenGauge')
// @WatchAttribute('serverId', 'updateServerId')
// @WatchAttribute('hp', 'updateHpGauge')
// @WatchAttribute('food', 'updateFoodGauge')
// @WatchAttribute('water', 'updateWaterGauge')
export class GaugesComponent extends HTMLElement {
    
    static get observedAttributes() { return ["oxygen","serverId","hp","food","water"];}

    constructor() {
        super();
        this.attachShadow({mode: 'open'});
        this.shadowRoot!.innerHTML = html;
        const styleElement = document.createElement("style");
        styleElement.innerHTML = style;
        this.shadowRoot?.appendChild(styleElement);
        this.constructGauges()
    }

    constructGauges(){
        for (let i = 0; i < json.gauges.length; i++) {
            const element = json.gauges[i];
            const div = document.createElement("div");
            div.id = element.id
            div.innerHTML = element.content;
            this.shadowRoot?.appendChild(div);
        }
        // this.shadowRoot!.querySelector<HTMLElement>('[id="oxygen"]')!.hidden = true
    }

    connectedCallback() {
    }

    updateOxygenGauge(newValue: string){
        var oxygenCircle = this.shadowRoot!.querySelector<HTMLElement>('[id="oxygenCircle"]');
        var oxygenParent = this.shadowRoot!.querySelector<HTMLElement>('[id="oxygen"]');
        if (newValue != null && newValue != undefined && newValue != "undefined" && typeof Number(newValue) == "number") {
            let oxygen = Number(newValue)
            oxygenParent!.hidden = false
            var radiusOxygen = Number(oxygenCircle!.getAttribute('r'))
            if (radiusOxygen && typeof radiusOxygen == "number") {
                var circumferenceOxygen = radiusOxygen * 2 * Math.PI;
                oxygenCircle!.style.strokeDasharray = `${circumferenceOxygen} ${circumferenceOxygen}`;
                oxygenCircle!.style.strokeDashoffset = `${circumferenceOxygen}`;
                const offset = circumferenceOxygen - ((oxygen/40)*100) / 100 * circumferenceOxygen;
                oxygenCircle!.style.strokeDashoffset = `${offset}`;
            }
            if((oxygen/40)*100 < 15){
                oxygenCircle!.style.animation = "1s infinite backgroundChange";
            } else {
                if (oxygenCircle!.style.animation) {
                    oxygenCircle!.style.animation = "1s backgroundChange";
                }
            }
        } else {
            oxygenParent!.hidden = true
        }
    }

    updateGauge(gauge:string, newValue: string){
        var gaugeCircle = this.shadowRoot!.querySelector<HTMLElement>(`[id='${gauge}Circle']`);
        if (newValue != null || newValue != undefined || typeof Number(newValue) == "number") {
            let value = Number(newValue)
            if (gauge=="hp") {
                value = value-100
            }
            var radiusGauge = Number(gaugeCircle!.getAttribute('r'))
            if (radiusGauge && typeof radiusGauge == "number") {
                var circumferenceGauge = radiusGauge * 2 * Math.PI;
                gaugeCircle!.style.strokeDasharray = `${circumferenceGauge} ${circumferenceGauge}`;
                gaugeCircle!.style.strokeDashoffset = `${circumferenceGauge}`;
                const offset = circumferenceGauge - value / 100 * circumferenceGauge;
                gaugeCircle!.style.strokeDashoffset = `${offset}`;
            }
            if(value < 3){
                gaugeCircle!.style.animation = "3s infinite backgroundChange";
            } else {
                if (gaugeCircle!.style.animation) {
                    gaugeCircle!.style.animation = "1s backgroundChange";
                }
            }
        }
    }

    attributeChangedCallback(name: string, oldValue: string, newValue: string) {
        if (newValue != oldValue) {
            switch(name) {
                case "oxygen":
                    this.updateOxygenGauge(newValue)
                    break;
                case "food":
                case "water":
                case "hp":
                    this.updateGauge(name, newValue)
                    break;
                case "serverId":
                    
                    document.getElementById("serverId")!.innerHTML = newValue;
                    break;
            }
        }
    }

}
customElements.define("gauges-component", GaugesComponent);
