import { LightningElement, wire,track } from 'lwc';
import getHelpCenter from '@salesforce/apex/getHelpCenterData.getHelpCenter';

export default class TracjUserData extends LightningElement {
    userTrackData;
    userData;
    @wire(getHelpCenter)
    userTrackData;
    handleclick(){
        getHelpCenter()
            .then(result => {
                this.userData = result;
                console.log('userData data  is'+ JSON.stringify(this.userData));
        })
        .catch( error=>{
            this.userData = null;
            console.log('error data  is'+ JSON.stringify(this.userData));
        });
        }
        

    }