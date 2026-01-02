public class IntegrationWithQuickbook {

    
   /*public static void createCustomerInQB() {

       String requestBody = '{ "FullyQualifiedName": "Mohim Ahmad", "PrimaryEmailAddr": { "Address": "mohim@mail.com" }, "DisplayName": "Mohim Ahmad", "Suffix": "MA", "Title": "Mr", "MiddleName": "B", "Notes": "Here are other details.", "FamilyName": "Mohim", "PrimaryPhone": { "FreeFormNumber": "(555) 111-5555" }, "CompanyName": "Mohim AHMAD", "BillAddr": { "CountrySubDivisionCode": "CA", "City": "Mountain View", "PostalCode": "94042", "Line1": "123 Main Street", "Country": "USA" }, "GivenName": "Mohim" }';
       
       
       Http http = new Http();
       
       HttpRequest request = new HttpRequest();
       
       request.setEndpoint('callout:testnc/v3/company/9341451977253120/invoice?minorversion=69');
       
       request.setHeader('Content-Type', 'application/json');
       
       request.setHeader('Accept' , 'application/json');
       
       request.setMethod('POST');
       
       request.setBody(requestBody);
       
       RestRequest req = RestContext.request;
       
       HttpResponse response = new HttpResponse();
       
       response = http.send(request);
       
       system.debug('response body::::'+response.getBody());

   }
   public static void createInvoiceInQB() {

       //String requestBody = '{ "FullyQualifiedName": "Mohim Ahmad", "PrimaryEmailAddr": { "Address": "mohim@mail.com" }, "DisplayName": "Mohim Ahmad", "Suffix": "MA", "Title": "Mr", "MiddleName": "B", "Notes": "Here are other details.", "FamilyName": "Mohim", "PrimaryPhone": { "FreeFormNumber": "(555) 111-5555" }, "CompanyName": "Mohim AHMAD", "BillAddr": { "CountrySubDivisionCode": "CA", "City": "Mountain View", "PostalCode": "94042", "Line1": "123 Main Street", "Country": "USA" }, "GivenName": "Mohim" }';
       String requestBody ='{ "Line": [ { "DetailType": "SalesItemLineDetail", "Amount": 500.0, "SalesItemLineDetail": { "ItemRef": { "name": "Services", "value": "1" } } } ], "CustomerRef": { "value": "1" } }';
       
       Http http = new Http();
       
       HttpRequest request = new HttpRequest();
       
       request.setEndpoint('callout:testnc/v3/company/9341451977253120/invoice?minorversion=69');
       
       request.setHeader('Content-Type', 'application/json');
       
       request.setHeader('Accept' , 'application/json');
       
       request.setMethod('POST');
       
       request.setBody(requestBody);
       
       RestRequest req = RestContext.request;
       
       HttpResponse response = new HttpResponse();
       
       response = http.send(request);
       
       system.debug('response body::::'+response.getBody());

   }
    
   public static void getInvoiceFromQB() {

       Http http = new Http();
       HttpRequest request = new HttpRequest();
       request.setEndpoint('callout:testnc/v3/company/9341451977253120/invoice/147');       
       request.setMethod('GET');
       request.setHeader('Accept', 'application/json');
       request.setHeader('Content-Type', 'application/json');
       
       
      
       
       HttpResponse response = new HttpResponse();
      
       response = http.send(request);
       
       if(response.getStatusCode() == 200) {
           system.debug('response.getStatusCode()'+response.getStatusCode());
           system.debug('response.getBody() '+response.getBody());
           //return;
       }
       
       string jsonstring;
       jsonstring = response.getBody();
       system.debug(jsonstring);
       Map<String, Object> invoiceMap = new Map<String, Object>();
       //jsonstring = '{ "Invoice": { "TxnDate": "2014-09-19", "domain": "QBO", "PrintStatus": "NeedToPrint", "SalesTermRef": { "value": "3" }, "TotalAmt": 362.07, "Line": [ { "Description": "Rock Fountain", "DetailType": "SalesItemLineDetail", "SalesItemLineDetail": { "TaxCodeRef": { "value": "TAX" }, "Qty": 1, "UnitPrice": 275, "ItemRef": { "name": "Rock Fountain", "value": "5" } }, "LineNum": 1, "Amount": 275.0, "Id": "1" }, { "Description": "Fountain Pump", "DetailType": "SalesItemLineDetail", "SalesItemLineDetail": { "TaxCodeRef": { "value": "TAX" }, "Qty": 1, "UnitPrice": 12.75, "ItemRef": { "name": "Pump", "value": "11" } }, "LineNum": 2, "Amount": 12.75, "Id": "2" }, { "Description": "Concrete for fountain installation", "DetailType": "SalesItemLineDetail", "SalesItemLineDetail": { "TaxCodeRef": { "value": "TAX" }, "Qty": 5, "UnitPrice": 9.5, "ItemRef": { "name": "Concrete", "value": "3" } }, "LineNum": 3, "Amount": 47.5, "Id": "3" }, { "DetailType": "SubTotalLineDetail", "Amount": 335.25, "SubTotalLineDetail": {} } ], "DueDate": "2014-10-19", "ApplyTaxAfterDiscount": false, "DocNumber": "1037", "sparse": false, "CustomerMemo": { "value": "Thank you for your business and have a great day!" }, "ProjectRef": { "value": "39298045" }, "Deposit": 0, "Balance": 362.07, "CustomerRef": { "name": "Sonnenschein Family Store", "value": "24" }, "TxnTaxDetail": { "TxnTaxCodeRef": { "value": "2" }, "TotalTax": 26.82, "TaxLine": [ { "DetailType": "TaxLineDetail", "Amount": 26.82, "TaxLineDetail": { "NetAmountTaxable": 335.25, "TaxPercent": 8, "TaxRateRef": { "value": "3" }, "PercentBased": true } } ] }, "SyncToken": "0", "LinkedTxn": [ { "TxnId": "100", "TxnType": "Estimate" } ], "BillEmail": { "Address": "Familiystore@intuit.com" }, "ShipAddr": { "City": "Middlefield", "Line1": "5647 Cypress Hill Ave.", "PostalCode": "94303", "Lat": "37.4238562", "Long": "-122.1141681", "CountrySubDivisionCode": "CA", "Id": "25" }, "EmailStatus": "NotSet", "BillAddr": { "Line4": "Middlefield, CA  94303", "Line3": "5647 Cypress Hill Ave.", "Line2": "Sonnenschein Family Store", "Line1": "Russ Sonnenschein", "Long": "-122.1141681", "Lat": "37.4238562", "Id": "95" }, "MetaData": { "CreateTime": "2014-09-19T13:16:17-07:00", "LastUpdatedTime": "2014-09-19T13:16:17-07:00" }, "CustomField": [ { "DefinitionId": "1", "StringValue": "102", "Type": "StringType", "Name": "Crew #" } ], "Id": "130" }, "time": "2015-07-24T10:48:27.082-07:00" }';
       try{ 
           invoiceMap = (Map<String, Object>) JSON.deserializeUntyped(jsonstring);
       }catch(Exception e)
       {
           system.debug('e :'+jsonstring);
       }
        
        // Extract Invoice details
        Map<String, Object> invoiceDetails 	= (Map<String, Object>) invoiceMap.get('Invoice');
        String txnDate 						= (String) invoiceDetails.get('TxnDate');
        String printStatus 					= (String) invoiceDetails.get('PrintStatus');
        Double totalAmt 					= (Double) invoiceDetails.get('TotalAmt');
        String dueDate 						= (String) invoiceDetails.get('DueDate');
        String docNumber 					= (String) invoiceDetails.get('DocNumber');
        Boolean applyTaxAfterDiscount 		= (Boolean) invoiceDetails.get('ApplyTaxAfterDiscount');
        Boolean sparse 						= (Boolean) invoiceDetails.get('sparse');
        Double deposit 						= (Double) invoiceDetails.get('Deposit');
        Double balance 						= (Double) invoiceDetails.get('Balance');
       
        // Extract Customer details
        Map<String, Object> customerRef = (Map<String, Object>) invoiceDetails.get('CustomerRef');
        String customerName 			= (String) customerRef.get('name');
        String customerId 				= (String) customerRef.get('value');
        
        // Extract Ship Address details
        Map<String, Object> shipAddr 	= (Map<String, Object>) invoiceDetails.get('ShipAddr');
        String shipCity 				= (String) shipAddr.get('City');
        String shipLine1 				= (String) shipAddr.get('Line1');
        String shipPostalCode 			= (String) shipAddr.get('PostalCode');
        
        // Extract Bill Address details
        Map<String, Object> billAddr = (Map<String, Object>) invoiceDetails.get('BillAddr');
        String billLine1 = (String) billAddr.get('Line1');
        String billLine2 = (String) billAddr.get('Line2');
        String billLine3 = (String) billAddr.get('Line3');
        String billLine4 = (String) billAddr.get('Line4');
        
        // Extract Tax details
        Map<String, Object> txnTaxDetail 	= (Map<String, Object>) invoiceDetails.get('TxnTaxDetail');
        Double totalTax 					= (Double) txnTaxDetail.get('TotalTax');


        system.debug('txnDate'+txnDate);
        system.debug('printStatus'+printStatus);
        system.debug('deposit'+deposit);
        system.debug('balance'+balance);
        system.debug('customerId'+customerId);
        system.debug('shipCity'+shipCity);
        system.debug('billLine2'+billLine2);
        system.debug('totalTax'+totalTax);
   }*/


}