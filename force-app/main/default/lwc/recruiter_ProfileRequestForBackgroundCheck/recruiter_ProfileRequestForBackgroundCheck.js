import { LightningElement ,api} from 'lwc';

export default class Recruiter_ProfileRequestForBackgroundCheck extends LightningElement {

    showModal = false;

  @api show() {
    this.showModal = true;
  }
  handleDialogClose() {
    this.showModal = false;
  }
}