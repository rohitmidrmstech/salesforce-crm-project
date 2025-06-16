import { LightningElement } from 'lwc';

export default class ParentComponent extends LightningElement {
    percentage= 10
    changehandler(event)  {
this.percentage = event.target.value
  }
  handleClick(event){
    this.template.querySelector('c-p2c-slider-component').resetSlider()
  }
  showModel = false
  clickHandler(){
    this.showModel = true
  }
  closeok(){
    this.showModel = false
  }

  
}