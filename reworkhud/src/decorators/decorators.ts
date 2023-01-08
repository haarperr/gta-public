
interface ComponentConfig {
    selector:string;
    template?: string;
    templateUrl?: string;
    style?: string;
    styleUrl?: string;
    useShadow?: boolean;
}

const validateSelector = (selector: string) => {
    if (selector.indexOf('-') <= 0) {
        throw new Error('You need at least 1 dash in the custom element name!');
    }
};

export const Component = (config: ComponentConfig) => (cls: CustomElementConstructor) => {
    validateSelector(config.selector);
    if (!config.template) {
        throw new Error('You need to pass a template for the element');
    }
    const template = document.createElement('template');
    if (config.style) {
        config.template = `<style>${config.style}</style> ${config.template}`;
    }
    template.innerHTML = config.template;

    if (config.templateUrl) {
        // import html from config.templateUrl;
        let html = require(config.templateUrl)
        console.log(html);
        
    }

    const connectedCallback = cls.prototype.connectedCallback || function () {};
    cls.prototype.connectedCallback = function() {
        const clone = document.importNode(template.content, true);
        if (config.useShadow) {
            this.attachShadow({mode: 'open'}).appendChild(clone);
        } else {
            this.appendChild(clone);
        }
        connectedCallback.call(this);
    };

    window.customElements.define(config.selector, cls);
};


export function WatchAttribute (watchAttr: any, handler: string | number) {
    return function (target : any) {
      var attributeChangedCallback = target.prototype.attributeChangedCallback || function () {};
  
      var callback = (typeof handler === 'function') ? handler : target.prototype[handler];
  
      if (!callback) {
        throw new Error(`@watchAttribute: '${handler}' does not exist on '${target.name}'`);
      }
  
      target.prototype.attributeChangedCallback = function (attr: string, oldValue: string, newValue: string) {
        if (watchAttr === attr) {
          callback.call(this, oldValue, newValue);
        }
  
        attributeChangedCallback.call(this, attr, oldValue, newValue);
      };
    };
  }