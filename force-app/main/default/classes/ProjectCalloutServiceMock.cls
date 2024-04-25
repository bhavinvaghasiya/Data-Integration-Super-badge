/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-24-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
global class ProjectCalloutServiceMock implements HttpCalloutMock{

   global HTTPResponse respond(HTTPRequest request){

      HttpResponse response = new HttpResponse();
       response.setHeader('Content-Type', 'application/json');
       response.setStatus('OK');
       response.setStatusCode(201);
              
       return response;
   }
}