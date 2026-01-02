@isTest
private class Askia_MySecondClassTest {
    @isTest
    static void testCreateContactForAccount() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact con = new Contact(FirstName = 'John', LastName = 'Doe');
        Askia_MySecondClass.createContactForAccount(acc, con);

        // Retrieve the inserted Contact
        Contact insertedContact = [SELECT AccountId FROM Contact WHERE Id = :con.Id];
        
        // Assert that the AccountId on the Contact matches the Account Id passed to the method
        System.assertEquals(acc.Id, insertedContact.AccountId, 'Account Id does not match');
    }

    @isTest
    static void testCreateOpportunityForContact() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact con = new Contact(FirstName = 'John', LastName = 'Doe');
        insert con;

        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', CloseDate = Date.today(), Amount = 1000);
        Askia_MySecondClass.createOpportunityForContact(con, opp);

        // Retrieve the inserted Opportunity
        Opportunity insertedOpportunity = [SELECT AccountId, ContactId FROM Opportunity WHERE Id = :opp.Id];

        // Assert that the AccountId and ContactId on the Opportunity match the corresponding Account and Contact Ids passed to the method
        System.assertEquals(con.AccountId, insertedOpportunity.AccountId, 'Account Id does not match');
        System.assertEquals(con.Id, insertedOpportunity.ContactId, 'Contact Id does not match');
    }
}