import { LightningElement } from 'lwc';
import JRLogo from '@salesforce/resourceUrl/JGLogo';
import { NavigationMixin } from 'lightning/navigation';
export default class InteterviewHeader extends NavigationMixin(LightningElement) {

    LogoUrl = JRLogo;
    handleClick(){
     let    url="https://www.jungleerummy.com/client/lobby/cash-games/points-13";
        window.location(url);
    }
}