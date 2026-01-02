public class Askia_MyApexExtension {
    private ApexPages.StandardController standardController;

    public Askia_MyApexExtension(ApexPages.StandardController controller) {
        standardController = controller;
    }

    public String getAccountName() {
        Account account = (Account)standardController.getRecord();
        return account.Name;
    }
}