import { LightningElement } from 'lwc';

export default class C2pModelComponent extends LightningElement {
    closehandler(){
        const myevent =new CustomEvent('close')
        this.dispatchEvent(myevent)

    }
}