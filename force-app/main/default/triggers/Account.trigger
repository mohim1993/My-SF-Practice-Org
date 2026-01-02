trigger Account on Account (before insert, before update, after insert, after update, after delete) {
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            
            for (Account oldAccount : Trigger.old) {
                system.debug('Before Update old Account Name'+oldAccount.Name);
            }
            
            for (Account newAccount : Trigger.new) {
                system.debug(' before update Account Name'+newAccount.Name);
            }
        }
        // Add other before triggers if needed (e.g., before insert, before delete)
    } else if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            for (Account oldAccount : Trigger.old) {
                system.debug('After Update old Account Name'+oldAccount.Name);
            }
            
            for (Account newAccount : Trigger.new) {
                system.debug('After Update new Account Name'+newAccount.Name);
                
            }
        }
    }
    
}