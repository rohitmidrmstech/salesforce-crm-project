import { LightningElement } from 'lwc';

export default class HelloConditionalRendering extends LightningElement {
    isvisible = false
    name
    handleClick(){
      this.isvisible = true  
    }
    changeHandler(event){
        this.name = event.target.value
    }
  get  hellomethod(){
    return this.name === 'hello'
    }
}