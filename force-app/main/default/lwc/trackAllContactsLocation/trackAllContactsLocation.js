import { LightningElement, wire } from 'lwc';
//import { loadScript } from 'lightning/platformResourceLoader';
import getContactsByDate from '@salesforce/apex/contactFindOutGoogleMapLocation.getContactsByDate';
//import GOOGLE_MAPS_API from '@salesforce/resourceUrl/GoogleMapsAPI';
export default class TrackAllContactsLocation extends LightningElement {
    mapMarkers;
    mapCenter;
    map;
    contacts;
    errorMsg;
    dateValue;
    parsedValue;
     date;
    mapMarkers = [];
mapZoomLevel = 10;
mapcenter

 handledateChange(event){
    this.dateValue = event.target.value;
    console.log('dateValue Is ' + this.dateValue);
   }

 handleSubmit(){
    console.log('button click called');
     getContactsByDate()
    .then(result =>{
        console.log('result' + JSON.stringify(result))
        this.contacts = JSON.parse(JSON.stringify(result));
        console.log('He '+this.contacts.Geolocation__c.latitude+' '+this.contacts.Geolocation__c.longitude)
        let temp = {
            location: {
             Latitude: this.contacts.Geolocation__c.latitude,
             Longitude: this.contacts.Geolocation__c.longitude
            },
            value: 'SF1',
            title: 'Pune',
            description: 'City of Dreams'
        }
        console.log('Here 1')
        this.mapMarkers.push(temp);
        console.log('Here 2')
        let centerTemp = {
                location: {
                Latitude: this.contacts.Geolocation__c.latitude,
                Longitude:this.contacts.Geolocation__c.longitude
            }
          };
          console.log('Here 3')
        this.mapCenter = centerTemp

         console.log('this.contacts' + JSON.stringify(this.contacts ));
     })
     .catch(error =>{
     this.errorMsg = error;
    })
  }
    handleMarkerClick(event) {
        const markerDetail = event.detail;
            const selectedMarkerValue = markerDetail.selectedMarkerValue;
            console.log('Marker Selected: ' + selectedMarkerValue);
          }
}