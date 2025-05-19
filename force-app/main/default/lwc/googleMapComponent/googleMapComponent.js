import { LightningElement } from 'lwc';

export default class GoogleMapComponent extends LightningElement {
 markers = [
  {
      location: {
       Latitude: 18.5204,
       Longitude: 73.8567
      },
      title: 'Pune',
      description: 'City of Dreams'
  }
];

zoomLevel = 10;

mapCenter = {
  location: {
      Latitude: 18.5204,
      Longitude: 73.8567
  }
};

handleMarkerClick(event) {
  const markerDetail = event.detail;
  const selectedMarkerValue = markerDetail.selectedMarkerValue;
  console.log('Marker Selected: ' + selectedMarkerValue);
}
}