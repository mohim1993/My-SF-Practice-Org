/*
* @Purpose: Opportunity Line Items should be related to the current Budget_Cycle__c (Type - Forecast), so Kymera can track their sales pipeline against their Forecast.
* @Author: Cloud Haven Solutions - RD
* @CreatedDate: 
* @Related Code: chs_OpportunityTriggerLineItemTrigger,chs_OpportunityTriggerHandler
* @Test Class:
* @LastModifiedDate: 
* @LastModifiedBy: Cloud Haven Solutions-PC
*/
public class chs_OppLineItemTriggerHandler {
    public static Boolean isFirstRunning = True;
    public static void handleBeforeInsert(List<OpportunityLineItem> oppLineItems) {
            chs_OppLineItemTriggerHelper.updateForecastBudget(oppLineItems);
        }
}