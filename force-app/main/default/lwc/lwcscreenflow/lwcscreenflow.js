import { LightningElement,api } from 'lwc';
import { FlowNavigationFinishEvent } from 'lightning/flowSupport';

export default class Lwcscreenflow extends LightningElement {
    @api name = 'test';

   handleFinish() {
        //alert(100);
        this.dispatchEvent(new FlowNavigationFinishEvent());
    }
}