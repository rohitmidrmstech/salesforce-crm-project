import { LightningElement,track } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import GOOGLE_MAPS from '@salesforce/resourceUrl/googleMaps';
export default class ChatGptGetGoogleMapDirection extends LightningElement {
 map;
 @track startPoint;
    @track endPoint;
    DIRECTION_API;
 renderedCallback() {
     Promise.all([
         loadScript(this, GOOGLE_MAPS),
         loadScript(this, DIRECTION_API),
     ]).then(() => {
         this.initializeMap();
     }).catch((error) => {
         console.error(error);
         this.dispatchEvent(
             new ShowToastEvent({
                 title: 'Error loading Google Maps',
                 message: error.message,
                 variant: 'error'
             })
         );
     });
 }


 initializeMap() {
     this.map = new google.maps.Map(this.template.querySelector('#map'), {
         center: { lat: 37.7749, lng: -122.4194 },
         zoom: 12
     });
 }

 getDirections() {
     const directionsService = new google.maps.DirectionsService();
     const directionsRenderer = new google.maps.DirectionsRenderer();
     directionsRenderer.setMap(this.map);

     const start = new google.maps.LatLng(37.7749, -122.4194);
     const end = new google.maps.LatLng(37.3352, -121.8811);

     const request = {
         origin: start,
         destination: end,
         travelMode: google.maps.TravelMode.DRIVING
     };

     directionsService.route(request, (result, status) => {
         if (status === google.maps.DirectionsStatus.OK) {
             directionsRenderer.setDirections(result);
         } else {
             console.error(status);
         }
     });
 }
}