@RestResource(urlMapping='/stripe/webhook/v2/*')
global without sharing class StripeWebhookListnerV1 {
  @HttpPost
    global static void doPost() {
        RestResponse response = RestContext.response;
		response.addHeader('content-type','application/json');
        String responseString = RestContext.request.requestBody.toString();
        response.responseBody = Blob.valueOf('{success:true,event:"unknown"}');
        response.statusCode = 200;
        System.debug('test');
    }
    
    @HttpGet
    global static string doGet() {
        return '{"message":"Hello from stripe webhook v2}';
       
    }
}