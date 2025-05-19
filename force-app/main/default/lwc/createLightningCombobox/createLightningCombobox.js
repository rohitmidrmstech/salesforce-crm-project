import { LightningElement,wire,track } from 'lwc';
import getValid8list from '@salesforce/apex/Valid8Controller.getValid8list';
export default class CreateLightningCombobox extends LightningElement {
     datavalue=[];

connectedCallback(){
    
}
name ;
middle;
Last ;
id ;
handleNameChange(event){
this.name = event.target.value;
console.log('first Name is::'+this.name );
}
handleMiddleChange(event){
this.middle = event.target.value;
console.log('Middle Name is::'+this.middle );

}
handleLastChange(event){
this.Last = event.target.value;
console.log('Last Name is::'+this.Last  );

}
handleidChange(event){
this.id = event.target.value;
console.log('UD is::'+this.id );

}
UpdateText(){
    if(this.name != null){
        console.log('Updatetext Name is ::'+ this.name);
    
    // for(let i=0; i<this.datavalue.length; i++){
    //     console.log('first name is:::'+ this.datavalue[i].namevalue);
    //     if(this.datavalue[i].namevalue === this.name){
    //         this.name =this.datavalue[i].namevalue;
    //         this.middle=this.datavalue[i].middlenvalue;
    //         this.Last= this.datavalue[i].Lastnvalue;
    //         this.id = this.datavalue[i].idvalue;
    //     }
    // }
    this.datavalue=[
        {
    namevalue: 'Rohit',
     middlenvalue: 'Madhukarrao',
     Lastnvalue: 'Chormalle',
     idvalue: '2',
     Action : ''
},
{
    namevalue: 'ganesh',
    middlenvalue: 'k',
    Lastnvalue :'gupta',
    idvalue : '4',
    Action : ''

        }

      
];
    }
    
console.log('the name value is::555' + this.datavalue);


}
handleClick(event){

}

}