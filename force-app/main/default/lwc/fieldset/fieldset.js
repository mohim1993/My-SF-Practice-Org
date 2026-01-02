import { LightningElement, api, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class fieldSet extends LightningElement {
    @api recordId;

    @wire(getObjectInfo, { objectApiName: 'Account' })
    objectInfo;

    get accountFields() {
        if (this.objectInfo.data) {
            const fieldSet = this.objectInfo.data.fields.TestFieldSet;
            const fieldsMap = {};
            
            Object.keys(this.objectInfo.data.fields[fieldSet].fields).forEach((fieldApiName) => {
                fieldsMap[fieldApiName] = this.account[fieldApiName];
            });
            
            return fieldsMap;
        }
        return {};
    }

    get account() {
        return this.objectInfo.data;
    }
}