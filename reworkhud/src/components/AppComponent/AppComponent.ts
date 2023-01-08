import html from "./AppComponent.html?raw";
import style from "./AppComponent.scss";
import { Component} from "../../decorators/decorators";



@Component({
    selector: 'app-component',
    template: html,
    style: style,
    useShadow: true
})
export class AppComponent extends HTMLElement {

    static get observedAttributes() { return ["title"];}

    constructor() {
        super();

    }

    connectedCallback() {
        this.listenMessageEvents()
    }


    listenMessageEvents() {
        // const vehicleComponent = document.getElementById("VehicleComponent") as HTMLElement;
        // vehicleComponent.setAttribute("display", "false")
        
        // window.onload = () => {
        //     window.addEventListener('message', (event) => {
        //         console.log(event);
        // console.log('là');
                
        //         var item = event.data;
        //         if (item !== undefined && item.type === "ui") {
        //             if (item.action == "gauges") {
        //                 const gaugeComponent = document.getElementById("GaugesComponent") as HTMLElement;
        //                 gaugeComponent.setAttribute("serverId", "8")
        //                 gaugeComponent.setAttribute("display", item.display)
        //                 item.oxygen ? gaugeComponent.setAttribute("oxygen", item.oxygen) : null;
        //                 item.hp ? gaugeComponent.setAttribute("hp", item.hp) : null;
        //                 item.food ? gaugeComponent.setAttribute("food", item.food) : null;
        //                 item.water ? gaugeComponent.setAttribute("water", item.water) : null;
        //                 item.id ? gaugeComponent.setAttribute("serverId", item.id) : null;
        //             } else if (item.action == "vehicle") {
        //                 const vehicleComponent = document.getElementById("VehicleComponent") as HTMLElement;
        //                 vehicleComponent.setAttribute("display", item.display)
        //                 vehicleComponent.setAttribute("speed", item.speed)
        //                 vehicleComponent.setAttribute("rpm", item.rpm)
        //                 vehicleComponent.setAttribute("gear", item.gear)
        //                 vehicleComponent.setAttribute("fuel", item.fuel)
        //                 vehicleComponent.setAttribute("crash", item.crash)
        //             }
        //         }
        //     })
        // }
    }




    /**
     * This method is called everytime an attribute changes.
     * It is also called a first time after the constructor, and before connectedCallback,
     * for all attributes already present on the element before being added to the DOM.
     * @param name attribute name
     * @param oldValue old value
     * @param newValue new value
     */
    attributeChangedCallback(name: string, oldValue: string, newValue: string) {
        if (newValue != oldValue) {
            switch(name) {
                case "title":
                    // this.titleElement.textContent = newValue;
                    break;
            }
        }
    }
}
