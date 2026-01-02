public class AssignmentSlider {
	 @AuraEnabled(cacheable=true)
    public static String getAssignmentValue(Id recordId){
        System.debug('recordId -> ' + recordId);
        Account acc = [SELECT Id, AccountNumber FROM Account WHERE Id = :recordId];
        return acc.AccountNumber;
    } 
}