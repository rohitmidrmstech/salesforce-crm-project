import { LightningElement } from 'lwc';

export default class LwcRefToAccessDomElement extends LightningElement {


 Submithandler(){
  console.log('Handler Called');
  const nameref = this.refs.nameRef.value;
  const ageref = this.refs.ageRef.value;
  console.log('Name is ' + nameref);
  console.log('Age is ' + ageref);


 }
}