import { LightningElement ,track} from 'lwc';
import getAllOrder from '@salesforce/apex/dynamicMapController.getAllOrder'; 

export default class TrackAllContactMapLocation extends LightningElement {
 @track loaded = true;
 dateValue;
 handledateChange(event){
  this.dateValue = event.target.value;
  console.log('dateValue Is ' +  this.dateValue);

 }

    applyFilter(event) {
        this.loaded = false;
       
        window.console.log(event);
 
        getAllOrder({sdate: this.dateValue})
            .then(result => {
             console.log('result is ' +JSON.stringify(result));
                window.console.log(result);
                this.mapMarkers = JSON.parse(result);
                console.log('this.mapMarkers ' + JSON.stringify(this.mapMarkers));

                this.markersTitle = "Contact Records";
                this.orders = result;
                this.loaded = true;
            })
            .catch(error => {
                this.error = error;
                this.loaded = true;
            });
    }


}