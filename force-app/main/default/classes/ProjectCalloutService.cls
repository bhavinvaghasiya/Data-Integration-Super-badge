/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-24-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod
	public static void postOpportunityToPMS(List<Id> oppoIds){
        Opportunity opp = [SELECT Id, Name, Account.Name, CloseDate, Amount FROM Opportunity WHERE Id = :oppoIds[0]];
        String serviceToken = ServiceTokens__c.getValues('ProjectServiceToken').Token__c;
        
        String jsonInput = '{\n' +
            ' "opportunityId" : "'+opp.Id+'",\n'+
            ' "opportunityName" : "'+opp.Name+'",\n'+
            ' "accountName" : "'+opp.Account.Name+'",\n'+
            ' "closeDate" : "'+String.ValueOf(opp.CloseDate).mid(0,10)+'",\n'+   
            ' "amount" : "'+opp.Amount+'"\n}';

        System.enqueueJob(new QueueablePMSCall(serviceToken, jsonInput, opp.Id));
    }

    class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts{
        private String serviceToken;
        private String jasonInput;
        private Id oppId;

        public QueueablePMSCall(String serviceToken, String jasonInput, Id oppId){
            this.serviceToken = serviceToken;
            this.jasonInput = jasonInput;
            this.oppId = oppId;
        }

        public void execute(QueueableContext qc){
            postToPMS(serviceToken, jasonInput, oppId);
        }
    }

    @Future(callout=true)
    private static void postToPMS(String serviceToken, String jsonInput, Id oppoId){
        HTTPRequest req = new HTTPRequest();
        req.setEndPoint('callout:ProjectService');
        req.setMethod('POST');
        req.setHeader('token',serviceToken);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setBody(jsonInput);
        
        HTTP http = new HTTP();
        HTTPResponse res = http.send(req);
        
        Opportunity opp = new Opportunity(Id=oppoId);
        if(res.getStatusCode() == 201){
            opp.StageName = 'Submitted Project';                
            System.debug('Success: ' + res.getStatus());
        }else{
            opp.StageName = 'Resubmit Project';
            System.debug('Failure: ' + res.getStatusCode() + ' ' + res.getStatus());
        }
        update opp;
    }
}