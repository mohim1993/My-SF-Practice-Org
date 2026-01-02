global class invocableAsynchonousStudy {
    
    @InvocableMethod(label='invocableAsyncStudy')
    global static List<ActionResult> inokefunctions(List<ActionRequest> reqWrap) {
        List<ActionResult> listresults = new List<ActionResult>();
        ActionResult result = new ActionResult();
        result.status = 'Success';
        result.error = '';
        
        try {
            for (ActionRequest wrap : reqWrap) { 
                system.debug('wrap----'+wrap);
                string endPoint									= 'https://restcountries.com/v3.1/all';
                HttpRequest request								=  new HttpRequest();
                request.setEndpoint(endPoint);
                request.setMethod('GET'); 
                
                Http http                                    	= new Http();
                HTTPResponse response                        	= http.send(request);
                system.debug('response'+response.getBody());
                system.debug('response'+response.getStatus());
                if(response.getStatusCode() != 200){
                    return null;
                } 
            }
            
            result.status = 'Success';
            system.debug('In invocableAsynchonousStudy');
        } catch (Exception e) {
            result.status = 'Error';
            result.error = e.getMessage();
        }
        
        listresults.add(result);
        return listresults;        
    }
    
    
    global class ActionRequest {
        @InvocableVariable(required=true)
        global String opportunityId;
    }
    
    global class ActionResult {
        @InvocableVariable
        global String status;
        
        @InvocableVariable
        global String error;
    }
    
}