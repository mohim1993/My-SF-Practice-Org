import { LightningElement, track, api, wire } from 'lwc';
import { subscribe, onError } from 'lightning/empApi';
import getMessages from '@salesforce/apex/MessagingController.getMessages';
import sendMessage from '@salesforce/apex/MessagingController.sendMessage';
import USER_ID from '@salesforce/user/Id';

export default class ChatBoxx extends LightningElement {
    @api recipientId;
    @track messages = [];
    newMessage = '';
    subscription = {};
    userId = USER_ID;

    // Load past messages
    @wire(getMessages, { recipientId: '$recipientId' })
    wiredMessages({ data, error }) {
        if (data) {
            this.messages = data.map(msg => ({
                Id: msg.Id,
                Sender__c: msg.Sender__c,
                SenderName: msg.Sender__r ? msg.Sender__r.Name : 'Unknown',
                Text__c: msg.Text__c,
                cssClass: msg.Sender__c === this.userId ? 'outgoing' : 'incoming'
            }));
        }
    }

    handleInput(event) {
        this.newMessage = event.target.value;
    }

    sendMessage() {
        if (this.newMessage) {
            sendMessage({ recipientId: this.recipientId, messageText: this.newMessage })
                .then(result => {
                    const formattedMsg = {
                        Id: result.Id,
                        Sender__c: result.Sender__c,
                        SenderName: result.Sender__r ? result.Sender__r.Name : 'You',
                        Text__c: result.Text__c,
                        cssClass: result.Sender__c === this.userId ? 'outgoing' : 'incoming'
                    };
                    this.messages = [...this.messages, formattedMsg];
                    this.newMessage = '';
                })
                .catch(error => {
                    console.error('Error sending message:', error);
                });
        }
    }
    connectedCallback() {
        this.subscribeToEvent();
    }

    subscribeToEvent() {
        const channel = '/event/Message_Event__e';
        subscribe(channel, -1, eventReceived => {
            const payload = eventReceived.data.payload;
            
            if (
                (payload.SenderId__c === this.recipientId && payload.RecipientId__c === this.userId) ||
                (payload.SenderId__c === this.userId && payload.RecipientId__c === this.recipientId)
            ) {
                this.messages = [...this.messages, {
                    Id: Date.now(),
                    Sender__c: payload.SenderId__c,
                    SenderName: payload.SenderId__c === this.userId ? 'You' : 'Other',
                    Text__c: payload.Text__c,
                    cssClass: payload.SenderId__c === this.userId ? 'outgoing' : 'incoming'
                }];
            }
        });
    }
}