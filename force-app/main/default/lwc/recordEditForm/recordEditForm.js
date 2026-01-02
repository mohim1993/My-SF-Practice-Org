import { LightningElement } from 'lwc';
export default class RecordEditForm extends LightningElement {
    handleSuccess(event) {
        alert('handleSuccess');
    }
    handleSubmit(event) {
        alert('handleSubmit');
    }
}