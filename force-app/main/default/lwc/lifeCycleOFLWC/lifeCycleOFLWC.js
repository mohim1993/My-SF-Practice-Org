import { LightningElement,track } from 'lwc';

export default class LifeCycleOFLWC extends LightningElement {
    @track trackingText = 'Hello World';

    constructor() {
    console.log('CONNECTED CALLBACK');
        super();
    }

    connectedCallback(){
    	console.log('CONNECTED CALLBACK');
    }
    renderedCallback(){
    	console.log('RENDERED CALLBACK');
    }
    disconnectedCallback(){
    	console.log('DISCONNECTED CALLBACK');
    }
    errorCallback(){
    	console.log('ERROR CALLBACK');
    }

    handleClick(event){
            this.trackingText = 'Text Changed';
    }

}