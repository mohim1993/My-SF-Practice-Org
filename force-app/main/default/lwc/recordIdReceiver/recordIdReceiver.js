// recordIdReceiver.js
import { LightningElement, api } from 'lwc';

export default class RecordIdReceiver extends LightningElement {
    @api recordIdFromFlow;
}