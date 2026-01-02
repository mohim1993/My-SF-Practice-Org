@isTest
public class Askia_MyApexExtensionTest {
    @isTest
    static void testMyApexExtension() {
        // Create a test record
        Account account = new Account(Name = 'Test Account');
        insert account;
        
     
        ApexPages.StandardController stdController = new ApexPages.StandardController(account);
        
        Askia_MyApexExtension controllerExt = new Askia_MyApexExtension(stdController);
        
        PageReference pageRef = Page.Askia_MyVisualforcePage;
       
        ApexPages.currentPage().getParameters().put('id', account.Id);
        
        String accountName = controllerExt.getAccountName();
        
        System.assertEquals('Test Account', accountName);
    }
}