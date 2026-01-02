public with sharing class MessagingController {

    // Get all messages involving the current user
    @AuraEnabled(cacheable=true)
    public static List<Message__c> getMessages() {
        return [
            SELECT Id, Sender__c, Sender__r.Name, Recipient__c, Recipient__r.Name, Text__c, CreatedDate
            FROM Message__c
            WHERE Sender__c = :UserInfo.getUserId() OR Recipient__c = :UserInfo.getUserId()
            ORDER BY CreatedDate ASC
        ];
    }

    // Send a message to a recipient
    @AuraEnabled
    public static Message__c sendMessage(Id recipientId, String messageText) {
        Message__c msg = new Message__c(
            Sender__c = UserInfo.getUserId(),
            Recipient__c = recipientId,
            Text__c = messageText
        );
        insert msg;

        // Re-query to get the Sender__r.Name
        msg = [SELECT Id, Sender__c, Sender__r.Name, Recipient__c, Recipient__r.Name, Text__c 
               FROM Message__c WHERE Id = :msg.Id];

        // Publish Platform Event for real-time update
        Message_Event__e eventMessage = new Message_Event__e(
            SenderId__c = UserInfo.getUserId(),
            RecipientId__c = recipientId,
            Text__c = messageText
        );
        EventBus.publish(eventMessage);

        return msg;
    }

   @AuraEnabled(cacheable=true)
public static List<Map<String, String>> getActiveUsers() {
    List<User> allUsers = [SELECT Id, Name, IsActive FROM User ORDER BY Name];
    List<Map<String, String>> options = new List<Map<String, String>>();
    for(User u : allUsers){
        if(u.IsActive){
            options.add(new Map<String, String>{'label' => u.Name, 'value' => u.Id});
        }
    }
    return options;
}

}