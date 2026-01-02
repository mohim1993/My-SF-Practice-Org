global class AccountUpdateBatchJob implements Database.Batchable<sObject>
{	
    global Set<string> setAccountId;
    global boolean runInTestMode = false;
    
    global AccountUpdateBatchJob(Boolean runInTestMode, Set<string> setAccountId) {
        this.runInTestMode 	= 	runInTestMode;
        this.setAccountId	=	setAccountId;
    }
    global AccountUpdateBatchJob() {}
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {	
        //AccountUpdateBatchJob accUpdateBatchJob = new AccountUpdateBatchJob(runInTestMode,setAccountId);
        //String query = accUpdateBatchJob.formQueryString(runInTestMode,setAccountId);
        String query;
        if(runInTestMode){
             query = 'SELECT Id,Name,AccountNumber '+
            'FROM Account '+
			'WHERE AccountNumber != NULL '+
            'AND Id IN :setAccountId';
        }else{
             query = 'SELECT Id,Name,AccountNumber '+
            'FROM Account '+
			'WHERE AccountNumber != NULL ';
        }
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
        List<Account> listAccountToUpdate = new List<Account>();
        for(Account acc : scope)
        {
            acc.Name = acc.Name + 'Updated by Batch job';
            listAccountToUpdate.add(acc);
            system.debug('i am True');
        }
        //update listAccountToUpdate;
    }
    global void finish(Database.BatchableContext BC) {
    }
    
    /*global String formQueryString(boolean runInTestMode,SET<string> accountId){
        String query = null;
        if(runInTestMode){
             query = 'SELECT Id,Name,AccountNumber '+
            'FROM Account '+
			'WHERE AccountNumber != NULL '+
            'AND Id IN :accountId';
        }else{
             query = 'SELECT Id,Name,AccountNumber '+
            'FROM Account '+
			'WHERE AccountNumber != NULL ';
        }
        return query;
    }*/
}