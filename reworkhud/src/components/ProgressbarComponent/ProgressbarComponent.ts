import html from "./ProgressbarComponent.html?raw";
import style from "./ProgressbarComponent.scss";

interface ProgressBar {
    id: number,
    created: Date,
    duration: number
}

export class ProgressbarComponent extends HTMLElement {
    
    static get observedAttributes() { return ["new"];}

    bars: ProgressBar[] = []

    constructor() {
        super();
        this.attachShadow({mode: 'open'});
        this.shadowRoot!.innerHTML = html;
        const styleElement = document.createElement("style");
        styleElement.innerHTML = style;
        this.shadowRoot?.appendChild(styleElement);

        // this.createProgress(5000)
		// setTimeout(() => {
		// 	this.createProgress(2000, "Cuisson de la viande ...")
		// 	setTimeout(() => {
		// 		this.createProgress(2000)
		// 	}, 1000);
		// }, 1000);
    }


    connectedCallback() {
    }

    createProgress(duration: number, text?: string) {
        // let progress = this.shadowRoot!.querySelector<HTMLElement>('[id="progress"]');
		// progress!.style.width = "0%"
		// progress!.style.transition = "all "+duration/1000+"s linear";
		// setTimeout(() => {
		// 	progress!.style.width ="100%"
		// }, 10);
		let children
		for (let i = 0; i < this.shadowRoot!.childNodes.length; i++) {
			const element: any = this.shadowRoot!.childNodes[i];
			if(element.classList && element.classList.length > 0 && element.classList.contains("progressbar")){
				children = element
				break
			}
		}
		const progressContainer = document.createElement("div")
		progressContainer.classList.add("progressbar")
		if (text) {
			const span = document.createElement("span")
			span.innerText = text
			progressContainer.appendChild(span)
		}
		const progressBar = document.createElement("div")
		progressBar.classList.add("progress")
		progressBar.style.width = "0%"
		progressBar.style.transition = "all "+(duration-100)/1000+"s linear";
		progressContainer.appendChild(progressBar)
		if (children) {
			this.shadowRoot?.insertBefore(progressContainer, children);
		} else {
			this.shadowRoot?.appendChild(progressContainer);
		}
		setTimeout(() => {
			progressBar.style.width ="100%"
		}, 100);
		setTimeout(() => {
			progressContainer.style.animation = "slideout 0.5s forwards";
			setTimeout(() => {
				progressContainer.remove()
			}, 500);
		}, duration+150);
	}


    attributeChangedCallback(_name: string, _oldValue: string, newValue: string) {
		let json = JSON.parse(newValue)
		console.log(json.duration);
		console.log(typeof json.duration);
		
		this.createProgress(json.duration, json.text)
    }

}
customElements.define("progressbar-component", ProgressbarComponent);
