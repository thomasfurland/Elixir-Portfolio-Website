const switcher = document.createElement("template")
switcher.innerHTML = `
    <style>
        :host {
            --space: 1rem;
            --measure: 60ch
        }
        
        .container {
            background:inherit;
        }

        slot{
            display: flex;
            flex-wrap: wrap;
            margin: calc(var(--space) / 2) * -1);
        }

        ::slotted(*) {
            flex-grow: 1;
            flex-basis: calc((var(--measure) - (100% - var(--space))) * 999);
            margin: calc(1rem / 2);
        }   
    </style>
    <div class="container">
        <slot name="switcher"></slot>
    </div>
 `
export class SwitcherLayout extends HTMLElement {
    constructor() {
        super()
        const shadowRoot = this.attachShadow({ mode: "open" })
        shadowRoot.appendChild(switcher.content.cloneNode(true))
    }
}
customElements.define("switcher-layout", SwitcherLayout)