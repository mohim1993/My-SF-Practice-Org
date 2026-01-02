trigger Opportunitytrigger on Opportunity  (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            
        }
        if(Trigger.isUpdate){
            OpportunitytriggerHandler.beforeUpdate(Trigger.new, Trigger.newMap,Trigger.oldMap);
        } 
    }
    if(Trigger.isAfter){
        if(Trigger.isInsert){ 
            
        }
        if(Trigger.isUpdate){
           // OpportunitytriggerHandler.afterUpdate(Trigger.new, Trigger.newMap,Trigger.oldMap);
        } 
    }
}