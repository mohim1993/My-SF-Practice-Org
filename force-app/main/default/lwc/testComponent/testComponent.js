import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { FlowNavigationFinishEvent } from 'lightning/flowSupport';

export default class ToastInLightningFlow extends LightningElement {
    @api mode;
    @api variant;
    @api message;
    @api title

    connectedCallback() {
        console.log(11111111);
        this.handleShowToast();
      // this.handoverCloseAction();
    }

    handleShowToast() {
        console.log(2222222);
        const event = new ShowToastEvent({
        title: this.title,
        message: this.message,
        variant: this.variant,
        mode: this.mode
    });

    console.log(33333333);
        this.dispatchEvent(event);

          console.log(4444444);
    }

    handoverCloseAction() {
        const navigateNextEvent = new FlowNavigationFinishEvent();
        this.dispatchEvent(navigateNextEvent);
    }
}