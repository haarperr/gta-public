import './style.scss'

//default components to render from the Panels.json file. You don't need to edit them.
export * from "./dummy/dummy";


//export your components here to make them available at runtime 
export { AppComponent } from './components/AppComponent/AppComponent'
export { GaugesComponent } from './components/GaugesComponent/GaugesComponent'
export { VehicleComponent } from './components/VehicleComponent/VehicleComponent'
export { ProgressbarComponent } from './components/ProgressbarComponent/ProgressbarComponent';


// window.postMessage({type:"ui",action:"gauges",oxygen:30}, "http://localhost:3000/")
// window.postMessage({type:"non",content:"non"}, "http://localhost:3000/")


// setTimeout(() => {
//     window.postMessage({type:"ui",action:"gauges",oxygen:5}, "http://localhost:3000/")
//     window.postMessage({type:"ui",action:"gauges",hp:150}, "http://localhost:3000/")
//     window.postMessage({type:"ui",action:"gauges",food:2}, "http://localhost:3000/")
//     window.postMessage({type:"ui",action:"gauges",water:70}, "http://localhost:3000/")
//     window.postMessage({type:"ui",action:"gauges",id:5}, "http://localhost:3000/")
//     window.postMessage({type:"non",content:"non"}, "http://localhost:3000/")
//     window.postMessage({type:"ui",action:"progressbar",duration:5000}, "http://localhost:3000/")
// }, 1000);

// setTimeout(() => {
//     window.postMessage({type:"ui",action:"gauges",oxygen:15}, "http://localhost:3000/")
//     window.postMessage({type:"ui",action:"gauges",hp:150}, "http://localhost:3000/")
//     window.postMessage({type:"ui",action:"gauges",food:12}, "http://localhost:3000/")
//     window.postMessage({type:"ui",action:"gauges",water:70}, "http://localhost:3000/")
//     window.postMessage({type:"ui",action:"gauges",id:5}, "http://localhost:3000/")
//     window.postMessage({type:"non",content:"non"}, "http://localhost:3000/")
//     window.postMessage({type:"ui",action:"progressbar",duration:2000,text:"Manger des saucisses"}, "http://localhost:3000/")
// }, 5000);


window.onload = () => {
    window.addEventListener('message', (event) => {
        var item = event.data;
        if (item !== undefined && item.type === "ui") {
            if (item.action == "gauges") {
                const gaugeComponent = document.getElementById("GaugesComponent") as HTMLElement;
                gaugeComponent.setAttribute("serverId", "8")
                gaugeComponent.setAttribute("display", item.display)
                gaugeComponent.setAttribute("oxygen", item.oxygen)
                gaugeComponent.setAttribute("hp", item.hp)
                gaugeComponent.setAttribute("food", item.food)
                gaugeComponent.setAttribute("water", item.water)
                gaugeComponent.setAttribute("serverId", item.id)
            } else if (item.action == "vehicle") {
                const vehicleComponent = document.getElementById("VehicleComponent") as HTMLElement;
                vehicleComponent.setAttribute("display", item.display)
                vehicleComponent.setAttribute("speed", item.speed)
                vehicleComponent.setAttribute("rpm", item.rpm)
                vehicleComponent.setAttribute("gear", item.gear)
                vehicleComponent.setAttribute("fuel", item.fuel)
                // vehicleComponent.setAttribute("crash", item.crash)
            } else if (item !== undefined && item.type === "ui" && item.action === "progressbar") {
                const progressbarComponent = document.getElementById("ProgressbarComponent") as HTMLElement;
                progressbarComponent.setAttribute("new", JSON.stringify({duration:item.duration, text:item.text}))
            }
        }
    })
}