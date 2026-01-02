public class chs_OppLineItemTriggerHelper {
    public static void updateForecastBudget(List<OpportunityLineItem> oppLineItems) {
        
        system.debug('oppLineItems'+oppLineItems);
        List<OpportunityLineItem> listOLI = [SELECT Id
                                             FROM OpportunityLineItem 
                                             WHERE Id IN :oppLineItems]; 
        
        
        system.debug('listOLI'+listOLI);
    }
}