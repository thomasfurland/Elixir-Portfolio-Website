const sidebar = document.createElement("template")
sidebar.innerHTML = /*html*/`
    <style>
        :host {
            --space: 1rem;
            display: flex;
        }

        #sidebar,
        #toggle {
            display: inherit;  
        }

        #sidebar {
            width:125px;
        }

        #toggle {
            width: 25px;
        }

        #savior {
            display: flex;
            position: fixed;
            width:150px;
            z-index: 5;
            justify-content: space-between;
            background-color: inherit;
            padding: calc(var(--space));
            height: 100%;
        }

        #toggle-btn {
            height: 25px;
            width: 25px;
            margin: 0;
            padding: 0;
            background: rgba(0,0,0,0);
            border: none;
        }

        #toggle-btn:hover {
            cursor:pointer;
        }

        #content {
            overflow-x: hidden;
            width:100%;
            padding-left: 150px;
            background-color: white;
        }

        #sidebar > ::slotted(*){
            flex-grow: 1;
            display: flex !important;
        }

        #content > ::slotted(*) {
            flex-grow: 999;
            flex-basis: 0;
        }   

    </style>
    <div id="savior">
    <div id="sidebar">
        <slot name="sidebar"></slot>
    </div>
    <div id="toggle">
        <button id="toggle-btn"> 
            <slot name="toggle-icon"></slot>
        </button>
    </div>
    </div>
    <div id="content">
        <slot name="content"></slot>
    </div>
 `
export class SidebarLayout extends HTMLElement {

    get toggle() {
        const val = this.getAttribute('toggle') ?? 'true'
        const boolVal = (val.toLowerCase() === 'true')
        return boolVal
    }

    set toggle(val) {
        return this.setAttribute('toggle', new Boolean(val))
    }

    constructor() {
        super()
        const shadowRoot = this.attachShadow({ mode: "open" })
        shadowRoot.appendChild(sidebar.content.cloneNode(true))
    }

    connectedCallback() {
        if(!this.isConnected) return
        if(!window.ResizeObserver) console.log("Resize observer not supported")
        this.observer = new ResizeObserver((entries, observer) => this.onResize(entries, observer))
        this.observer.observe(this)

        const btn = this.shadowRoot.getElementById("toggle-btn")
        btn.addEventListener("click", e => this.onToggle())

        const content = this.shadowRoot.getElementById("content")
        content.addEventListener("click", e => this.onShow())

        this.breakpoint = 700

        //to help reduce stuttering from divs when loading pages.
        document.documentElement.style.visibility = "visible"
    }

    onResize(entries, observer) {
        for(let entry of entries) {
            switch(entry.target.tagName) {
                case "SIDEBAR-LAYOUT":
                    if(this.toggle) {
                        const dim = entry.contentRect
                        const sidebar = this.shadowRoot.getElementById("sidebar");
                        //added second point to eliminate stuttering when using only one.
                        if(dim.width >= this.breakpoint + 50 && dim.width > this.breakpoint) {
                            this.showSidebar()
                        }else {
                            this.hideSidebar()
                        } 
                    }
            }
            
        }

    }

    onToggle(event) {
        const sidebar = this.shadowRoot.getElementById("sidebar");
        if (sidebar.style.display  === "") {
            this.hideSidebar()
            this.toggle = false
        } else {
            this.showSidebar()
            this.toggle = true
        }  
    }

    onShow(event) {
        if(this.offsetWidth < this.breakpoint) {
            const sidebar = this.shadowRoot.getElementById("sidebar");
            if (sidebar.style.display  === "") {
                this.hideSidebar()
                this.toggle = false
            }
        }
    }

    showSidebar() {
        const sidebar = this.shadowRoot.getElementById("sidebar");
        const savior = this.shadowRoot.getElementById("savior");
        const content = this.shadowRoot.getElementById("content");
        sidebar.style.display = ""
        savior.style.width = "150px"
        content.style.paddingLeft = "150px"
        savior.style.backgroundColor = "inherit"
    }

    hideSidebar() {
        const sidebar = this.shadowRoot.getElementById("sidebar");
        const savior = this.shadowRoot.getElementById("savior");
        const content = this.shadowRoot.getElementById("content");
        sidebar.style.display = "none"
        savior.style.width = "25px"
        content.style.paddingLeft = "25px"
        savior.style.backgroundColor = "unset"
    }
}
customElements.define("sidebar-layout", SidebarLayout)