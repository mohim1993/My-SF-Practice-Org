@isTest
private class Askia_AccountTriggerExampleTest{
    @isTest
    static void testCreateContactForAccount_NoExistingContacts() {
        // Create a test Account without any associated Contacts
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Trigger the handler
        Askia_AccountTriggerHandler.createContactForAccount(new List<Account>{acc});

        // Retrieve the inserted Contacts
        List<Contact> insertedContacts = [SELECT FirstName, LastName, Title, AccountId FROM Contact WHERE AccountId = :acc.Id];

        // Assert that the Contacts are inserted correctly
        System.assertEquals(2, insertedContacts.size(), 'Contacts are not inserted correctly');
        for (Contact con : insertedContacts) {
            System.assertEquals('test', con.FirstName, 'Contact is not inserted correctly');
            System.assertEquals('test', con.LastName, 'Contact is not inserted correctly');
            System.assertEquals(acc.Name, con.Title, 'Contact Title is not set correctly');
            System.assertEquals(acc.Id, con.AccountId, 'Contact is not associated with the Account');
        }
    }

    /*@isTest
    static void testCreateContactForAccount_WithExistingContacts() {
        // Create a test Account with an associated Contact
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact con = new Contact(FirstName = 'John', LastName = 'Doe', Title = acc.Name, AccountId = acc.Id);
        insert con;

        // Trigger the handler
        Askia_AccountTriggerHandler.createContactForAccount(new List<Account>{acc});

    }*/
}