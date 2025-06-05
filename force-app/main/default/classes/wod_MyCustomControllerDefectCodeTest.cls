/**
 * @description Test class for wod_MyCustomControllerDefectCode
*/
@isTest(SeeAllData = false)
public class wod_MyCustomControllerDefectCodeTest {
    /**
     * @description data set up and execution
    */
    public static testMethod void defectControllerTest(){
        PageReference pageRef = Page.SelectDefectCodeFlow;
        Test.setCurrentPage(pageRef);
        WOD_Questionnaire__c qsnR = new WOD_Questionnaire__c(Business_Units__c = 'Roofing', Effective_from_date__c = System.today().addDays(-30), 
        Effective_to_date__c = SYstem.today().addDays(30));
        insert qsnR;
        
        WOD_Section__c sec = new WOD_Section__c(Questionnaire__c = qsnR.Id, Section_Heading_Key__c = '1', Section_Heading_Value__c= 'test', Priority__c= 1);
        insert sec;
        
        WOD_Question__c qsn = new WOD_Question__c(/*Name = 'test' ,*/ Section__c = sec.Id, Priority__c=1);
        insert qsn;
        
        //Lab_Analysis__c lb = new Lab_Analysis__c(Date_of_Manufacture__c=system.today());
        
        wod_MyCustomControllerDefectCode obj = new wod_MyCustomControllerDefectCode();
        Map<String, Object> myMap = new Map<String, Object>();
        
        Account acc = WOD_TestDataFactory.createAccount('Tavant','','Customer');
        insert acc;
        WOD_2__Claim__c claim = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');        
        insert claim;

        
        WOD_Sampling_QC__c  sample=new WOD_Sampling_QC__c();
        sample.claim__c=claim.Id;
        insert sample;
        
        WOD_2__Warranty_Registration__c wr = WOD_TestDataFactory.createWarrantyRegistration('Residential','Roofing');
        insert wr;
        WOD_Inspection__c inspection = new WOD_Inspection__c();
        insert inspection;
        List<String>  insIds = new List<String>();
        insIds.add(inspection.Id);
        
        WOD_Report_Status__c rs = new WOD_Report_Status__c();
        insert rs;
        WOD_Answer__c ans = new WOD_Answer__c(Question__c = qsn.Id, Inspection__c =inspection.Id,Related_Record_Id__c=inspection.Id  );
        insert ans;
        
        
        myMap.put('varSamplingQC', sample.Id);
        myMap.put('varClaim', claim.ID);
        //obj.theFlow= new Flow.Interview.Perform_Lab_Analysis_siding_flow(myMap);
        obj.getNewLabRecord();
        
        wod_MyCustomControllerDefectCode.getClaimId(sample.Id);
        wod_MyCustomControllerDefectCode.getwrId(wr.Id);
        wod_MyCustomControllerDefectCode.getClaim(claim.Id);
        wod_MyCustomControllerDefectCode.getInspectionRecords(insIds);
        wod_MyCustomControllerDefectCode.updateClaim(claim.id);
        wod_MyCustomControllerDefectCode.reportStatus(rs.Id);
        obj.getmyID();
        
    }

}