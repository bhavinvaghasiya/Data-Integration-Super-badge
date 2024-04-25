/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-24-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
global class ProjectCalloutServiceMockFailure implements HttpCalloutMock{
   
   global HTTPResponse respond(HTTPRequest request){

      HttpResponse response = new HttpResponse();
       response.setHeader('Content-Type', 'application/json');
       response.setStatus('Bad Response');
       response.setStatusCode(500);
              
       return response;
   }
}