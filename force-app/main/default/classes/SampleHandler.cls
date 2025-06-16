public class SampleHandler {
    
    public static void SetSampleDateonClaim(Map<id,WOD_Sampling_QC__c> newMap) {
        Set<id> ids = new set<id>();
        try{
            for(WOD_Sampling_QC__c sam : newMap.values()) {
           ids.add(sam.claim__c); 
        }
       
        List<WOD_2__Claim__c> updatedClaims = new List<WOD_2__Claim__c>();
		Map<id, WOD_2__Claim__c> claimMap = new Map<id, WOD_2__Claim__c>([Select id,Business_Units__c from WOD_2__Claim__c where id IN : ids]);
        List<WOD_Sampling_QC__c> sampleList = [Select id,Samples_Received_Date__c, createdDate, claim__c from WOD_Sampling_QC__c where claim__c IN : ids order by createdDate ASC];
        
        
        for(WOD_2__Claim__c claim : claimMap.values()) {
            
                if(claim.Business_Units__c == 'Roofing') {
                    
                claim.Sample_Date__c = sampleList[0].Samples_Received_Date__c; 
                    if(sampleList.size() > 1) {
                claim.Sample_Date_2__c =  sampleList[1].Samples_Received_Date__c; 
                    }  
                  updatedClaims.add(claim);  
                }              
            
        }
        
        Update updatedClaims;

        }catch(exception e){
            system.debug(e.getMessage());
        }
          	
}
}