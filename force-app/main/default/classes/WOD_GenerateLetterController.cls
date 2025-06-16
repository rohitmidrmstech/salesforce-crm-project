/**
 * @description This class is used for Prepare Letter of Claim/Warranty Registration and Transfer.
*/
public with sharing  class WOD_GenerateLetterController {
    /**
	 * @description to get Latter data
	 * @param recordId Claim/WR/WT Id
	 * @return Wrapper
	*/
    @AuraEnabled
    public  static ResponseWrapper getRecord(String recordId){
        
        try{
            String clmPrefix=WOD_2__Claim__c.sobjectType.getDescribe().getKeyPrefix();
            String WRPrefix=WOD_2__Warranty_Registration__c.sobjectType.getDescribe().getKeyPrefix();
            String WTPrefix=WOD_Warranty_Transfer__c.sobjectType.getDescribe().getKeyPrefix();
            if(recordId.startsWithIgnoreCase(clmPrefix)){
                 WOD_2__Claim__c clm  = [SELECT ID , name,First_Name__c,Email__c,Business_Units__c,ClaimType__c,Letter_Date__c,Letter_Date_2__c,Sample_Date_2__c,QC_Date_2__c,QC_Date__c from WOD_2__Claim__c where ID =:recordId LIMIT 1];
                if(clm.QC_Date__c!=null && clm.Letter_Date__c==null){
                  clm.Letter_Date__c=date.today();  
                }
                else if(clm.QC_Date_2__c!=null && clm.Letter_Date_2__c==null ){
                   clm.Letter_Date_2__c=date.today();   
                }
                update clm;
                ResponseWrapper resp = new ResponseWrapper('Success', clm, 'WOD_2__Claim__c');
                return resp;
            }
            else if(recordId.startsWithIgnoreCase(WRPrefix)){
                WOD_2__Warranty_Registration__c wr  = [SELECT ID , name,Email__c,Business_Units__c from WOD_2__Warranty_Registration__c where ID =:recordId LIMIT 1];
                ResponseWrapper resp = new ResponseWrapper('Success', wr, 'WOD_2__Warranty_Registration__c');
                return resp;
            }
            else if(recordId.startsWithIgnoreCase(WTPrefix)){
                WOD_Warranty_Transfer__c wt  = [SELECT ID , name,First_Name__c,Email__c,Business_Units__c from WOD_Warranty_Transfer__c where ID =:recordId LIMIT 1];
                ResponseWrapper resp = new ResponseWrapper('Success', wt, 'WOD_Warranty_Transfer__c');
                return resp;
            }else{
                String msg =  'Error : Invalid Record Id'; 
                ResponseWrapper resp = new ResponseWrapper(msg, null, '');
                return resp;
            }
        }catch(Exception ex){
            String msg =  'Error : '+ ex.getMessage(); 
            ResponseWrapper resp = new ResponseWrapper(msg, null, '');
            return resp;
        }
    }
    
    /**
     * @description Wrapper Class
    */
    public class ResponseWrapper{
        @AuraEnabled
        public String status;
        @AuraEnabled
        public sObject sObjectR;
        @AuraEnabled
        public String objectName;
         
        public ResponseWrapper(String st, sObject obj, String objName){
            status  =st;
            sObjectR= obj;
            objectName = objName;
        }
    }
}