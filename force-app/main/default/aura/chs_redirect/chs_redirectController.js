({
    invoke: function(component, event, helper) {
            console.log();
            try{
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get("v.recordId"),
                    "slideDevName": "related"
                });
                navEvt.fire();
            }catch(err){
                window.location.href= 'https://inovi57-dev-ed.develop.my.salesforce.com/'+component.get("v.recordId");
            }finally{
                window.location.href= 'https://inovi57-dev-ed.develop.my.salesforce.com/'+component.get("v.recordId");
            }
                
    }
})