global with sharing class IncentiveHeaderToSAP {
    
    global final static String APPROVED = 'Approved';
    
    global with sharing class IncentiveHeaderDetails{
        
        webservice String IncentiveId;        
        webservice String SAPContactNumber;
        webservice String SalesOrg;
        webservice String AgreementType;
        webservice String Recipient;        
        webservice DateTime StartDate;
        webservice DateTime EndDate;
        webservice String ApprovalStatus;
        webservice String ExternalDescription;
        webservice String AgreementDescription;
        
    }
    
    webservice static List<IncentiveHeaderDetails> getIncentiveHeaderDetails(){
        
        List<IncentiveHeaderDetails> incHeaderDetailsList = new List<IncentiveHeaderDetails>();
        IncentiveHeaderDetails incHeaderDetail;
        
       /* String queryString = 'SELECT';
        queryString += ' Id, SAP_Contract_Number__c, Sales_Org__c, Agreement_Type__c, Recipient__c, Start_Date__c, End_Date__c, Status__c, External_Description__c, Agreement_Description__c ';                       
        queryString += ' FROM Incentive__c ';
        queryString += ' WHERE Status__c = :APPROVED';
        queryString += ' AND Send_to_SAP__c= True';
        queryString += ' AND Sent_to_SAP__c= False';
         
        List<Incentive__c> incentiveList = Database.query(queryString);
        
        if(incentiveList.size() > 0 ){
            for(Incentive__c incentive : incentiveList){
                
                 incHeaderDetail = new IncentiveHeaderDetails();
                 incHeaderDetail.IncentiveId = incentive.Id;
                 incHeaderDetail.SAPContactNumber = incentive.SAP_Contract_Number__c;
                 incHeaderDetail.SalesOrg = incentive.Sales_Org__c;
                 incHeaderDetail.AgreementType = incentive.Agreement_Type__c;
                 incHeaderDetail.Recipient = incentive.Recipient__c;
                 incHeaderDetail.StartDate = incentive.Start_Date__c;
                 incHeaderDetail.EndDate = incentive.End_Date__c;
                 incHeaderDetail.ApprovalStatus = incentive.Status__c;
                 incHeaderDetail.ExternalDescription = incentive.External_Description__c;
                 incHeaderDetail.AgreementDescription = incentive.Agreement_Description__c;
                
                 incHeaderDetailsList.add(incHeaderDetail);
            }
        }*/
        return incHeaderDetailsList;
    }  
}