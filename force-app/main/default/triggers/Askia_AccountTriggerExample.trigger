trigger Askia_AccountTriggerExample on Account (before insert,before update,before delete,after insert, after update,after delete) {
    if(trigger.isAfter){
        List<Account> accountsToUpdate = new List<Account>();
        for (Account acc : Trigger.new) {
            system.debug('i am inside trigger');
            accountsToUpdate.add(acc);
        }
        
        if (!accountsToUpdate.isEmpty()) {
            Askia_AccountTriggerHandler.createContactForAccount(accountsToUpdate);
        }
    }
    
}