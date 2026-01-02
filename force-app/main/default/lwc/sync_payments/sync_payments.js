import { LightningElement, api,wire } from 'lwc';

import invokefunctions from '@salesforce/apex/Sync_payments.executecalloutToQBToCreateInvoice'; 

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { FlowNavigationFinishEvent } from 'lightning/flowSupport';
export default class Lwcqademo extends LightningElement {
    @api recordId;

    connectedCallback() {
        this.recordId = this.getRecordIdFromUrl();
        console.log(this.recordId);
       
        invokefunctions({ invoiceId: this.recordId })
            .then(result => {
                this.recordName = result;
            })
            .catch(error => {
                console.error('Error fetching record name:', error);
            });
    }

    getRecordIdFromUrl() {
        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        return urlParams.get('recordId');
    }
}