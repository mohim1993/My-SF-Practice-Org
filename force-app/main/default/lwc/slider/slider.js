import { LightningElement, api, wire } from 'lwc';

import { ShowToastEvent} from 'lightning/platformShowToastEvent'
import getAssignmentValue from '@salesforce/apex/AssignmentSlider.getAssignmentValue'
import { refreshApex } from '@salesforce/apex';

export default class Assignment_Slider extends LightningElement {
    @api recordId;
    @api val;
    @api step;
    @api maxVal;
    @api minVal; 

    handleChange(event){
        this.val = event.detail.value;
        console.log(this.val);
    }

    @wire(getAssignmentValue, { recordId: '$recordId' })
    wiredRecord({ error, data }) {
        if (data) {
            alert('wire');
            console.log('i am inside wire this data'+this.data);
            console.log('i am inside wire data'+data);
            this.val = data;
        } else if (error) {
            console.error('Error fetching record data', error);
        }
    }
    showToast(title,message, variant){
        this.dispatchEvent(new ShowToastEvent({
            title,
            message,
            variant
        }))
    }
}