public with sharing class OpportunityEditController {
    
    public Opportunity opp{get;set;}
    public String recTypName{get;set;}
    public String recTypID{get;set;}
    
    public OpportunityEditController(ApexPages.StandardController sc) {
        String oId = ApexPages.currentPage().getParameters().get('id');
        recTypID = ApexPages.currentPage().getParameters().get('RecordType');
        List<Opportunity> oppLst = DataBase.query('SELECT Owner.Name,RecordType.Name,'+getFields('Opportunity')+' FROM Opportunity WHERE ID = :oId');
        if(oppLst!=null && oppLst.size() > 0) { opp = oppLst.get(0); }
        if(recTypID!=null && recTypID!=''){
            List<RecordType> rtLst = [SELECT ID,Name FROM RecordType WHERE ID=:recTypID];
            if(rtLst!=null && rtLst.size()>0){ 
                recTypName = rtLst.get(0).Name; 
                opp.RecordTypeID = rtLst.get(0).ID; 
            }
        }
        
    }
    
    public Pagereference checkUserRegion() { 
        try {
            Pagereference pr; 
            String oId = ApexPages.currentPage().getParameters().get('id');
            String recTypeID = ApexPages.currentPage().getParameters().get('RecordType');
            String strRType = '';
            if(recTypeID !=null && recTypeID !=''){
                strRType = '&RecordType='+recTypeID;
            }
            List<User> listUser = [Select Id from User where Id = :Userinfo.getUserId() and (Profile.Name like '%Canada%' or Profile.Name = 'Custom Standard Profile' or Profile.Name = 'Super User')];
            if(listUser.size() == 0) {
              //  pr.getParameters().put('RecordType', recordTypeId);
                pr = new Pagereference('/' + oId + '/e?nooverride=1&retURL=' + oId+strRType);
                return pr;
            }
            return null;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,e.getMessage()));
            return null;
        }
    }
    public class CustomException extends Exception{}
    public Pagereference doSave() {
        SavePoint sp = Database.setSavePoint();
        try{
            upsert opp;
        } catch (Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getMessage()));
            Database.rollBack(sp);
            return null;
        }
        return new PageReference('/'+opp.Id);
    }
    
    /*
    @Name   :getFields
    @Description :Returns comma seperated list of fields for a given object
    */
    public String getFields(String strSObjectName) {
        SObjectType sot = Schema.getGlobalDescribe().get(strSObjectName);
        if (sot == null) return null;
        List<Schema.SObjectField> lstFields = sot.getDescribe().fields.getMap().values();
        String strReturn = '';
        for(Integer i = 0; i < lstFields.size(); i++){
           if(i == lstFields.size() - 1){
               strReturn += lstFields.get(i).getDescribe().Name;
           } else {
               strReturn += lstFields.get(i).getDescribe().Name + ',';
           }
        }
        return strReturn;
    }
}