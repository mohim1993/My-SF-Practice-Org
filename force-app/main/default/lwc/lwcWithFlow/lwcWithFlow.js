import { LightningElement,api } from 'lwc';

export default class LwcWithFlow extends LightningElement {
    @api requiredBool;
    @api label;
    @api optionJSON;
    @api selectedvalue;

    connectedCallback(){
        this.parsedOptions = JSON.parse(this.optionJSON);
    }

    renderedCallback(){
        this.template.querySelectorAll('lightning-input').forEach(element => {
           if(element.value === this.selectedvalue){
            element.checked = true;
           }
        });
    }

    onRadioButtonChange(event){
        this.selectedvalue = event.target.value;
        this.template.querySelectorAll('lightning-input').forEach(element => {
            if(element.value === this.selectedvalue){
                element.checked = true;
            }else{
                element.checked = false;
            }
         });
    }

}