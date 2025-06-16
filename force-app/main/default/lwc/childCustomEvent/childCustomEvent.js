import { LightningElement } from 'lwc';

export default class ChildCustomEvent extends LightningElement {
    HandleClick(){
      this.dispatchEvent(new CustomEvent('increasecount'));
    }
}