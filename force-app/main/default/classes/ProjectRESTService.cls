/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-24-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@RestResource(urlMapping = '/project/*')
global with sharing class ProjectRESTService {
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId,
                                       Date StartDate, Date EndDate, Double Amount, String Status){
        String retMsg = 'Error';
                
        SavePoint sp1 = Database.setSavePoint();
        try{
            List<Opportunity> lstOfOpps = new List<Opportunity>();
            
            if(OpportunityId != null && OpportunityId.trim().length() > 0){
                Opportunity opp = [SELECT Id, DeliveryInstallationStatus__c, Decimal_Percent__c FROM Opportunity WHERE Id = :OpportunityId];
                opp.DeliveryInstallationStatus__c = 'In progress';
                                
                lstOfOpps.add(opp);
            }
            UPDATE lstOfOpps;
            
            List<Project__c> lstOfRrjts = new List<Project__c>();
            
            Project__c prjt = new Project__c();
            prjt.ProjectRef__c = ProjectRef;
            prjt.Name = ProjectName;
            prjt.Opportunity__c = OpportunityId;
            prjt.Start_Date__c = StartDate;
            prjt.End_Date__c = EndDate;
            prjt.Billable_Amount__c = Amount;
            prjt.Status__c = Status;
            
            lstOfRrjts.add(prjt);
            
            UPSERT lstOfRrjts;
            
            retMsg = 'OK';
        }catch(Exception ex){
            Database.rollback(sp1);
            retMsg = ex.getMessage();
        }
        return retMsg;
    }
}