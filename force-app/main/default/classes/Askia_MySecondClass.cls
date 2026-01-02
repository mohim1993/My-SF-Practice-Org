public class Askia_MySecondClass {
    public static void createContactForAccount(Account acc, Contact con) {
        con.AccountId = acc.Id;
        insert con;
    }

    public static void createOpportunityForContact(Contact con, Opportunity opp) {
        opp.AccountId = con.AccountId;
        opp.ContactId = con.Id;
        insert opp;
    }
}