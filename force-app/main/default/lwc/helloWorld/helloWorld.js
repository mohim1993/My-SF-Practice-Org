import { LightningElement,track } from 'lwc';

export default class MyComponent extends LightningElement {
   
    @track isRecordIdValid;

    connectedCallback(){
        var recordId = 'aa65g00000RAOkGAAX';
        const isValidLength = recordId.length === 15 || recordId.length === 18;
        const isValidCharacters = /^[a-zA-Z0-9]*$/.test(recordId);
        if(isValidLength && isValidCharacters){
            this.isRecordIdValid = 'valid';
        }else{
            this.isRecordIdValid = 'invalid';
        }
        }

}