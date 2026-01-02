public class Askia_AccountTriggerHandler {
    public static void createContactForAccount(List<Account> accounts) {
        List<String> listAccountName = new List<String>();
        for(Account acc : accounts){
            listAccountName.add(acc.Name); 
        }
        List<Contact> contactsToInsert = new List<Contact>();
        List<Contact> listExistingContact = [Select AccountId from Contact where Title IN :listAccountName];
        if(listExistingContact.isEmpty()){
            for (Account acc : accounts) {
                    Contact newContact = new Contact();
                    newContact.FirstName = 'test';
                    newContact.lastName = 'test';
                    newContact.Title = acc.Name;
                    newContact.AccountId = acc.Id;
                    contactsToInsert.add(newContact);
                    
                    Contact newContact2 = new Contact();
                	newContact2.FirstName = 'test';
                    newContact2.lastName = 'test';
                    newContact2.Title = acc.Name;
                    newContact2.AccountId = acc.Id;
                    contactsToInsert.add(newContact2);                
                }
        }
        
        if (!contactsToInsert.isEmpty()) {
            system.debug('i am inside trigger handler dml');
            insert contactsToInsert;
        }
    }
}