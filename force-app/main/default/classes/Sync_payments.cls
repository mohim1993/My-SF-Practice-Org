public class Sync_payments {
    @AuraEnabled()
    public static void executecalloutToQBToCreateInvoice(Id invoiceId){ 
        system.debug('invoiceId '+invoiceId);
        Invoices__c inv = [SELECT Id, Invoice_ID__c FROM Invoices__c WHERE ID = :invoiceId];
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:testnc/v3/company/9341451977253120/invoice/'+inv.Invoice_ID__c);       
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Content-Type', 'application/json');
        
        HttpResponse response = new HttpResponse();
        response = http.send(request);
        if(response.getStatusCode() != 200) {
            system.debug('response.getStatusCode()'+response.getStatusCode());
            system.debug('response.getBody() '+response.getBody());
            return;
        }
        
        List<Payment__c>listSFPayments = [SELECT Id, QB_Invoice__c,QB_Payment_ID__c FROM Payment__c WHERE QB_Invoice__c = :invoiceId];
        List<String> listSFPaymentIds = New List<String>();
        for(Payment__c payment : listSFPayments){
            listSFPaymentIds.add(payment.QB_Payment_ID__c);
        }
        string jsonstring;
        jsonstring = response.getBody();
        system.debug(jsonstring);
        Map<String, Object> invoiceMap = new Map<String, Object>();
        //jsonstring = '{ "Invoice": { "TxnDate": "2014-09-19", "domain": "QBO", "PrintStatus": "NeedToPrint", "SalesTermRef": { "value": "3" }, "TotalAmt": 362.07, "Line": [ { "Description": "Rock Fountain", "DetailType": "SalesItemLineDetail", "SalesItemLineDetail": { "TaxCodeRef": { "value": "TAX" }, "Qty": 1, "UnitPrice": 275, "ItemRef": { "name": "Rock Fountain", "value": "5" } }, "LineNum": 1, "Amount": 275.0, "Id": "1" }, { "Description": "Fountain Pump", "DetailType": "SalesItemLineDetail", "SalesItemLineDetail": { "TaxCodeRef": { "value": "TAX" }, "Qty": 1, "UnitPrice": 12.75, "ItemRef": { "name": "Pump", "value": "11" } }, "LineNum": 2, "Amount": 12.75, "Id": "2" }, { "Description": "Concrete for fountain installation", "DetailType": "SalesItemLineDetail", "SalesItemLineDetail": { "TaxCodeRef": { "value": "TAX" }, "Qty": 5, "UnitPrice": 9.5, "ItemRef": { "name": "Concrete", "value": "3" } }, "LineNum": 3, "Amount": 47.5, "Id": "3" }, { "DetailType": "SubTotalLineDetail", "Amount": 335.25, "SubTotalLineDetail": {} } ], "DueDate": "2014-10-19", "ApplyTaxAfterDiscount": false, "DocNumber": "1037", "sparse": false, "CustomerMemo": { "value": "Thank you for your business and have a great day!" }, "ProjectRef": { "value": "39298045" }, "Deposit": 0, "Balance": 362.07, "CustomerRef": { "name": "Sonnenschein Family Store", "value": "24" }, "TxnTaxDetail": { "TxnTaxCodeRef": { "value": "2" }, "TotalTax": 26.82, "TaxLine": [ { "DetailType": "TaxLineDetail", "Amount": 26.82, "TaxLineDetail": { "NetAmountTaxable": 335.25, "TaxPercent": 8, "TaxRateRef": { "value": "3" }, "PercentBased": true } } ] }, "SyncToken": "0", "LinkedTxn": [ { "TxnId": "100", "TxnType": "Estimate" } ], "BillEmail": { "Address": "Familiystore@intuit.com" }, "ShipAddr": { "City": "Middlefield", "Line1": "5647 Cypress Hill Ave.", "PostalCode": "94303", "Lat": "37.4238562", "Long": "-122.1141681", "CountrySubDivisionCode": "CA", "Id": "25" }, "EmailStatus": "NotSet", "BillAddr": { "Line4": "Middlefield, CA  94303", "Line3": "5647 Cypress Hill Ave.", "Line2": "Sonnenschein Family Store", "Line1": "Russ Sonnenschein", "Long": "-122.1141681", "Lat": "37.4238562", "Id": "95" }, "MetaData": { "CreateTime": "2014-09-19T13:16:17-07:00", "LastUpdatedTime": "2014-09-19T13:16:17-07:00" }, "CustomField": [ { "DefinitionId": "1", "StringValue": "102", "Type": "StringType", "Name": "Crew #" } ], "Id": "130" }, "time": "2015-07-24T10:48:27.082-07:00" }';
        try{ 
            invoiceMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstring);
        }catch(Exception e){
            system.debug('e :'+jsonstring);
        }
        
        // Extract Invoice details
        Map<String, Object> invoiceDetails = (Map<String, Object>) invoiceMap.get('Invoice');
        system.debug ('LinkedTxn : '+invoiceDetails.get('LinkedTxn'));
        
        
        // Access LinkedTxn array
        List<Object> linkedTxnList = (List<Object>) invoiceDetails.get('LinkedTxn');
        String formattedPaymentId = '';
        List<String> listQBPaymentIds = New List<String>();
        for (Object linkedTxnObj : linkedTxnList) {
            Map<String, Object> linkedTxn 	= (Map<String,Object>) linkedTxnObj;
            String txnId 					= (String) linkedTxn.get('TxnId');
            String txnType 					= (String) linkedTxn.get('TxnType');
            if(txnType != null && txnType=='Payment'){
                listQBPaymentIds.add(txnId);
            }
        }
        
        if(!listQBPaymentIds.isEmpty()){
            Set<String> newPaymentIds = new Set<String>();
            newPaymentIds = Sync_payments.compareLists(listSFPaymentIds, listQBPaymentIds);
            system.debug('listSFPaymentIds : '+listSFPaymentIds);
            system.debug('listQBPaymentIds : '+listQBPaymentIds);
            if(!newPaymentIds.isEmpty()){
                for(string payid : newPaymentIds){
                     formattedPaymentId += '\'' + payid + '\', ';
                }
            }
            system.debug('newPaymentIds : '+newPaymentIds);
        }
        
        // Remove the trailing comma and space
        if (formattedPaymentId.length() > 0) {
            formattedPaymentId = formattedPaymentId.substring(0, formattedPaymentId.length() - 2);
        }
        
        String paymentQuery 	= '';
        if(formattedPaymentId != ''){
            paymentQuery = 'select * from Payment Where Id IN '+'( '+formattedPaymentId+' )';
        }
        
       
        if(formattedPaymentId != null){
            Http httpPayments = new Http();
            HttpRequest requestPayments = new HttpRequest();
            String encoded = EncodingUtil.urlEncode(paymentQuery, 'UTF-8');
            request.setEndpoint('callout:testnc/v3/company/9341451977253120/query?query='+encoded);       
            request.setMethod('GET');
            request.setHeader('Accept', 'application/json');
            request.setHeader('Content-Type', 'application/json');
            
            HttpResponse responsePayments = new HttpResponse();
            
            responsePayments = httpPayments.send(request);
            
            if(responsePayments.getStatusCode() != 200) {
                system.debug('response.getStatusCode()'+response.getStatusCode());
                system.debug('response.getBody() '+response.getBody());
                return;
            }
            
            string jsonstringPayments;
            jsonstringPayments = responsePayments.getBody();
            system.debug('jsonstringPayments '+jsonstringPayments);
            
            Sync_payments.parsePaymentJSON(jsonstringPayments,invoiceId); 
        }
        
    }
    
    
    public static void parsePaymentJSON(String jsonString, String invoiceId) {
        Map<String, Object> jsonData 				= (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        Map<String, Object> queryResponse 			= (Map<String, Object>) jsonData.get('QueryResponse');
        List<Object> payments 						= (List<Object>) queryResponse.get('Payment');
        List<Payment__c> listQBPaymentToCreate 		= New List<Payment__c>();
        
        // Iterate through the payments
        for (Object paymentObj : payments) {
            Payment__c qbPaymentToCreate 	= new  Payment__c();
            
            Map<String, Object> payment 	= (Map<String, Object>) paymentObj;
            
            Map<String, Object> customerRef = (Map<String, Object>) payment.get('CustomerRef');
            String customerValue 			= (String) customerRef.get('value');
            String customerName 			= (String) customerRef.get('name');
            
            Map<String, Object> depositToAccountRef = (Map<String, Object>) payment.get('DepositToAccountRef');
            //Double depositValue = (Double) depositToAccountRef.get('value');
            
            Decimal totalAmt 		= (Decimal) payment.get('TotalAmt');
            Decimal unappliedAmt 	= (Decimal) payment.get('UnappliedAmt');
            Boolean processPayment 	= (Boolean) payment.get('ProcessPayment');
            String domain 			= (String) payment.get('domain');
            Boolean sparse 			= (Boolean) payment.get('sparse');
            String id 				= (String) payment.get('Id');
            String syncToken 		= (String) payment.get('SyncToken');
            
            Map<String, Object> metaData 	= (Map<String, Object>) payment.get('MetaData');
            String createTime 				= (String) metaData.get('CreateTime');
            String lastUpdatedTime 			= (String) metaData.get('LastUpdatedTime');
            String txnDate 					= (String) payment.get('TxnDate');
            
            Map<String, Object> currencyRef = (Map<String, Object>) payment.get('CurrencyRef');
            String currencyValue 			= (String) currencyRef.get('value');
            String currencyName 			= (String) currencyRef.get('name');
            
            List<Object> lines = (List<Object>) payment.get('Line');
            
            // Iterate through the lines
            for (Object lineObj : lines) {
                Map<String, Object> line = (Map<String, Object>) lineObj;
                Decimal amount = (Decimal) line.get('Amount');
                
                List<Object> linkedTxns = (List<Object>) line.get('LinkedTxn');
                
                // Iterate through linked transactions
                for (Object linkedTxnObj : linkedTxns) {
                    Map<String, Object> linkedTxn = (Map<String, Object>) linkedTxnObj;
                    String txnId = (String) linkedTxn.get('TxnId');
                    String txnType = (String) linkedTxn.get('TxnType');
                }
                
            }
            
            qbPaymentToCreate.Customer_Name__c 		= customerName;
            qbPaymentToCreate.Customer_Value__c 	= customerValue;
            qbPaymentToCreate.Currency_Name__c 		= currencyName;
            qbPaymentToCreate.Currency_Value__c 	= currencyValue;
            qbPaymentToCreate.Sync_Token__c 		= syncToken;
            qbPaymentToCreate.QB_Payment_ID__c 		= (String)id;
            qbPaymentToCreate.QB_Invoice__c 		= invoiceId; 
            qbPaymentToCreate.Process_Payment__c 	= processPayment;
            qbPaymentToCreate.Unapplied_Amount__c 	= unappliedAmt;
            qbPaymentToCreate.Total_Amount__c 		= (Double)totalAmt;
            //qbPaymentToCreate.Deposit_Value__c 		= (Double)depositValue;

            // Log the details
            System.debug('Customer Value: ' + customerValue);
            System.debug('Customer Name: ' + customerName);
            System.debug('Total Amount: ' + totalAmt);
            System.debug('Unapplied Amount: ' + unappliedAmt);
            System.debug('Process Payment: ' + processPayment);
            System.debug('Domain: ' + domain);
            System.debug('Sparse: ' + sparse);
            System.debug('Id: ' + id);
            System.debug('Sync Token: ' + syncToken);
            System.debug('Create Time: ' + createTime);
            System.debug('Last Updated Time: ' + lastUpdatedTime);
            System.debug('Transaction Date: ' + txnDate);
            System.debug('Currency Value: ' + currencyValue);
            System.debug('Currency Name: ' + currencyName);
            
            listQBPaymentToCreate.add(qbPaymentToCreate);
        }
        
        if(!listQBPaymentToCreate.isEmpty()){
            insert listQBPaymentToCreate;
        }
    }
    
    
    public static Set<String> compareLists(List<String> list1, List<String> list2) {
        list1.sort();
        list2.sort();
        Set<String> difference2 = new Set<String>();
        
        Boolean areListsEqual = list1.equals(list2);
        
        if (areListsEqual) {
            System.debug('The lists contain the same values.');
            return difference2;  // Return an empty set if the lists are equal
        } else {
            System.debug('The lists do not contain the same values.');
            Set<String> set1 = new Set<String>(list1);
            Set<String> set2 = new Set<String>(list2);
            
            difference2 = set2.clone();
            difference2.removeAll(set1);
            System.debug('Values in list2 but not in list1: ' + difference2);
            return difference2;  
        }
    }


}