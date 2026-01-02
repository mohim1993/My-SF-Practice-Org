trigger opportunitylineitemTrigger on OpportunityLineItem (before insert, before update, after insert, after update) {
	 /*if(Trigger.isBefore && Trigger.isInsert){
          chs_OppLineItemTriggerHandler.handleBeforeInsert(Trigger.new);
    }*/
    
    if(trigger.isAfter && trigger.isInsert){
        
        OpportunityLineItem oli = Trigger.new[0];
        OpportunityLineItem oli2 = new OpportunityLineItem(id= oli.id);
        oli2.Description = 'updated desc';
        update oli2; 
        
        /*OpportunityLineItem oli = Trigger.new[0];
        oli.Description = 'updated desc';
        update oli; */
         // chs_OppLineItemTriggerHandler.handleBeforeInsert(Trigger.new);
    }
    
    if(trigger.isBefore && trigger.isUpdate){}
    
    if(trigger.isAfter && trigger.isUpdate){
        /*OpportunityLineItem oli = Trigger.new[0];
        OpportunityLineItem oli2 = new OpportunityLineItem(id= oli.id);
        oli2.Description = 'updated desc';
        update oli2;*/ 
    }
}